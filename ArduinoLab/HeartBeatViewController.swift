//
//  HeartBeatViewController.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/26/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class HeartBeatViewController: UIViewController {
    
    @IBOutlet weak var graphView: SKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareScene()

    }
    
    func prepareScene() {
        if let scene = MyScene(fileNamed:"MyScene") {
            //setup your scene here
            scene.size = graphView.bounds.size
            scene.scaleMode = .aspectFill
            
            graphView.presentScene(scene)
        }
        
    }
    
}
