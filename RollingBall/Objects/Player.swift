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
    var goTo2ndLevel = false
    private var playerRunFrames: [SKTexture] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func Setup() {
        let runAnimatedAtlas = SKTextureAtlas(named: "run")
        var walkFrames: [SKTexture] = []
        
        let numImages = runAnimatedAtlas.textureNames.count
        for i in 1...numImages {
          let runTextureName = "player-run-\(i)"
          walkFrames.append(runAnimatedAtlas.textureNamed(runTextureName))
        }
        playerRunFrames = walkFrames
        
        self.setScale(1.7)
        self.texture = playerRunFrames[0]
        
        self.physicsBody =
            SKPhysicsBody(texture: playerRunFrames[0], size: CGSize(width: self.texture!.size().width * 2, height: self.texture!.size().height * 2.5))
//            SKPhysicsBody(circleOfRadius: self.size.height * 0.5)
        if let physics = self.physicsBody {
            
            physics.isDynamic = true
            physics.allowsRotation = false
            physics.angularVelocity = 0
            physics.affectedByGravity = true
            physics.linearDamping = 0.5
            physics.angularDamping = 0.2
            physics.friction = 0.1
            physics.mass = 1.0
            
            physics.usesPreciseCollisionDetection = true
            
            physics.categoryBitMask = PhysicsCategory.player
            physics.contactTestBitMask = PhysicsCategory.cherry
            physics.contactTestBitMask = PhysicsCategory.platform
            physics.collisionBitMask = PhysicsCategory.platform
            
            
        }
    }
    
    override func Reset() {
        
    }
    
    func animateRun() {
      self.run(SKAction.repeatForever(
        SKAction.animate(with: playerRunFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true)),
        withKey:"animateRun")
    }
    
    func GetItem(item: SKSpriteNode) {
        
        if (item.name == "cherry") {
            ScoreManager.Score += 1
            item.removeFromParent()
        }
        
        if (item.name == "heart") {
            ScoreManager.Lives += 1
            item.removeFromParent()
        }
        
        if (item.name == "ice" && !hitIce) {
            hitIce = true
            ScoreManager.Lives -= 1
        }
        
        if (item.name == "portal") {
            self.goTo2ndLevel = true
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
                
                self.xScale = abs(self.xScale) * 1
                
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? 500 : 500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
            } else if (accelerometerData.acceleration.y > 0.2 && self.position.x >= xLimitLeft) {
                
                self.xScale = abs(self.xScale) * -1
                
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
