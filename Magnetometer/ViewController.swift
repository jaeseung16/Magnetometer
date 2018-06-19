//
//  ViewController.swift
//  Magnetometer
//
//  Created by Jae Seung Lee on 3/7/18.
//  Copyright © 2018 Jae Seung Lee. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var xComponentLabel: UILabel!
    @IBOutlet weak var yComponentLabel: UILabel!
    @IBOutlet weak var zComponentLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var updateIntervalTextField: UITextField! {
        didSet {
            updateIntervalTextField.addDoneCancelToolbar(onDone: nil, onCancel: nil)
        }
    }
    
    @IBOutlet weak var magnitudeProcessedLabel: UILabel!
    @IBOutlet weak var xComponentProcessedLabel: UILabel!
    @IBOutlet weak var yComponentProcessedLabel: UILabel!
    @IBOutlet weak var zComponentProcessedLabel: UILabel!

    @IBOutlet weak var magnitudeFromCLHeading: UILabel!
    @IBOutlet weak var xComponentFromCLHeading: UILabel!
    @IBOutlet weak var yComponentFromCLHeading: UILabel!
    @IBOutlet weak var zComponentFromCLHeading: UILabel!
    
    var motionManager: CMMotionManager!
    var locationManager: CLLocationManager?
    
    var rawMagneticField = MagneticField(x: 0.0, y: 0.0, z: 0.0)
    var calibratedMagneticField = MagneticField(x: 0.0, y: 0.0, z: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let tabBarController = self.tabBarController as? MagnetometerTabBarController else {
            print("This message should not be seen. Or something is very wrong.")
            return
        }
        
        motionManager = tabBarController.motionManager
        
        updateIntervalTextField.text = "1.0"
        
        motionManager.magnetometerUpdateInterval = 0.1
        motionManager.startMagnetometerUpdates(to: OperationQueue.main) { (data, error) in
            if let magneticfield = data?.magneticField {
                self.rawMagneticField.x = magneticfield.x
                self.rawMagneticField.y = magneticfield.y
                self.rawMagneticField.z = magneticfield.z

                let differenceMangeticField = MagneticField(x: magneticfield.x - self.calibratedMagneticField.x, y: magneticfield.y - self.calibratedMagneticField.y, z: magneticfield.z - self.calibratedMagneticField.z)
                
                self.xComponentLabel.text = String(format: "%.1f", differenceMangeticField.x)
                self.yComponentLabel.text = String(format: "%.1f", differenceMangeticField.y)
                self.zComponentLabel.text = String(format: "%.1f", differenceMangeticField.z)
                
                
                let magnitude = differenceMangeticField.magnitude
                
                self.magnitudeLabel.text = String(format: "%.1f", magnitude)
            }
        }
        
        sleep(1)
        
        motionManager.stopMagnetometerUpdates()
        
        print("\(motionManager.isDeviceMotionAvailable)")
        print("\(motionManager.attitudeReferenceFrame)")
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.showsDeviceMovementDisplay = true
        
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.main) { (data, error) in
            if let magneticField = data?.magneticField {
                self.calibratedMagneticField.x = magneticField.field.x
                self.calibratedMagneticField.y = magneticField.field.y
                self.calibratedMagneticField.z = magneticField.field.z
                let accuracy = magneticField.accuracy
                
                self.xComponentProcessedLabel.text = String(format: "%.5f", magneticField.field.x)
                self.yComponentProcessedLabel.text = String(format: "%.5f", magneticField.field.y)
                self.zComponentProcessedLabel.text = String(format: "%.5f", magneticField.field.z)
                self.accuracyLabel.text = "\(accuracy.rawValue)"
                
                let magnitude = self.calibratedMagneticField.magnitude
                
                self.magnitudeProcessedLabel.text = String(format: "%.5f", magnitude)
            }
        }
        
        sleep(1)
        
        motionManager.stopDeviceMotionUpdates()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            print("\(String(describing: locationManager))")
        } else {
            print("Location services are not availabe")
        }
        
        if CLLocationManager.headingAvailable() {
            locationManager?.startUpdatingHeading()
            
            if let heading = locationManager?.heading {
                print("Initial heading relative to the magnetic north: \(heading.magneticHeading)")
            }
        } else {
            print("Heading is not available")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takingShot(_ sender: UIButton) {
        motionManager.magnetometerUpdateInterval = 1
        //motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates()
        
        let timer = Timer(fire: Date(), interval: motionManager.magnetometerUpdateInterval, repeats: false) { (timer) in
            if let data = self.motionManager.deviceMotion {
                let xComponent = data.magneticField.field.x
                let yComponent = data.magneticField.field.y
                let zComponent = data.magneticField.field.z
                let accuracy = data.magneticField.accuracy
                
                self.xComponentLabel.text = String(format: "%.3f", xComponent)
                self.yComponentLabel.text = String(format: "%.3f", yComponent)
                self.zComponentLabel.text = String(format: "%.3f", zComponent)
                self.accuracyLabel.text = "\(accuracy.rawValue)"
                
                let magnitude = sqrt(xComponent * xComponent + yComponent * yComponent + zComponent * zComponent)
                
                self.magnitudeLabel.text = String(format: "%.3f", magnitude)
            }
        }
        
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    @IBAction func startMeasurement(_ sender: UIButton) {
        guard let text = updateIntervalTextField.text, let interval = Double(text) else {
            print("The update interval should be a number")
            return
        }

        motionManager.magnetometerUpdateInterval = interval
        
        motionManager.startMagnetometerUpdates(to: OperationQueue.main) { (data, error) in
            if let magneticField = data?.magneticField {
                self.xComponentLabel.text = String(format: "%.3f", magneticField.x)
                self.yComponentLabel.text = String(format: "%.3f", magneticField.y)
                self.zComponentLabel.text = String(format: "%.3f", magneticField.z)
                
                let magnitude = sqrt(magneticField.x * magneticField.x + magneticField.y * magneticField.y + magneticField.z * magneticField.z)
                
                self.magnitudeLabel.text = String(format: "%.3f", magnitude)
            }
        }

        motionManager.deviceMotionUpdateInterval = interval
        
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { (data, error) in
            if let magneticField = data?.magneticField {
                let xComponent = magneticField.field.x
                let yComponent = magneticField.field.y
                let zComponent = magneticField.field.z
                
                self.xComponentProcessedLabel.text = String(format: "%.3f", xComponent)
                self.yComponentProcessedLabel.text = String(format: "%.3f", yComponent)
                self.zComponentProcessedLabel.text = String(format: "%.3f", zComponent)
                self.accuracyLabel.text = "\(magneticField.accuracy.rawValue)"
                
                let magnitude = sqrt(xComponent * xComponent + yComponent * yComponent + zComponent * zComponent)
                
                self.magnitudeProcessedLabel.text = String(format: "%.3", magnitude)
            }
        }
        
        print("\(motionManager.isDeviceMotionActive)")
    }
    
    @IBAction func stopMeasurement(_ sender: UIButton) {
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        print("stopped")
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("\(newHeading.timestamp)")
        
        xComponentFromCLHeading.text = String(format: "%.3f", newHeading.x)
        yComponentFromCLHeading.text = String(format: "%.3f", newHeading.y)
        zComponentFromCLHeading.text = String(format: "%.3f", newHeading.z)
        
        let magnitude = sqrt(newHeading.x * newHeading.x + newHeading.y * newHeading.y + newHeading.z * newHeading.z)
        magnitudeFromCLHeading.text = String(format: "%.3f", magnitude)
    }
}
