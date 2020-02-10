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
    enum anim {
        case run
        case idle
        case runJump
    }
    
    var canJump = false
    var hitObsticle = false
    var goTo2ndLevel = false
    var jumping = false
    private var playerRunFrames: [SKTexture] = []
    private var playerIdleFrames: [SKTexture] = []
    private var playerJumpFrames: [SKTexture] = []
    
    var animation: anim = .run
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func Setup() {
        
        //Setup running animation
        let runAnimatedAtlas = SKTextureAtlas(named: "run")
        var walkFrames: [SKTexture] = []

        let numImages = runAnimatedAtlas.textureNames.count
        for i in 1...numImages {
          let runTextureName = "player-run-\(i)"
          walkFrames.append(runAnimatedAtlas.textureNamed(runTextureName))
        }
        playerRunFrames = walkFrames
        
        //setup idle animation
        let idleAnimatedAtlas = SKTextureAtlas(named: "idle")
        let numImages2 = idleAnimatedAtlas.textureNames.count
        var idleFrames: [SKTexture] = []
        
        for i in 1...numImages2 {
          let idleTextureName = "player-idle-\(i)"
          idleFrames.append(idleAnimatedAtlas.textureNamed(idleTextureName))
        }
        playerIdleFrames = idleFrames
        
        
        //setup jump animation
        let jumpAnimatedAtlas = SKTextureAtlas(named: "jump")
        let numImages3 = jumpAnimatedAtlas.textureNames.count
        var jumpFrames: [SKTexture] = []
        
        for i in 1...numImages3 {
          let jumpTextureName = "player-jump-\(i)"
          jumpFrames.append(jumpAnimatedAtlas.textureNamed(jumpTextureName))
        }
        playerJumpFrames = jumpFrames
        
        
        self.setScale(1.7)
        self.texture = playerRunFrames[0]
        
        self.physicsBody =
            SKPhysicsBody(texture: playerRunFrames[0], size: CGSize(width: self.texture!.size().width * 2, height: self.texture!.size().height * 2.5))
        if let physics = self.physicsBody {
            
            physics.isDynamic = true
            physics.allowsRotation = false
            physics.angularVelocity = 0
            physics.affectedByGravity = true
            physics.linearDamping = 0.5
            physics.angularDamping = 0.5
            physics.friction = 0
            physics.mass = 1.0
            
//            physics.usesPreciseCollisionDetection = true
            
            physics.categoryBitMask = PhysicsCategory.player
            physics.contactTestBitMask = PhysicsCategory.item
            physics.contactTestBitMask = PhysicsCategory.platform
            physics.collisionBitMask = PhysicsCategory.platform
            
            
        }
    }
    override func Reset() {
        self.position = CGPoint(x: 300, y: 720)
        hitObsticle = false
    }
    
    func animateRun() {
        if animation == .run {
            self.removeAction(forKey: "animateIdle")
//            self.removeAction(forKey: "animateJump")
            
            if self.action(forKey: "animateRun") == nil {
                self.run(SKAction.repeatForever(
                SKAction.animate(with: playerRunFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                withKey:"animateRun")
            }
        
        }
        else if animation == .idle {
             self.removeAction(forKey: "animateRun")
//             self.removeAction(forKey: "animateJump")
            
             if self.action(forKey: "animateIdle") == nil {
                self.run(SKAction.repeatForever(
                SKAction.animate(with: playerIdleFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                withKey:"animateIdle")
            }
        }
        else if animation == .runJump {
             self.removeAction(forKey: "animateRun")
             self.removeAction(forKey: "animateIdle")

            
//             if self.action(forKey: "animateJump") == nil {
            if !jumping {
                jumping = true
                self.run(SKAction.animate(with: playerJumpFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true),
                 completion: {() -> Void in
                    self.animation = .run
                    self.jumping = false
                })
            }
        }
    }
    
    func GetItem(item: SKSpriteNode, scene: SKScene) {
        
        if (item.name == "cherry") {
            ScoreManager.Score += 1
            item.removeFromParent()
            scene.run(SKAction.playSoundFileNamed("gotitem", waitForCompletion: false))
        }
        
        if (item.name == "heart") {
            ScoreManager.Lives += 1
            item.removeFromParent()
            scene.run(SKAction.playSoundFileNamed("magicalThing", waitForCompletion: false))
        }
        
        if (item.name == "ice" && !hitObsticle) {
            hitObsticle = true
            ScoreManager.Lives -= 1
        }
        
        if ((item.name == "opossum" || item.name == "eagle") && !hitObsticle) {
            hitObsticle = true
            ScoreManager.Lives -= 1
        }
        
        if (item.name == "portal") {
            self.goTo2ndLevel = true
        }
    }
    
    func Jump() {
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx * 1.5, dy: 700)
        self.animation = .runJump
        self.canJump = false
    }
    
    override func Update() {
        self.animateRun()
    
        if hitObsticle {
            Reset()
        }
        
        let xLimitLeft = self.size.width * 0.5 + self.size.width * 0.5
        let xLimitRight = 10000.0 - self.size.width * 0.5 - self.size.width * 0.5
        
        if let accelerometerData = motionManager.accelerometerData {
            
            if (accelerometerData.acceleration.y < -0.2 && self.position.x <= xLimitRight) {
                
                self.xScale = abs(self.xScale) * 1
                self.animation = self.animation == .runJump ? .runJump : .run
                
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? 500 : 500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
            } else if (accelerometerData.acceleration.y > 0.2 && self.position.x >= xLimitLeft) {
                
                self.xScale = abs(self.xScale) * -1
                self.animation = self.animation == .runJump ? .runJump : .run
                
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? -500 : -500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
            } else {
                for _ in 1...5 {
                    self.physicsBody!.velocity.dx *= 0.5
                    self.physicsBody?.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: self.physicsBody!.velocity.dy)
                }
                self.physicsBody?.velocity = CGVector(dx: 0, dy: self.physicsBody!.velocity.dy)
                
                self.animation = .idle
            }
        }
    }
}
