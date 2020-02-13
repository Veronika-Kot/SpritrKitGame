//
//  Player.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Class for Player object
class Player : GameObject
{
    //Animation state enum
    enum anim {
        case run
        case idle
        case runJump
        case die
    }
    
    var canJump = false
    var dying = false
    var hitObsticle = false
    var goForward = false
    var gotToEnd = false
    var jumping = false
    var direction:CGFloat = 1.0
    
    //Animation Textures
    private var playerRunFrames: [SKTexture] = []
    private var playerIdleFrames: [SKTexture] = []
    private var playerJumpFrames: [SKTexture] = []
    private var playerDieFrames: [SKTexture] = []
    
    //Array of bullets
    var bullets: (key: Int, list: [Bulet])?

    var animation: anim = .run
    
    var xLimitLeft: CGFloat?
    var xLimitRight: CGFloat?
    var yLimit: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Setup function, init is called on sks file
    override func Setup() {
        
        //Setups screen limits
        xLimitLeft = self.size.width * 0.5 + self.size.width * 0.5
        xLimitRight = 10000.0 - self.size.width * 0.5 - self.size.width * 0.5
        yLimit = 750.0 - self.size.height * 0.5
        
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
        
        //Setup die animation
        let dieAnimatedAtlas = SKTextureAtlas(named: "hurt")
        var dieFrames: [SKTexture] = []
        
        let numImages1 = dieAnimatedAtlas.textureNames.count
        for i in 1...numImages1 {
            let runTextureName = "player-hurt-\(i)"
            dieFrames.append(dieAnimatedAtlas.textureNamed(runTextureName))
        }
        playerDieFrames = dieFrames
        
        //Setup initioal configuration
        self.setScale(1.7)
        self.texture = playerRunFrames[0]
        
        //Setups Physics body
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
                        
            physics.categoryBitMask = PhysicsCategory.player
            physics.contactTestBitMask = PhysicsCategory.item
            physics.contactTestBitMask = PhysicsCategory.enemy
            physics.contactTestBitMask = PhysicsCategory.platform
            physics.collisionBitMask = PhysicsCategory.platform
            
            
            self.goForward = false
        }
    }
    
    //Creating an array of Bullet objects
    func setupBullets() {
        var tempArrayBullet = [Bulet]()
        for _ in 1...50 {
            let bullet = Bulet()
            tempArrayBullet.append(bullet)
        }
        
        
        self.bullets = (key: 0, list: tempArrayBullet);
    }
    
    
    //Resets Player when it dies
    override func Reset() {
        self.position = CGPoint(x: 300, y: 720)
        self.hitObsticle = false
        self.dying = false
        self.animation = .idle
    }
    
    //Animation function, checking the animation state and call correct anim frames
    func animateRun() {
        
        if animation == .run {
            self.removeAction(forKey: "animateIdle")
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
        } else if animation == .die {
        
            self.removeAction(forKey: "animateRun")
            self.removeAction(forKey: "animateIdle")
            
            if !dying {
            dying = true
                self.run(SKAction.animate(with: playerDieFrames,
                                          timePerFrame: 0.1,
                                          resize: false,
                                          restore: true),
                         completion: {() -> Void in
                            self.Reset()
                })
            }
            
        }
    }
    
    //Function called when player collides with pick up objects
    //Checking item "name" and specific code
    func GetItem(item: SKSpriteNode, scene: SKScene) {
        
        if (item.name == "cherry") {
            ScoreManager.Score += 1
            item.removeFromParent()
            
            //Running sound
            scene.run(SKAction.playSoundFileNamed("gotitem", waitForCompletion: false))
        }
        
        if (item.name == "heart") {
            ScoreManager.Lives += 1
            item.removeFromParent()
            
             //Running sound
            scene.run(SKAction.playSoundFileNamed("gotitem", waitForCompletion: false))
        }
        
        if (item.name == "ice" && !hitObsticle) {
            
             //Running die sound
            scene.run(SKAction.playSoundFileNamed("player-death", waitForCompletion: false))
                       
            hitObsticle = true
            ScoreManager.Lives -= 1
        }
        
        if ((item.name == "opossum" || item.name == "eagle") && !hitObsticle) {
            
             //Running die sound
            scene.run(SKAction.playSoundFileNamed("player-death", waitForCompletion: false))
                       
            hitObsticle = true
            ScoreManager.Lives -= 1
        }
        
        if (item.name == "portal") {
            self.goForward = true
        }
        
        if (item.name == "portal_to_end") {
            self.gotToEnd = true
        }
        
        if (item.name == "bullet") {
             item.removeFromParent()
             ScoreManager.Bullets += 1
            
             //Running sound
              scene.run(SKAction.playSoundFileNamed("bullet", waitForCompletion: false))
        }
    }
    
    
    //Jumping function
    func Jump() {
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx * 1.5, dy: 700)
        self.animation = .runJump
        self.canJump = false
    }
    
    override func Update() {
        
        //Update animation
        self.animateRun()
        
        //Checking if hit ice or enemy
        if hitObsticle {
            self.animation = .die
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            return
        }
        
        //Getting Device rotation updates
        if let accelerometerData = motionManager.accelerometerData {
            
            //Checking Y limits
            if self.position.y > self.yLimit! {
                self.position.y = self.yLimit!
            }
            
            //Checking if device rotateed right
            if (accelerometerData.acceleration.y < -0.2 && self.position.x <= self.xLimitRight!) {
                
                //Flipping animation dirrection
                self.xScale = abs(self.xScale) * 1
                self.animation = self.animation == .runJump ? .runJump : .run
                self.direction = 1.0
                
                //Changing velocity
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? 500 : 500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                
                 //Checking if device rotateed left
            } else if (accelerometerData.acceleration.y > 0.2 && self.position.x >= self.xLimitLeft!) {
                
                //Flipping animation dirrection
                self.xScale = abs(self.xScale) * -1
                self.animation = self.animation == .runJump ? .runJump : .run
                
                //Changing velocity
                let velX: CGFloat = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? -500 : -500
                
                self.physicsBody?.velocity = CGVector(dx: velX, dy: self.physicsBody!.velocity.dy)
                self.direction = -1.0
                
                 //Device not rotated
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
