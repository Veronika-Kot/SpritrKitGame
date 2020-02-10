//
//  Enemy.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/9/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

class Enemy: GameObject {
    
    private var enemyRunFrames: [SKTexture] = []
    var moveDirection:CGFloat = -1.0
    var animationRepeat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        
        self.setScale(1.7)
        self.texture = enemyRunFrames[0]
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.texture!.size().width * 2, height: self.texture!.size().height * 2.5))
        
        if let physics = self.physicsBody {
            
            physics.allowsRotation = false
            physics.angularVelocity = 0
            physics.isDynamic = true
            physics.affectedByGravity = (name == "eagle") ? false: true
            physics.linearDamping = 0.5
            physics.angularDamping = 0.5
            physics.friction = 0
            physics.mass = 1.0
            
            physics.categoryBitMask = PhysicsCategory.item
            physics.contactTestBitMask = PhysicsCategory.player
        }
    }
    
    func animateEnemyRun() {
        let anumateAction = SKAction.repeat(
            SKAction.animate(with: enemyRunFrames,
                             timePerFrame: 0.15,
                             resize: false,
                             restore: true), count: self.animationRepeat)
        
        let switchAction = SKAction.run({ [weak self] in
            self!.xScale = self!.xScale * -1
            self!.moveDirection *= -1
        })

        let moveActionWithSwitch = SKAction.sequence([anumateAction, switchAction])
        self.run(SKAction.repeatForever(moveActionWithSwitch), withKey:"enemyMoving")
        
    }
    
    override func Update() {
        self.physicsBody?.velocity = CGVector(dx: 150.0 * self.moveDirection, dy: self.physicsBody!.velocity.dy)
    }
}
