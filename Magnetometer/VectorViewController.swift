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
    
    let vectorTransformLayer = CATransformLayer()
    let sideLength = CGFloat(160.0)
    
    let motionManager = CMMotionManager()
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpVectorTransformLayer()
        vectorView.layer.addSublayer(vectorTransformLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
