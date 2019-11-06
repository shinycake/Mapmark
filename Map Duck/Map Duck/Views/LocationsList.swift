//
//  LocationsList.swift
//  Map Duck
//
//  Created by Idan Birman on 25/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct LocationsList: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @EnvironmentObject var locator : Locator
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State private var animationAmount : CGFloat = 1
    @State private var timer : Timer?
        
    @FetchRequest(
        entity: SavedLocation.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SavedLocation.timestamp, ascending: false)
        ]
    ) var locations: FetchedResults<SavedLocation>
    
    var locationsToShow : [SavedLocation] {
        var arr = [SavedLocation]()
        for location in locations {
            if location.satisfies(query: searchText) {
                arr.append(location)
            }
        }
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        print("locationsToShow")
        return (arr as NSArray).sortedArray(using: [sortDescriptor]) as! Array
    }
    
    var body: some View {
         ZStack(alignment: .bottomTrailing) {
            VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                            }, onCommit: {
                                print("onCommit")
                                
                            }).foregroundColor(.primary)
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)

                        if showCancelButton  {
                            Button("Cancel") {
                                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                    self.searchText = ""
                                    self.showCancelButton = false
                            }
                            .foregroundColor(Color(.systemBlue))
                        }
                    }
                    .padding(.horizontal)
                    //                .navigationBarHidden(showCancelButton) //.animation(.default) // animation does not work properly
                
                List {
                    ForEach(locationsToShow, id: \.self.id) { location in
                        NavigationLink(destination: SavedLocationView(location: location)) {
                            LocationListItem(location: location)
                        }
                    }.onDelete(perform: delete)
                }
                .resignKeyboardOnDragGesture()
                .navigationBarTitle("Locations")
                .navigationBarItems(trailing: HStack {
                    EditButton()
                })
            }
            Button(action: {
                 guard let currentLocation = self.locator.lastLocation else {return}
                               _ = SavedLocation(location: currentLocation)
                               Dao.sharedInstance.saveContext()
                self.animationAmount = 2
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { timer in
                    self.animationAmount = 1
                    self.timer?.invalidate()
                })
            }) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(colorScheme == .dark ? .turquoise : .darkgray)
                .padding()
                .overlay(
                        Circle()
                        .stroke(colorScheme == .dark ? Color.turquoise : Color.darkgray, lineWidth: 5)
                        .scaleEffect(animationAmount)
                        .opacity(Double(2 - animationAmount))
                        .animation(
                            Animation.easeInOut(duration: 1)
                        )
                )
            }
         }
    }
    
     func delete(at offsets: IndexSet) {
        for index in offsets {
            self.locations[index].delete()
        }
    }
}

struct LocationsList_Previews: PreviewProvider {
    static var previews: some View {
        LocationsList()
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
