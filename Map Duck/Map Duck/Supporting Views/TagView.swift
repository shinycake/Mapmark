//
//  TagView.swift
//  Map Duck
//
//  Created by Idan Birman on 26/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @State var name : String
    @State var backgroundColor : UIColor = Color.randomUiColor
    @State var font : Font = .headline
    
    var body: some View {
            Text("  #\(name.lowercased())  ")
                .font(font)
                .background(Color(backgroundColor))
                .foregroundColor(Color.textContrast(for: backgroundColor))
                .cornerRadius(10)
        .lineLimit(1)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(name: "Food")
    }
}

extension Color {
    static var random : Color {
        return Color(randomUiColor)
    }
    
    static var randomUiColor : UIColor {
        return UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1.0)
    }
    
    static func textContrast(for color: UIColor) -> Color {
        guard let components = color.cgColor.components else {return .white}
        let red = components[0] * 255
        let green = components[1] * 255
        let blue = components[2] * 255
        
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
        
        return luminance > 0.5 ? .black : .white
        
    }
}
