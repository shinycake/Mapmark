//
//  LocationListItem.swift
//  Map Duck
//
//  Created by Idan Birman on 31/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI

struct LocationListItem: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @ObservedObject var location : SavedLocation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(location.title ?? "Saved Location")
                        .font(.headline)
                    if !location.tagsArray!.contains(Tag.named("parking")) {
                         Text("\(location.latitude),\(location.longitude)")
                                               .font(.caption)
                    }
                   
                    HStack {
                        if location.tagsArray!.contains(Tag.named("parking")) {
                            Text(location.printedElapsedTime)
                                .font(.footnote)
                        } else {
                            Text(location.printedDate)
                                .font(.footnote)
                            Text("at " + location.printedTime)
                                .font(.footnote)
                        }
                    }
                }.padding()
                Spacer()
                if location.tagsArray!.contains(Tag.named("parking")) {
                   Image(systemName: "p.circle")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding()
                }
            }
            if location.tagsArray?.count ?? 0 > 0 {
                TagsList(location: location, tagsFont: .footnote)
                    .padding([.horizontal, .bottom])
            }
        }
        .background((location.tagsArray!.contains(Tag.named("parking"))) ? Color.yellow : colorScheme == .dark ? Color.white.opacity(0.10) : Color.black.opacity(0.05))
        .foregroundColor((location.tagsArray!.contains(Tag.named("parking"))) ? Color.black : colorScheme == .dark ? Color.white : Color.black)
        .cornerRadius(10)
    }
}

struct LocationListItem_Previews: PreviewProvider {
    static var previews: some View {
        LocationListItem(location: SavedLocation.dummy())
    }
}
