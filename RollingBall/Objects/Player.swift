//
//  Player.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

class Player : GameObject
{
//    init(){
//        super.init(imageString: "ball", initialScale: 2.0)
//        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: self.size)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.texture = SKTexture(imageNamed: "ball")
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "ball"), size: self.size)
    }
    
    override func Reset() {
        
    }
    
    override func Start() {
        
    }
    
    override func Update() {
        
    }
}
