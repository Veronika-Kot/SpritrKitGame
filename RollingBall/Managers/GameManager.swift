//
//  GameManager.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/2/20.
//  Copyright © 2020 centennial. All rights reserved.
//

protocol GameManager {
    func loadStartScene()
    func loadGameScene(level:Int)
    func loadFinishScene()
    func updateLiveView()
    func updateCherryView()
    func updateBulletsView()
    func showEndGame()
}
