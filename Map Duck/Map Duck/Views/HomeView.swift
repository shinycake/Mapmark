//
//  HomeView.swift
//  Map Duck
//
//  Created by Idan Birman on 25/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var locator : Locator
    
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    @State var isShowingSettings = false

    @State var animationAmount : CGFloat = 1
    @State var timer : Timer?
    
    @State var parkingAnimationAmount : CGFloat = 1
    @State var parkingTimer : Timer?
    
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(action: {
                    guard let currentLocation = self.locator.lastLocation else {return}
                    _ = SavedLocation(location: currentLocation)
                    Dao.sharedInstance.saveContext()
                    self.animationAmount = 2
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { timer in
                        self.animationAmount = 1
                        self.timer?.invalidate()
                    })
                    print("saved")
                }) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 256))
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
                        Text("save my location")
                            .padding()
                            .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                .padding()
                }
                Spacer()
                HStack(alignment: .bottom) {
                    Button(action: {
                        print("settings")
                        self.isShowingSettings.toggle()
                    }) {
                        VStack {
                            Image(systemName: "gear")
                                .font(.system(size: 56))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(15)
                            Text("Settings")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding([.horizontal])
                                .font(.caption)
                        }
                    .padding()
                    }.sheet(isPresented: $isShowingSettings) {
                        VStack {
                            Text("Settings").font(.largeTitle).padding()
                            Spacer()
                            Text("Globe in App Icon made by Freepik from www.flaticon.com")
                            Spacer()
                            
                        }
                    }
                    NavigationLink(destination: LocationsList()) {
                        VStack {
                                Image(systemName: "map")
                                    .font(.system(size: 56))
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .padding()
                                    .background(colorScheme == .dark ? Color.white : Color.black)
                                    .cornerRadius(15)
                                Text("Locations")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .padding([.horizontal])
                                    .font(.caption)
                            }
                        .padding()
                    }.isDetailLink(false)
                    Button(action: {
                        guard let currentLocation = self.locator.lastLocation else {return}
                        _ = SavedLocation(location: currentLocation).parking()
                        Dao.sharedInstance.saveContext()
                        
                        self.parkingAnimationAmount = 2
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { timer in
                            self.parkingAnimationAmount = 1
                            self.parkingTimer?.invalidate()
                        })
                    }) {
                        VStack {
                            Image(systemName: "p.circle")
                                .font(.system(size: 56))
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(15)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.golden, lineWidth: 2)
                                        .scaleEffect(parkingAnimationAmount)
                                        .opacity(Double(2 - parkingAnimationAmount))
                                        .animation(
                                            Animation.easeInOut(duration: 1)
                                        )
                                )
                            Text("Parking")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding([.horizontal])
                                .font(.caption)
                        }
                    .padding()
                    }
                    
                }
            }
            .navigationBarTitle("Mapmark")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension Color {
    static var pink : Color {
        Color(red: 1.0, green: 117.0 / 255.0, blue: 175.0 / 255.0)
    }
    
    static var golden : Color {
        Color(red: 1.0, green: 207.0 / 255.0, blue: 26.0 / 255.0)
    }
    
    static var darkgray : Color {
        Color(red: 102.0 / 255.0, green: 112.0 / 255.0, blue: 141.0 / 255.0)
    }
    
    static var turquoise : Color {
        Color(red: 63.0 / 255.0, green: 242.0 / 255.0, blue: 191.0 / 255.0)
    }
}


