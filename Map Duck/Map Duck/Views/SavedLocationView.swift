//
//  SavedLocationView.swift
//  Map Duck
//
//  Created by Idan Birman on 27/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct SavedLocationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    @ObservedObject var location : SavedLocation 
    
    
    @State var isEditSheetPresented = false
    @State var isShareSheetPresented = false
    
    var isParking : Bool {
        guard let tags = location.tagsArray else { return false }
        return tags.contains(Tag.named("parking"))
    }
    
    @State var shareText : String = ""
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left.circle.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
                    .font(.system(size: 42))
                }
        }
    }
    
    
    var body: some View {
        Group {
        if !self.location.isDeleted {
            VStack(spacing: 8) {
                ZStack(alignment: .top) {
                    MapView(lat: location.latitude, long: location.longitude)
                        .frame(height: 300)
//                    if colorScheme == .dark {
//                        LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .top, endPoint: .bottom)
//                           .frame(height: 250)
//                           .background(Color.clear)
//                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            if location.title != nil{
                                Text(location.title ?? location.printedDate)
                                    .font(.largeTitle)
                                    .padding(isParking ? .horizontal : .leading)
                                    .foregroundColor(isParking ? .black : colorScheme == .dark ? Color.white : Color.black)
                                .background(isParking ? Color.golden : colorScheme == .dark ? Color.black : Color.white)
                                    .cornerRadius(10)
                                Text("Saved on \(location.printedDate)")
                                    .font(.subheadline)
                                    .padding(.leading)
                                Text("at \(location.printedTime)")
                                .font(.subheadline)
                                    .padding(.leading)
                            } else {
                                Text("Saved on \(location.printedDate)")
                                    .font(.largeTitle)
                                .padding(.leading)
                                Text("at \(location.printedTime)")
                                .font(.largeTitle)
                                .padding(.leading)
                            }
                        }
                        Spacer()
                        HStack(spacing: 0) {
                            Button(action: {
                                print("Share")
                                self.isShareSheetPresented.toggle()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 24))
                                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                                .padding()
                            }
                            Button(action: {
                                self.isEditSheetPresented.toggle()
                           }) {
                               Image(systemName: "square.and.pencil")
                                   .font(.system(size: 24))
                                   .foregroundColor(colorScheme == .dark ? .white : .blue)
                            .padding()
                            }
                        }
                    }
                    
                    if location.tagsArray?.count ?? -1 > 0 {
                        TagsList(location: location)
                            .padding(.leading)
                    }
                    if location.remarks != nil {
                        Text(location.remarks!)
                            .font(.body)
                        .padding()
                    }
                    if isShareSheetPresented {
                        ActivityViewController(text: $shareText, showing: $isShareSheetPresented)
                            .frame(width: 0, height: 0)
                    }
                }
                Spacer()
                HStack(alignment: .bottom) {
                   
                    Spacer()
                    Button(action: {
                        if let url = URL(string: self.location.links.apple) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 96))
                                .foregroundColor(colorScheme == .dark ? .white : .blue)
                            
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            if let url = URL(string: self.location.links.apple) {
                                UIApplication.shared.open(url)
                            }

                        }) {
                            Text("Apple Maps")
                            Image(systemName: "a.circle")
                        }
                        Button(action: {
                            if let url = URL(string: self.location.links.google) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Google Maps")
                            Image(systemName: "g.circle")
                        }
                        Button(action: {
                            if let url = URL(string: self.location.links.waze) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Waze")
                            Image(systemName: "w.circle")
                        }
                    }
                    
                }
            .padding()
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarItems(leading: btnBack)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isEditSheetPresented, onDismiss: {self.location.objectWillChange.send()}) {
                EditLocationView(location: self.location)
            }
            .onAppear {
                self.shareText = self.location.printedDescription
            }
        } else {
            Text("Deleted").onAppear {
                Dao.sharedInstance.saveContext()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
        }
}
}

struct SavedLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationView(location: SavedLocation.dummy())
    }
}
