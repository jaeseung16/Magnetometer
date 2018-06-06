//
//  MagnetometerTabBarController.swift
//  Magnetometer
//
//  Created by Jae Seung Lee on 6/6/18.
//  Copyright © 2018 Jae Seung Lee. All rights reserved.
//

import UIKit
import CoreMotion

class MagnetometerTabBarController: UITabBarController {
    // MARK: Properties
    let motionManager = CMMotionManager()
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard motionManager.isMagnetometerAvailable else {
            /*
             let alert = UIAlertController(title: "No Magnetometer", message: "The device does not have the ability to measure magnetic fields", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
             present(alert, animated: true, completion: nil)*/
            print("There is no magnetometer")
            return
        }
    }
}
