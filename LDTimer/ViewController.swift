//
//  ViewController.swift
//  LDTimer
//
//  Created by Anirudh Natarajan on 3/18/17.
//  Copyright © 2017 Kodikos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var prepTime: UISegmentedControl!
    @IBOutlet weak var errorText: UILabel!
    
    @IBOutlet weak var ldButton: UIButton!
    @IBOutlet weak var pfButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var prepLabel: UILabel!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        errorText.isHidden = true
        startButton.isHidden = true
        prepLabel.isHidden = true
        prepTime.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StartRound(_ sender: Any) {
        if(prepTime.selectedSegmentIndex==0){
            appDelegate.affPrepTime = 120
            appDelegate.negPrepTime = 120
            self.performSegue(withIdentifier: "roundStart", sender: self)
        } else if(prepTime.selectedSegmentIndex==1){
            appDelegate.affPrepTime = 180
            appDelegate.negPrepTime = 180
            self.performSegue(withIdentifier: "roundStart", sender: self)
        } else if(prepTime.selectedSegmentIndex==2){
            appDelegate.affPrepTime = 240
            appDelegate.negPrepTime = 240
            self.performSegue(withIdentifier: "roundStart", sender: self)
        } else if(prepTime.selectedSegmentIndex==3){
            appDelegate.affPrepTime = 300
            appDelegate.negPrepTime = 300
            self.performSegue(withIdentifier: "roundStart", sender: self)
        } else {
            errorText.isHidden = false
        }
    }
    
    func selectedType(){
        ldButton.isHidden = true
        pfButton.isHidden = true
        policyButton.isHidden = true
        
        startButton.isHidden = false
        prepLabel.isHidden = false
        prepTime.isHidden = false
    }
    
    @IBAction func ldButtonPressed(_ sender: Any) {
        appDelegate.speechNameArray = ["1 AC", "CX", "1 NC", "CX", "1 AR", "1 NR", "2 AR"]
        appDelegate.speechTimeArray = [360, 180, 420, 180, 240, 360, 180]
        appDelegate.form = "ld"
        
        titleText.text = "LD TIMER"
        selectedType()
    }

    @IBAction func pfButtonPressed(_ sender: Any) {
        appDelegate.speechNameArray = ["TEAM A CONSTRUCTIVE", "TEAM B CONSTRUCTIVE", "CROSSFIRE", "TEAM A REBUTTAL", "TEAM B REBUTTAL", "CROSSFIRE", "TEAM A SUMMARY", "TEAM B SUMMARY", "GRAND CX", "TEAM A FINAL FOCUS", "TEAM B FINAL FOCUS"]
        appDelegate.speechTimeArray = [240, 240, 180, 240, 240, 180, 120, 120, 180, 120, 120]
        appDelegate.form = "pf"
        
        titleText.text = "PF TIMER"
        selectedType()
    }
    
    @IBAction func policyButtonPressed(_ sender: Any) {
        appDelegate.speechNameArray = ["1 AC", "CX", "1 NC", "CX", "2 AC", "CX", "2 NC", "CX", "1 NR", "1 AR", "2 NR", "2 AR"]
        appDelegate.speechTimeArray = [480, 180, 480, 180, 480, 180, 480, 180, 300, 300, 300, 300]
        appDelegate.form = "policy"
        
        titleText.text = "POLICY TIMER"
        selectedType()
    }
    
}

