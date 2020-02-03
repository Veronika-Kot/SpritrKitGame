//
//  GameViewController.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameManager {
    
    @IBOutlet weak var newGameButtom: UIButton!
    @IBOutlet weak var cherryView: UIButton!
    @IBOutlet weak var lifeView: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStartScene()
        updateLiveView()
        updateCherryView()
    }
    
    func updateLiveView() {
        lifeView.setTitle("\(ScoreManager.Lives)", for: .normal)
    }
    func updateCherryView() {
        cherryView.setTitle("\(ScoreManager.Score)", for: .normal)
    }

    func loadStartScene() {
        
        showMenu()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "StartScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadGameScene(level: Int) {
        if let view = self.view as! SKView? {
               if let scene = Level1(fileNamed: "Level1") {
                   scene.scaleMode = .aspectFill
                   scene.gameManager = self
                   view.presentScene(scene)
               }
               
               view.ignoresSiblingOrder = true
               
               view.showsFPS = true
               view.showsNodeCount = true
        }
    }
    
    func loadFinishScene() {
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        ScoreManager.Lives = 7
        ScoreManager.Score = 0
        
        loadGameScene(level: 1)
        hideMenu()
    }
    
    func hideMenu() {
        newGameButtom.isHidden = true
        
        cherryView.isHidden = false
        lifeView.isHidden = false
    }
    
    func showMenu() {
        newGameButtom.isHidden = false
        
        cherryView.isHidden = true
        lifeView.isHidden = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
