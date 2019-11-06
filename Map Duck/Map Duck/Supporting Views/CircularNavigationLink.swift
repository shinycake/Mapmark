//
//  CircularNavigationLink.swift
//  Map Duck
//
//  Created by Idan Birman on 25/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI

struct CircularNavigationLink: View {
    @State var title: String?
    @State var diameter: CGFloat
    @State var foregroundColor: Color
    @State var background: Color
    @State var image: String?
    @State var font: Font
    
    var destination: LocationsList
    
    
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                if image != nil {
                   Image(image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                }
                if title != nil {
                    Text(title!)
                    .foregroundColor(foregroundColor)
                    .font(font)
                    .padding(.horizontal)
                } else {
                    Spacer()
                }
            }
            .frame(width: diameter, height: diameter)
            .background(background)
            .mask(Circle())
        .shadow(radius: 5)
        .padding()
        }
    }
}

struct CircularNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        CircularNavigationLink(title: nil, diameter: 64, foregroundColor: .black, background: .orange, image: "list", font: .body, destination: LocationsList())
    }
}
