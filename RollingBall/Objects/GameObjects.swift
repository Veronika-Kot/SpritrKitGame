//
//  GameObjects.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit
import GameplayKit

//Base class for game objects
class GameObject: SKSpriteNode, GameProtocol
{
    var scale: CGFloat?
    
    init(imageString: String, initialScale: CGFloat) {
        let texture = SKTexture(imageNamed: imageString)
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: CGSize(width: texture.size().width * initialScale, height: texture.size().height * initialScale))
    
    }
    
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
