//
//  HowToPlayViewController.swift
//  RollingBall
//
//  Created by Veronika Kotckovich on 2/11/20.
//  Student ID: 301067511
//  Copyright © 2020 centennial. All rights reserved.
//

import UIKit

//Instractions view controller
class HowToPlayViewController: UIViewController {

    @IBOutlet weak var instractionsView: UIImageView!
    
    var index = 0
    
    //Array of instraction images
    let images = ["Move_instraction", "Jump_instraction", "Tap_instraction", "Items", "Avoid", "Portal_instractions"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instractionsView.image = UIImage(named: images[index])

        // Do any additional setup after loading the view.
    }
    
    //Right button call to navigate in array of unstractions
    @IBAction func onRightButton(_ sender: UIButton) {
        if(index < images.count - 1) {
            index += 1
            
             instractionsView.image = UIImage(named: images[index])
        }
    }
    
     //Left button call to navigate in array of unstractions
    @IBAction func onLeftButton(_ sender: UIButton) {
        if(index > 0) {
            index -= 1
            
             instractionsView.image = UIImage(named: images[index])
        }
    }
    
    //Close function
    @IBAction func onCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
