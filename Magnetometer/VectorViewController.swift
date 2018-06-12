//
//  VectorViewController.swift
//  Magnetometer
//
//  Created by Jae Seung Lee on 6/4/18.
//  Copyright © 2018 Jae Seung Lee. All rights reserved.
//

import UIKit
import CoreMotion

class VectorViewController: UIViewController {

    // MARK: Properties
    // IBOutlets
    @IBOutlet weak var vectorView: UIView!
    @IBOutlet weak var controlButton: UIButton!
    
    // Constants
    let vectorTransformLayer = CATransformLayer()
    let sideLength = CGFloat(160.0)
    
    // Variables
    var motionManager: CMMotionManager!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let tabBarController = self.tabBarController as? MagnetometerTabBarController else {
            print("This message should not be seen. Or something is very wrong.")
            return
        }
        
        motionManager = tabBarController.motionManager

        controlButton.setTitle("START", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpVectorTransformLayer()
        vectorView.layer.addSublayer(vectorTransformLayer)
    }
    
    @IBAction func startStop(_ sender: UIButton) {
        guard sender == controlButton, let buttonTitle = controlButton.currentTitle else {
            print("Cannot determine what to do.")
            return
        }
        
        var newString: String
        
        switch buttonTitle {
        case "START":
            newString = "STOP"
            measuringMagneticField()
        case "STOP":
            newString = "START"
            stopMeasuringMagneticField()
        default:
            newString = ""
        }
        
        controlButton.setTitle(newString, for: .normal)
    }
    
    func stopMeasuringMagneticField() {
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        print("stopped")
    }
    
    func measuringMagneticField() {
        motionManager.magnetometerUpdateInterval = 0.1

        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main) { (data, error) in
            if let magneticField = data?.magneticField {
                let xComponent = magneticField.field.x
                let yComponent = magneticField.field.y
                let zComponent = magneticField.field.z
                // let accuracy = magneticField.accuracy.rawValue
                
                // let magnitude = sqrt(xComponent * xComponent + yComponent * yComponent + zComponent * zComponent)
                
                self.vectorTransformLayer.sublayerTransform = self.rotateTo(x: CGFloat(xComponent), y: CGFloat(yComponent), z: CGFloat(zComponent))
            }
        }
        
        print("\(motionManager.isDeviceMotionActive)")
    }
    
    func setUpVectorTransformLayer() {
        vectorTransformLayer.frame = CGRect(x: 0.0, y: 0.0, width: vectorView.bounds.maxX, height: vectorView.bounds.maxY)
        //arrowTransformLayer.position = CGPoint(x: arrowView.bounds.midX, y: arrowView.bounds.midY)
        
        let layer1 = vectorLayer(backgroundColor: UIColor.black.cgColor, zPosition: 5.0)
        vectorTransformLayer.addSublayer(layer1)
        
        let layer2 = vectorLayer(backgroundColor: UIColor.white.cgColor, zPosition: sideLength/5.0)
        vectorTransformLayer.addSublayer(layer2)
        
        let layer3 = vectorLayer(backgroundColor: UIColor.red.cgColor, zPosition: sideLength/(-5.0))
        vectorTransformLayer.addSublayer(layer3)
        
        vectorTransformLayer.anchorPointZ = 0.0
        //rotate(xOffset: 0.0, yOffset: 0.0)
    }
    
    func vectorLayer(backgroundColor: CGColor, zPosition: CGFloat) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sideLength/2.0, height: sideLength/2.0))
        layer.position = CGPoint(x: vectorView.bounds.midX, y: vectorView.bounds.midY)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        print(layer.frame)
        print(layer.position)
        layer.backgroundColor = backgroundColor
        layer.shadowColor = UIColor.blue.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.zPosition = zPosition
        return layer
    }
    
    func rotateTo(x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        let θ = acos( z / sqrt(x*x + y*y + z*z) )
        
        guard x*x + y*y > 0 else {
            return CATransform3DIdentity
        }
        
        let rotX = y / sqrt(x*x + y*y)
        let rotY = -x / sqrt(x*x + y*y)
        
        return CATransform3DRotate(CATransform3DIdentity, θ, rotX, rotY, 0.0)
    }
}
