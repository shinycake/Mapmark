//
//  EditLocationView.swift
//  Map Duck
//
//  Created by Idan Birman on 29/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import CoreLocation

struct EditLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var location : SavedLocation
    
    @State var isShowingDeleteAlert = false
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.square").font(.largeTitle).foregroundColor(.red).padding()
                }
                Spacer()
                Text("Edit Location").font(.largeTitle).padding()
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    Dao.sharedInstance.saveContext()
                }) {
                    Image(systemName: "checkmark.square.fill").font(.largeTitle).foregroundColor(.green).padding()
                }
            }
            Form {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Title:")
                            TextField("Home, Work, etc..." , text: $location.title.bound)
                               .background(Color(UIColor(white: 0.0, alpha: 0.05)))
                               .cornerRadius(5)
                        }
                        Button(action: {
                            let location = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
                            location.placemark { (placemark) in
                                var suggestedTitle = ""
                                let space = " "
                                let comma = ","
                                
                                if let street = placemark.thoroughfare {
                                    suggestedTitle += street + space
                                }
                    
                                if let subStreet = placemark.subThoroughfare {
                                    suggestedTitle += subStreet + comma + space
                                }
                                
                                if let city = placemark.locality {
                                   suggestedTitle += city + comma + space
                                }
                            
                                if let isoCountryCode = placemark.isoCountryCode {
                                    suggestedTitle += isoCountryCode
                                }
                                
                                self.location.title = suggestedTitle
                                self.location.objectWillChange.send()
                            }
                        }) {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 32))
                            .padding()
                        }
                        
                    }
                    VStack(alignment: .leading) {
                        Text("Remarks: ")
                        TextArea(text: $location.remarks.bound)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                            .cornerRadius(10)
                    }
                   
                }
                Section {
                    VStack(alignment: .leading) {
                        Text("Tags:")
                        TagsList(location: location,editingEnabled: true)
                    }
                }
                Section {
                    Button(action: {
                        self.isShowingDeleteAlert.toggle()
                        print("delete")
                    }) {
                        HStack() {
                            Spacer()
                            Text("Delete").foregroundColor(.red)
                            Image(systemName: "trash").foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .alert(isPresented:$isShowingDeleteAlert) {
                        Alert(title: Text("Delete this location?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                            Dao.sharedInstance.persistentContainer.viewContext.delete(self.location)
                            self.presentationMode.wrappedValue.dismiss()
                        }, secondaryButton: .cancel())
                    }
                }
            }
            .padding(0)
        }
            
        
    }
}

struct EditLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationView(location: SavedLocation.dummy())
    }
}

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
