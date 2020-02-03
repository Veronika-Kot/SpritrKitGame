//
//  Player.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

class Player : GameObject
{
    var canJump = false
    var hitIce = false
    var numCherries = 0
    var numLives = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func Setup() {
        self.texture = SKTexture(imageNamed: "ball")
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2)
        //SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: self.size)
        
        if let physics = self.physicsBody {
            
            physics.isDynamic = true
            physics.allowsRotation = true
            physics.affectedByGravity = true
            physics.linearDamping = 0.85
            physics.angularDamping = 0.85
            physics.friction = 0.5
            physics.categoryBitMask = PhysicsCategory.player
            physics.contactTestBitMask = PhysicsCategory.cherry
            physics.contactTestBitMask = PhysicsCategory.platform
            physics.collisionBitMask = PhysicsCategory.platform
        }
    }
    
    override func Reset() {
        
    }
    
    func GetItem(item: SKSpriteNode) {
        
        if (item.name == "cherry") {
            self.numCherries += 1
            item.removeFromParent()
        }
        
        if (item.name == "heart") {
            self.numLives += 1
            item.removeFromParent()
        }
        
        if (item.name == "ice" && !hitIce) {
            hitIce = true
            self.numLives -= 1
            
            if self.numLives < 1 {
                print("Game over")
            }
        }
    }
    
    func Jump() {
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx * 1.5, dy: 700)
        self.canJump = false
    }
    
    override func Update() {
        
        if hitIce {
            self.position = CGPoint(x: 300, y: 720)
            hitIce = false
        }
        
        let xLimitLeft = self.size.width * 0.5 + self.size.width * 0.5
        let xLimitRight = 10000.0 - self.size.width * 0.5 - self.size.width * 0.5
        
        if let accelerometerData = motionManager.accelerometerData {
            if (accelerometerData.acceleration.y < -0.2 && self.position.x <= xLimitRight) {
                
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? 500 : 500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
            } else if (accelerometerData.acceleration.y > 0.2 && self.position.x >= xLimitLeft) {
                
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? -500 : -500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
            } else {
                for _ in 1...5 {
                    self.physicsBody!.velocity.dx *= 0.5
                    self.physicsBody?.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: self.physicsBody!.velocity.dy)
                }
                self.physicsBody?.velocity = CGVector(dx: 0, dy: self.physicsBody!.velocity.dy)
            }
        }
    }
}
