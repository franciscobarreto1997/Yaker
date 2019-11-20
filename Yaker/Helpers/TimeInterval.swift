//
//  TimeInterval.swift
//  Yaker
//
//  Created by Francisco Barreto on 18/11/2019.
//  Copyright © 2019 Francisco Barreto. All rights reserved.
//

import Foundation

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
}
