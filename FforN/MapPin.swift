//
//  MapPin.swift
//  FforN
//
//  Created by Dama Narendra on 11/28/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//


import Foundation
import MapKit

class EditableMapPin: MapPin {
   
}

class MapPin:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    let photoTitle: String
    let myCoordinate: CLLocationCoordinate2D
    
    init (coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: String ) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.photoTitle = title
        myCoordinate = coordinate
        
        super.init()
        
    }
}