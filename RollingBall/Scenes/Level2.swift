//
//  Level2.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Level2: SKScene {
    var cam: SKCameraNode?
    
     // Gesture Recognizers
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    let swipeUp = UISwipeGestureRecognizer()
    let tap = UITapGestureRecognizer()
    
    var slideGesture = false
    
    var gameManager: GameManager?
    var portal: Item?
    
    //Camera limits
    var xLimitLeft : CGFloat?
    var xLimitRight: CGFloat?
    
    override func didMove(to view: SKView) {
        
        //Add background sound
        let backgroundSound = SKAudioNode(fileNamed: "BoxCat_Games_-_25_-_Victory.mp3")
        backgroundSound.autoplayLooped = true
        backgroundSound.run(SKAction.changeVolume(to: Float(0.25), duration: 0))
        self.addChild(backgroundSound)
    
        //Setups physics
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
            ball!.setupBullets()
        }
        
        // Finds ALL spriteKits with name "opossum" on the scene and setups the objects
        enumerateChildNodes(withName: "opossum") {
            node, stop in
            
            if let enemy:Enemy = node as? Enemy {
                enemy.Setup(name: "opossum", repeatAnim: 3)
            }
        }
        
        // Finds ALL spriteKits with name "platform" on the scene and setups the objects
        enumerateChildNodes(withName: "eagle") {
            node, stop in
            
            if let enemy:Enemy = node as? Enemy {
                enemy.Setup(name: "eagle", repeatAnim: 8)
                enemy.animateEnemyRun()
            }
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
        
        // Finds ALL spriteKits with name "bullet" on the scene and setups the objects
        enumerateChildNodes(withName: "bullet") {
            node, stop in
            
            if let bullet:Item = node as? Item {
                bullet.texture = SKTexture(imageNamed: "BulletImage")
                bullet.Setup()
            }
        }
        
        // Finds ALL spriteKits with name "ice" on the scene and setups the objects

        enumerateChildNodes(withName: "ice") {
            node, stop in
            
            if let ice:Item = node as? Item {
                ice.Setup()
            }
        }
        
        // Finds an spriteKit with name "portal_to_end" on the scene and assignes to the self.portal object
        if let aPortal = self.childNode(withName: "portal_to_end") as? Item {
            self.portal = aPortal
            portal!.Setup()
        }
        
        // Finds an spriteKit Camera and setups it
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
        
        tap.addTarget(self, action: #selector(Level2.tapped) )
        self.view!.addGestureRecognizer(tap)
        
        //Setups rotation animation for portal
        let oneRotation:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRotation)
        self.portal?.run(repeatRotation)
    }
    
     //Swipe Gesture Recognizers Target function
    @objc func swiped() {
        self.slideGesture = true
    }
    
     //Tap Recognizers Target function
    @objc func tapped() {
        
        //Checking if player has enought playable bullets
        if(ScoreManager.Bullets > 0) {
            let bullet = ball!.bullets!.list[ball!.bullets!.key]
            
            //Get a bullet from an pre created array
            if(ball!.bullets!.key == ball!.bullets!.list.count - 1)
            {
                ball!.bullets!.key = 0
            } else {
                ball!.bullets!.key += 1
            }
            
            //Sets position, alpha and velocity for bullet
            bullet.position = ball!.position
            bullet.alpha = 1.0
            bullet.physicsBody?.velocity = CGVector(dx:1000 * ball!.direction, dy: 0)
            self.addChild(bullet)
            
            //Add bullet animation
            bullet.fadeAndRemove()
            ScoreManager.Bullets -= 1
        }
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
        
        //Call labels update function
        gameManager?.updateLiveView()
        gameManager?.updateCherryView()
        gameManager?.updateBulletsView()
        
        //Checking if player has enough lives
        if ScoreManager.Lives <= 0 {
            self.removeFromParent()
            
            gameManager?.loadStartScene()
            gameManager?.showEndGame()
        }
        
        //Checking if player touches the platform so it can jump
        if ball?.canJump ?? true && self.slideGesture {
            ball?.Jump()
            self.slideGesture = false
        }
        
         //Call the rest of player logic
        ball?.Update()
        
        //Updating enemies animations
        enumerateChildNodes(withName: "opossum") {
            node, stop in
            
            if let enemy:Enemy = node as? Enemy {
                enemy.Update()
            }
        }
        
        enumerateChildNodes(withName: "eagle") {
            node, stop in
            
            if let enemy:Enemy = node as? Enemy {
                enemy.Update()
            }
        }
    
        //Updating camera
        var cameraX1 = (ball?.position)!.x <= xLimitLeft! ? xLimitLeft! : (ball?.position)!.x
        
        var cameraX2 = (ball?.position)!.x >= xLimitRight! ? xLimitRight! : cameraX1
        
        cam?.position = CGPoint(x: cameraX2,
                                y: self.size.height / 2)
        
        //Checking if player colides with portal, so 2nd level can be loaded

        if ball!.gotToEnd {
             self.removeFromParent()
             gameManager?.loadStartScene()
             gameManager?.showEndGame()
        }
    }
}

