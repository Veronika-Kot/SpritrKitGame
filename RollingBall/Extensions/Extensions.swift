//
//  Extensions.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let none     : UInt32 = 0
    static let all      : UInt32 = UInt32.max
    static let player   : UInt32 = 0b1
    static let cherry     : UInt32 = 0b10
    static let platform : UInt32 = 0b100
}

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

extension SKScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.cherry != 0)) {
        if let player = firstBody.node as? SKSpriteNode,
         let item = secondBody.node as? SKSpriteNode {
            ball?.GetItem(item: item)
        }
      }

        if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
                 (secondBody.categoryBitMask & PhysicsCategory.platform != 0)) {
            ball?.canJump = true
        }
    }
}
