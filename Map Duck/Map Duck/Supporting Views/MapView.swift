//
//  MapView.swift
//  Map Duck
//
//  Created by Idan Birman on 27/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView : UIViewRepresentable {
    let lat : Double
    let long : Double
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
        annotation.coordinate = centerCoordinate
//        annotation.title = "Here"
        view.addAnnotation(annotation)
        
        view.setRegion(region, animated: true)
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView(lat: 34.011286, long: -116.166868)
    }
}
