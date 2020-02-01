//
//  GameObjects.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameObject: SKSpriteNode, GameProtocol
{
    var scale: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func Reset() {
        
    }
    
    func Setup() {
        
    }
    
    func Update() {
        
    }
}
