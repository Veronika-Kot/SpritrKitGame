//
//  Level1.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

let motionManager = CMMotionManager()
var ball: Player?

// Game scene of Level 1
class Level1: SKScene {
    var cam: SKCameraNode?
    
    // Gesture Recognizers
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    let swipeUp = UISwipeGestureRecognizer()
    
    //Camera limits
    var xLimitLeft : CGFloat?
    var xLimitRight: CGFloat?
    
    var slideGesture = false
    
    var gameManager: GameManager?
    
    var portal: Item?
    
    override func didMove(to view: SKView) {
        
        //Add background sound
        let backgroundSound = SKAudioNode(fileNamed: "BoxCat_Games_-_25_-_Victory.mp3")
        backgroundSound.autoplayLooped = true
        backgroundSound.run(SKAction.changeVolume(to: Float(0.25), duration: 0))
        self.addChild(backgroundSound)
       
        //backgroundColor = UIColor.white
        
        //Set physics world
        physicsWorld.contactDelegate = self
        
         //Setup motionManager
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        
        //Setup Camera limits
        xLimitLeft = self.size.width * 0.5
        xLimitRight = 10000.0 - self.size.width * 0.5
        
        
        // Finds an spriteKit with name Player on the scene and assignes to the player object
        if let aPlayer:Player = self.childNode(withName: "Player") as? Player {
            ball = aPlayer
            ball!.Setup()
        }
        
        // Finds an spriteKit with name "portal" on the scene and assignes to the self.portal object
        if let aPortal = self.childNode(withName: "portal") as? Item {
            self.portal = aPortal
            portal!.Setup()
        }
        
        // Finds ALL spriteKits with name "platform" on the scene and setups the objects
        enumerateChildNodes(withName: "platform") {
            node, stop in
            
            if let platform:Platform = node as? Platform {
                platform.Setup()
            }
        }
        
        // Finds ALL spriteKits with name "cherry" on the scene and setups the objects
        enumerateChildNodes(withName: "cherry") {
            node, stop in
            
            if let cherry:Item = node as? Item {
                cherry.texture = SKTexture(imageNamed: "cherry")
                cherry.Setup()
            }
        }
        
        // Finds ALL spriteKits with name "heart" on the scene and setups the objects
        enumerateChildNodes(withName: "heart") {
            node, stop in
            
            if let heart:Item = node as? Item {
                heart.texture = SKTexture(imageNamed: "heart")
                heart.Setup()
            }
        }
        
        // Finds ALL spriteKits with name "ice" on the scene and setups the objects
        enumerateChildNodes(withName: "ice") {
            node, stop in
            
            if let ice:Item = node as? Item {
                ice.Setup()
            }
        }
        
        // Finds spriteKit Cameraon the scene and setups it
        cam = childNode(withName: "camera") as? SKCameraNode
        self.camera = cam
        
        // Adding gesture recognizerers to the scene
        swipeRight.addTarget(self, action: #selector(Level1.swiped) )
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(Level1.swiped) )
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        
        
        swipeUp.addTarget(self, action: #selector(Level1.swiped) )
        swipeUp.direction = .up
        self.view!.addGestureRecognizer(swipeUp)
        
        
        // Setup rotation animation to portal object
        let oneRotation:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRotation)
        self.portal?.run(repeatRotation)
    }
    
    //Gesture Recognizers Target function
    @objc func swiped() {
        self.slideGesture = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //Update function
    override func update(_ currentTime: TimeInterval) {
        
        //Updates labels values
        gameManager?.updateLiveView()
        gameManager?.updateCherryView()
        
        //Checking if player has enough lives
        if ScoreManager.Lives <= 0 {
            self.removeFromParent()
            
            gameManager?.loadStartScene()
            gameManager?.showEndGame()
        }
        
        //Checking if player colides with portal, so 2nd level can be loaded
        if ball!.goForward {
            gameManager?.loadGameScene(level: 2)
            ball!.goForward = false
        }
        
        //Call Player Jump function
        if ball?.canJump ?? true && self.slideGesture {
            ball?.Jump()
            self.slideGesture = false
        }
        
        //Update the rest of Player logic
        ball?.Update()
        
        //Update camera
        var cameraX1 = (ball?.position)!.x <= xLimitLeft! ? xLimitLeft! : (ball?.position)!.x
        var cameraX2 = (ball?.position)!.x >= xLimitRight! ? xLimitRight! : cameraX1

        cam?.position = CGPoint(x: cameraX2,
                                y: self.size.height / 2)
    }
}
