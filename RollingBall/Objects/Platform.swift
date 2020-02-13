//
//  Platform.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/1/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Class for all platforms
class Platform : GameObject
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    //Setup function, since init is called on sks file
    override func Setup() {
        
        //setups physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        if let physics = self.physicsBody {
            physics.isDynamic = false
            physics.allowsRotation = false
            physics.affectedByGravity = false
            
            physics.categoryBitMask = PhysicsCategory.platform
            physics.contactTestBitMask = PhysicsCategory.player
            physics.collisionBitMask = PhysicsCategory.player
        }
    }
    
    override func Reset() {
        
    }
    
    override func Update() {
        
    }
}

