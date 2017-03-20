//
//  PrepTime.swift
//  LDTimer
//
//  Created by Anirudh Natarajan on 3/18/17.
//  Copyright © 2017 Kodikos. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PrepTime: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var affButton: UIButton!
    @IBOutlet weak var negButton: UIButton!
    @IBOutlet weak var MPButton: UIButton!
    
    var affPrep: Bool = Bool()
    
    var timer = Timer()
    var blinkTimer = Timer()
    var audioPlayer = AVAudioPlayer()
    
    var buttonState: Int = 0
    var backButtonState: Int = 0
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if(appDelegate.form == "pf"){
            affButton.setTitle("PRO", for: .normal)
            negButton.setTitle("CON", for: .normal)
        }
        
        let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Alarm-tone", ofType: "mp3")!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: alertSound as URL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
        } catch {
            print("Error getting the audio file")
        }
        
        timeLabel.isHidden = true
        MPButton.isHidden = true
    }
    
    @IBAction func AffPressed(_ sender: Any) {
        affPrep = true
        
        timeLabel.isHidden = false
        MPButton.isHidden = false
        affButton.isHidden = true
        negButton.isHidden = true
        backButtonState = 1
        
        setTime()
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        MPButton.setTitle("START", for: .normal)
    }
    
    @IBAction func NegPressed(_ sender: Any) {
        affPrep = false
        
        timeLabel.isHidden = false
        MPButton.isHidden = false
        affButton.isHidden = true
        negButton.isHidden = true
        backButtonState = 1
        
        setTime()
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        MPButton.setTitle("START", for: .normal)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        timer.invalidate()
        if(backButtonState == 0){
            self.performSegue(withIdentifier: "prepUsed", sender: self)
        } else if (backButtonState == 1){
            timeLabel.isHidden = true
            MPButton.isHidden = true
            affButton.isHidden = false
            negButton.isHidden = false
            
            backButtonState = 0
        }
    }
    
    @IBAction func MPButonPressed(_ sender: Any) {
        if(buttonState==0){ // START
            start()
        } else if(buttonState==1){ // PAUSE
            pause()
        } else if(buttonState==2){ // RESUME
            start()
        } else if(buttonState==3){ // STOP
            reset()
        }
    }
    
    func setTime(){
        if(affPrep){
            let seconds: Int = appDelegate.affPrepTime%60
            if(seconds/10==0){
                timeLabel.text = "\(appDelegate.affPrepTime/60):0\(seconds)"
            } else{
                timeLabel.text = "\(appDelegate.affPrepTime/60):\(seconds)"
            }
        } else {
            let seconds: Int = appDelegate.negPrepTime%60
            if(seconds/10==0){
                timeLabel.text = "\(appDelegate.negPrepTime/60):0\(seconds)"
            } else{
                timeLabel.text = "\(appDelegate.negPrepTime/60):\(seconds)"
            }
        }
    }
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainTimer.countdown), userInfo: nil, repeats: true)
        MPButton.backgroundColor = UIColor(red: 138/255, green: 12/255, blue: 0/255, alpha: 1)
        MPButton.setTitle("PAUSE", for: .normal)
        buttonState = 1
    }
    
    func countdown(){
        if(affPrep){
            appDelegate.affPrepTime -= 1
            setTime()
            
            if(appDelegate.affPrepTime <= 0){
                timeOver()
            }
        } else {
            appDelegate.negPrepTime -= 1
            setTime()
            
            if(appDelegate.negPrepTime <= 0){
                timeOver()
            }
        }
    }
    
    func pause(){
        timer.invalidate()
        MPButton.backgroundColor = UIColor(red: 4/255, green: 118/255, blue: 0/255, alpha: 1)
        MPButton.setTitle("RESUME", for: .normal)
        buttonState = 2
    }
    
    func timeOver(){
        timer.invalidate()
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        MPButton.setTitle("STOP", for: .normal)
        blinkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainTimer.alarm), userInfo: nil, repeats: true)
        audioPlayer.play()
        buttonState = 3
    }
    
    func alarm(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .autoreverse, .allowUserInteraction], animations: {() -> Void in
            self.MPButton.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .autoreverse, .allowUserInteraction], animations: {() -> Void in
            self.MPButton.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
        })
    }
    
    func reset(){
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        blinkTimer.invalidate()
        audioPlayer.stop()
        self.performSegue(withIdentifier: "prepUsed", sender: self)
    }
    
}





