//
//  Item.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Class for all Items (cherries, hurts, portal, ice)
class Item : GameObject
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    //Setup function, since init is called on sks file
    override func Setup() {
        
       self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        
        if let physics = self.physicsBody {
            physics.isDynamic = false
            physics.allowsRotation = false
            physics.affectedByGravity = false
            
            physics.categoryBitMask = PhysicsCategory.item
            physics.contactTestBitMask = PhysicsCategory.player
            physics.collisionBitMask = PhysicsCategory.none
        }
    }
    
    override func Reset() {
        
    }
    
    override func Update() {
        
    }
}



