//
//  GameViewController.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 1/31/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

//Main view controller
class GameViewController: UIViewController, GameManager {
    @IBOutlet weak var newGameButtom: UIButton!
    @IBOutlet weak var cherryView: UIButton!
    @IBOutlet weak var lifeView: UIButton!
    
    @IBOutlet weak var bulletView: UIButton!
    
    @IBOutlet weak var endGameView: UIView!
    @IBOutlet weak var finalScore: UILabel!
    @IBOutlet weak var howToPlayButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endGameView.isHidden = true
        
        //dowloding all sounds in advanced
        do {
            let sounds:[String] = ["BoxCat_Games_-_25_-_Victory", "gotitem", "bullet", "deathenemy", "player-death"]
            for sound in sounds {
                let path: String = Bundle.main.path(forResource: sound, ofType: "mp3")!
                let url: URL = URL(fileURLWithPath: path)
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                
            }
        } catch {
            
        }
        
        //Updating labels
        loadStartScene()
        updateLiveView()
        updateCherryView()
        updateBulletsView()
    }
    
    func updateLiveView() {
        lifeView.setTitle("\(ScoreManager.Lives)", for: .normal)
    }
    func updateCherryView() {
        cherryView.setTitle("\(ScoreManager.Score)", for: .normal)
    }
    
    func updateBulletsView() {
        bulletView.setTitle("\(ScoreManager.Bullets)", for: .normal)
    }
    
    //Loading home/launch screen, hide labels
    func loadStartScene() {
        
        showMenu()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "StartScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    //Show game-over overlay
    func showEndGame() {
        endGameView.isHidden = false
        
        newGameButtom.isHidden = true
        howToPlayButton.isHidden = true
        
        finalScore.text = "Your score: \(ScoreManager.Score)"
    }
    
    //Close game-over overlay
    @IBAction func closeEndGame(_ sender: UIButton) {
        endGameView.isHidden = true
        
        newGameButtom.isHidden = false
        howToPlayButton.isHidden = false
    }
    
    //Load 1 and 2 nd level game scenes
    func loadGameScene(level: Int) {
        if let view = self.view as! SKView? {
            
            if level == 1 {
                if let scene = Level1(fileNamed: "Level1") {
                    scene.scaleMode = .aspectFill
                    scene.gameManager = self
                    view.presentScene(scene)
                }
            } else if level == 2 {
                if let scene = Level2(fileNamed: "Level2") {
                    
                    bulletView.isHidden = false
                    cherryView.setTitleColor(.white, for: .normal)
                    lifeView.setTitleColor(.white, for: .normal)
                    scene.scaleMode = .aspectFill
                    scene.gameManager = self
                    view.presentScene(scene)
                }
            }
            
            
            view.ignoresSiblingOrder = true
        }
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    //Start new game
    @IBAction func newGamePressed(_ sender: UIButton) {
        ScoreManager.Lives = 1
        ScoreManager.Score = 0
        
        loadGameScene(level: 1)
        hideMenu()
    }
    
    //the function to hide all assets from the menu screen
    func hideMenu() {
        newGameButtom.isHidden = true
        howToPlayButton.isHidden = true
        cherryView.isHidden = false
        lifeView.isHidden = false
    }
    
     //the function to show all assets from the menu screen
    func showMenu() {
        newGameButtom.isHidden = false
        howToPlayButton.isHidden = false
        cherryView.isHidden = true
        lifeView.isHidden = true
        bulletView.isHidden = true
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
