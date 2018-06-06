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
        
        setUpVectorTransformLayer()
        vectorView.layer.addSublayer(vectorTransformLayer)
        
        controlButton.setTitle("START", for: .normal)
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
        case "STOP":
            newString = "START"
        default:
            newString = ""
        }
        
        controlButton.setTitle(newString, for: .normal)
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
}
