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
    
    init(imageString: String, initialScale: CGFloat){
            
            let texture = SKTexture(imageNamed: imageString)
            let color = UIColor.clear
            super.init(texture: texture, color: color, size: texture.size())
            
            self.scale = initialScale
            self.setScale(scale!)
        
            self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageString), size: self.size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            //fatalError("init(coder:) has not been implemented")
        }
    
    func Reset() {
        
    }
    
    func Start() {
        
    }
    
    func Update() {
        
    }
}
