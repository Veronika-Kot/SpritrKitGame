//
//  Bulet.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/10/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Class for Bullet, the only objects which created from code
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
        //Setting up Physics body
        if let physics = self.physicsBody {
            physics.isDynamic = true
            physics.allowsRotation = true
            physics.affectedByGravity = false
            
            physics.categoryBitMask = PhysicsCategory.bullet
            physics.contactTestBitMask = PhysicsCategory.enemy
            physics.collisionBitMask = PhysicsCategory.enemy
        }
    }
    
    //Run Animation to fade out and removes from screen/parent
    func fadeAndRemove() {
      let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
      let remove        = SKAction.run({
            self.removeFromParent()
        })
      let sequence      = SKAction.sequence([fadeOutAction, remove])
      self.run(sequence)
    }
    
    override func Reset() {
        self.removeFromParent()
    }
    
    override func Update() {
        
    }
}

