//
//  CircularButton.swift
//  Map Duck
//
//  Created by Idan Birman on 24/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI

struct CircularButton: View {
    @State var title: String?
    @State var diameter: CGFloat
    @State var foregroundColor: Color
    @State var background: Color
    @State var image: String?
    @State var font: Font
    
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
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

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(title: nil, diameter: 256, foregroundColor: Color.white, background: Color.blue, image: "location", font: .footnote) {
            print("clickity click")
        }
    }
}
