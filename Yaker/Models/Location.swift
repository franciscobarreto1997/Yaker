//
//  Location.swift
//  Yaker
//
//  Created by Francisco Barreto on 27/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var geofenceRegion: CLCircularRegion?
    var posts =  [Post]()
    var id: String?
    
    init(name: String, latitude: Double, longitude: Double, id: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.geofenceRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: 100, identifier: name)
        self.id = id
    }
    
    
    
}
