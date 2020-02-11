//
//  Bulet.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/10/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

class Bulet : GameObject
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    init(){
        super.init(imageString: "bullet", initialScale: 1.2)
        self.Setup()
    }
    
    override func Setup() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        if let physics = self.physicsBody {
            physics.isDynamic = true
            physics.allowsRotation = true
            physics.affectedByGravity = false
            
            physics.categoryBitMask = PhysicsCategory.bullet
            physics.contactTestBitMask = PhysicsCategory.enemy
            physics.collisionBitMask = PhysicsCategory.enemy
        }
    }
    
    func fadeAndRemove() {
      let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
      let remove        = SKAction.run({ self.removeFromParent }())
      let sequence      = SKAction.sequence([fadeOutAction, remove])
      self.run(sequence)
    }
    
    override func Reset() {
        self.removeFromParent()
    }
    
    override func Update() {
        
    }
}

