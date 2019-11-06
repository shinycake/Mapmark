//
//  ContentView.swift
//  Map Duck
//
//  Created by Idan Birman on 24/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

struct ContentView: View {
    @EnvironmentObject var locator : Locator
    
    var body: some View {
        Group {
            if locator.lastLocation != nil {
                HomeView()
            } else {
                VStack {
                    Text("Can't Get Location 😐")
                        .font(.largeTitle)
                        .padding()
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
                    }) {
                        Text("Settings")
                        .padding()
                    }
                }
            }
        }.onAppear {
            self.locator.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
