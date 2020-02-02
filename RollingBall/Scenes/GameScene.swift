//
//  GameScene.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

let motionManager = CMMotionManager()
var ball: Player?

class GameScene: SKScene {
    var cam: SKCameraNode?
    
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    let swipeUp = UISwipeGestureRecognizer()
    
    var slideGesture = false
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor.white
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        
        if let aPlayer:Player = self.childNode(withName: "Player") as? Player {
            ball = aPlayer
            ball!.Setup()
        }
        
        
        enumerateChildNodes(withName: "platform") {
            node, stop in
            
            if let platform:Platform = node as? Platform {
                platform.Setup()
            }
        }
        
        cam = childNode(withName: "camera") as? SKCameraNode
        self.camera = cam
        
        swipeRight.addTarget(self, action: #selector(GameScene.swiped) )
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(GameScene.swiped) )
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        
        swipeUp.addTarget(self, action: #selector(GameScene.swiped) )
        swipeUp.direction = .up
        self.view!.addGestureRecognizer(swipeUp)
    }
    
    @objc func swiped() {
        self.slideGesture = true
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if ball?.canJump ?? true && self.slideGesture {
            
            ball?.Jump()
            self.slideGesture = false
        }
        
        ball?.Update()
        
        cam?.position = CGPoint(x: (ball?.position)!.x,
                                y: 0)
    }
}
