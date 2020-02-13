//
//  Enemy.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/9/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Class for both enemies types
class Enemy: GameObject {
    
    enum Anim {
        case move
        case die
    }
    
    private var enemyRunFrames: [SKTexture] = []
    private var enemyDieFrames: [SKTexture] = []
    var moveDirection:CGFloat = -1.0
    var animationRepeat = 0
    var animation: Anim = .move
    var isDying = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Setup function, since init is called on sks file
    func Setup(name: String, repeatAnim: Int) {
        self.animationRepeat = repeatAnim
        
        //Setup running animation
        let runAnimatedAtlas = SKTextureAtlas(named: name)
        var walkFrames: [SKTexture] = []
        
        let numImages = runAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let runTextureName = "\(name)-\(i)"
            walkFrames.append(runAnimatedAtlas.textureNamed(runTextureName))
        }
        enemyRunFrames = walkFrames
        
        //Setup die animation
        let dieAnimatedAtlas = SKTextureAtlas(named: "enemy-death")
        var dieFrames: [SKTexture] = []
        
        let numImages1 = dieAnimatedAtlas.textureNames.count
        for i in 1...numImages1 {
            let runTextureName = "enemy-death-\(i)"
            dieFrames.append(dieAnimatedAtlas.textureNamed(runTextureName))
        }
        enemyDieFrames = dieFrames
        
        //Generic Settings
        self.setScale(1.7)
        self.texture = enemyRunFrames[0]
        
        //Seting up Physics Body
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.texture!.size().width * 2, height: self.texture!.size().height * 2.5))
        
        if let physics = self.physicsBody {
            
            physics.allowsRotation = false
            physics.angularVelocity = 0
            physics.isDynamic = true
            physics.affectedByGravity = false //(name == "eagle") ? false: true
            physics.linearDamping = 0.5
            physics.angularDamping = 0.5
            physics.friction = 0
            physics.mass = 1.0
            
            physics.categoryBitMask = PhysicsCategory.enemy
            physics.contactTestBitMask = PhysicsCategory.bullet
            physics.contactTestBitMask = PhysicsCategory.player
            physics.collisionBitMask = PhysicsCategory.none
        }
    }
    
    override func Reset(){
        self.removeFromParent()
    }
    
    //Called when hit with bullet
    func die(scene: SKScene){
        
        scene.run(SKAction.playSoundFileNamed("deathenemy", waitForCompletion: false))
        
        self.animation = .die
        self.isDying = true
    }
    
    //Animation fucntion, called from Update
    func animateEnemyRun() {
        
        //Checking animation state enum
        if animation == .move {
            if self.action(forKey: "enemyMoving") == nil {
                let anumateAction = SKAction.repeat(
                    SKAction.animate(with: enemyRunFrames,
                                     timePerFrame: 0.15,
                                     resize: false,
                                     restore: true), count: self.animationRepeat)
                
                let switchAction = SKAction.run({ [weak self] in
                    //Switching direction
                    self!.xScale = self!.xScale * -1
                    self!.moveDirection *= -1
                })
                
                let moveActionWithSwitch = SKAction.sequence([anumateAction, switchAction])
                self.run(SKAction.repeatForever(moveActionWithSwitch), withKey:"enemyMoving")
            }
        } else if animation == .die {
            if self.isDying == true {
                self.isDying = false
                self.run(SKAction.animate(with: enemyDieFrames,
                                          timePerFrame: 0.1,
                                          resize: false,
                                          restore: true),
                         completion: {() -> Void in
                            self.Reset()
                })
            }
        }
    }
    
    override func Update() {
        if animation == .die {
            //Unset dynamic settings, so enemy stop moving whem it dies
            self.physicsBody?.isDynamic = false
        } else {
        
        //Updating velocity
        self.physicsBody?.velocity = CGVector(dx: 150.0 * self.moveDirection, dy: self.physicsBody!.velocity.dy)
        }
        self.animateEnemyRun()
    }
}
