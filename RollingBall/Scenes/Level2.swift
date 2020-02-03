//
//  Level2.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Level2: SKScene {
    var cam: SKCameraNode?
    
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    let swipeUp = UISwipeGestureRecognizer()
    
    var slideGesture = false
    
    var gameManager: GameManager?
    
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
        
        enumerateChildNodes(withName: "cherry") {
            node, stop in
            
            if let cherry:Item = node as? Item {
                cherry.texture = SKTexture(imageNamed: "cherry")
                cherry.Setup()
            }
        }
        
        enumerateChildNodes(withName: "heart") {
            node, stop in
            
            if let heart:Item = node as? Item {
                heart.texture = SKTexture(imageNamed: "heart")
                heart.Setup()
            }
        }
        
        enumerateChildNodes(withName: "ice") {
            node, stop in
            
            if let ice:Item = node as? Item {
                ice.Setup()
            }
        }
        
        cam = childNode(withName: "camera") as? SKCameraNode
        self.camera = cam
        
        swipeRight.addTarget(self, action: #selector(Level1.swiped) )
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(Level1.swiped) )
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        
        swipeUp.addTarget(self, action: #selector(Level1.swiped) )
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
        
        gameManager?.updateLiveView()
        gameManager?.updateCherryView()
        
        if ScoreManager.Lives <= 0 {
            self.removeFromParent()
            
            gameManager?.loadStartScene()
        }
        
        if ball?.canJump ?? true && self.slideGesture {
            ball?.Jump()
            self.slideGesture = false
        }
        
        ball?.Update()
        
        let xLimitLeft = self.size.width * 0.5
        let xLimitRight = 10000.0 - self.size.width * 0.5
        
        var cameraX1 = (ball?.position)!.x <= xLimitLeft ? xLimitLeft : (ball?.position)!.x
        
        var cameraX2 = (ball?.position)!.x >= xLimitRight ? xLimitRight : cameraX1
            
        cam?.position = CGPoint(x: cameraX2,
                                y: self.size.height / 2)
    }
}

