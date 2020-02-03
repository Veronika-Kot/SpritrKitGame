//
//  Item.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

class Item : GameObject
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override func Setup() {
        
//        self.texture = SKTexture(imageNamed: "cherry")
        
       self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        
        if let physics = self.physicsBody {
            physics.isDynamic = false
            physics.allowsRotation = false
            physics.affectedByGravity = false
            
            physics.categoryBitMask = PhysicsCategory.cherry
            physics.contactTestBitMask = PhysicsCategory.player
        }
    }
    
    override func Reset() {
        
    }
    
    override func Update() {
        
    }
}



