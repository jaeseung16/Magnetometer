//
//  MagneticField.swift
//  Magnetometer
//
//  Created by Jae Seung Lee on 6/19/18.
//  Copyright © 2018 Jae Seung Lee. All rights reserved.
//

import Foundation

struct MagneticField {
    var x: Double
    var y: Double
    var z: Double
    
    var magnitude: Double {
        return sqrt(x * x + y * y + z * z)
    }
}
