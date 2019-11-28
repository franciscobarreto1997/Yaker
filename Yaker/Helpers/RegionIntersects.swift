//
//  RegionIntersects.swift
//  Yaker
//
//  Created by Francisco Barreto on 28/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation
import CoreLocation

extension CLCircularRegion {
    func intersects(_ r2: CLCircularRegion) -> Bool {
        let r1 = self
        let meanEarthRad: Double = 6371009
        let metersPerDegree = 2 * Double.pi * meanEarthRad / 360

        let dLat = r2.center.latitude - r1.center.latitude
        let dLon = r2.center.longitude - r1.center.longitude

        let actCenterDist = hypot(dLat, dLon) * metersPerDegree
        let minCenterDist = r1.radius + r2.radius

        return actCenterDist < minCenterDist
    }
}
