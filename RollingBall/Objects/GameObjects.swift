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
