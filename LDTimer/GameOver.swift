//
//  GameOver.swift
//  LDTimer
//
//  Created by Anirudh Natarajan on 3/19/17.
//  Copyright © 2017 Kodikos. All rights reserved.
//

import Foundation
import UIKit

class GameOver: UIViewController {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    @IBAction func newRoundPressed(_ sender: Any) {
        appDelegate.affPrepTime = 0
        appDelegate.negPrepTime = 0
        appDelegate.speechID = 0
        appDelegate.speechTimeArray = [360, 180, 420, 180, 240, 360, 180]
        self.performSegue(withIdentifier: "newRound", sender: self)
    }
}
