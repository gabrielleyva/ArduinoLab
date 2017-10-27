//
//  MyScene.swift
//  ArduinoLab
//
//  Created by Gabriel I Leyva Merino on 10/24/17.
//  Copyright © 2017 Leyva_Phadate. All rights reserved.
//

import Foundation
import SpriteKit

class MyScene: SKScene {
    
    var dot: SKShapeNode!
    var globalSignal: Double!
    
    var bulletInterval: Float = 0.0
    var lastUpdateTime: CFTimeInterval!
    var dt: TimeInterval!
    
 override func didMove(to view: SKView) {
    
    //self.physicsWorld.gravity = CGVectorMake(-4.8, 0.0)
    globalSignal = 0
    self.backgroundColor = .white
    
    print(self.frame.size.height)
    
    }
    
    func plotGraph() {
        
        //dot = SKSpriteNode(color: .newRed, size: CGSize(width: 10, height: 10))
        dot = SKShapeNode(circleOfRadius: 10)
        dot.fillColor = .newRed
        dot.strokeColor = .newRed
    
        dot.position = CGPoint(x: self.frame.size.width, y: CGFloat((-400) + (signal / 8)))
        
        let moveLeft = SKAction.moveTo(x: -self.frame.size.width, duration: 1.5)
        let sequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        dot.run(sequence)
        
        self.addChild(dot)
        
    }
    
    override func update(_ currentTime: TimeInterval){
        
        if ((lastUpdateTime) != nil) {
            dt = currentTime - lastUpdateTime
        } else{
            dt = 0;
        }
        
        lastUpdateTime = currentTime;
        bulletInterval += Float(dt)
        if (bulletInterval > 0.010) {
            bulletInterval = 0
            
            self.plotGraph()
        }
    }
}
