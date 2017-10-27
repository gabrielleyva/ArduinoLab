//
//  LDRViewController.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/27/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class LDRViewController: UIViewController {
    @IBOutlet weak var myView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareScene()
        
    }
    
    func prepareScene() {
        if let scene = LDRScene(fileNamed:"LDRScene") {
            //setup your scene here
            scene.size = myView.bounds.size
            scene.scaleMode = .aspectFill
            
            myView.presentScene(scene)
        }
    }
}
