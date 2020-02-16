//
//  GameManager.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//


//Protocol for GameViewController, so it can be accessible from game scenes
protocol GameManager {
    func loadStartScene()
    func loadGameScene(level:Int)
    func updateLiveView()
    func updateCherryView()
    func updateBulletsView()
    func showEndGame()
}
