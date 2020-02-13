//
//  MathSignsOverloads.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import SpriteKit

//Extra oparators overloads
//https://www.raywenderlich.com/71-spritekit-tutorial-for-beginners
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif
