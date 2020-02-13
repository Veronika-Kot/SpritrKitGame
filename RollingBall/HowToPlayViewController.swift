//
//  HowToPlayViewController.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/11/20.
//  Copyright © 2020 centennial. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    @IBOutlet weak var instractionsView: UIImageView!
    
    var index = 0
    
    let images = ["Move_instraction", "Jump_instraction", "Tap_instraction", "Items", "Avoid", "Portal_instractions"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instractionsView.image = UIImage(named: images[index])

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRightButton(_ sender: UIButton) {
        if(index < images.count - 1) {
            index += 1
            
             instractionsView.image = UIImage(named: images[index])
        }
    }
    
    @IBAction func onLeftButton(_ sender: UIButton) {
        if(index > 0) {
            index -= 1
            
             instractionsView.image = UIImage(named: images[index])
        }
    }
    
    @IBAction func onCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
