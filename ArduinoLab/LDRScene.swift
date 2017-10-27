//
//  LDRScene.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/27/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import Foundation
import SpriteKit

import SpriteKit

class LDRScene: SKScene {
    
    var bulb:SKEmitterNode!
        
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.prepareEmmiterNode()
        // BLE Recieve Data Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onBLEDidRecieveDataNotification),
                                               name: NSNotification.Name(rawValue: kBleReceivedDataNotification),
                                               object: nil)
    }
    
    func prepareEmmiterNode() {
        if let particle = SKEmitterNode(fileNamed: "Bulb.sks") {
            particle.position = CGPoint(x: 0, y:  0)
            bulb = particle
            addChild(bulb)
        }
    }

    @objc func onBLEDidRecieveDataNotification(notification:Notification){
        let d = notification.userInfo?["data"] as! Data?
        let s = String(bytes: d!, encoding: String.Encoding.ascii)
        
        if (s?.index(of: "B") != nil){
            let startIndex = s?.index((s?.startIndex)!, offsetBy: 6)
            let ldrData = s![startIndex!...]
            //self.ldrLabel.text = String(ldrData)
            if let value = Float(ldrData){
                //self.dataBuffer.add(point: value)
                self.bulb.particleBirthRate = CGFloat(value)
            }
        }
    }
}
