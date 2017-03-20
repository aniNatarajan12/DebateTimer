//
//  MainTimer.swift
//  LDTimer
//
//  Created by Anirudh Natarajan on 3/18/17.
//  Copyright © 2017 Kodikos. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MainTimer: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var MPButton: UIButton!
    @IBOutlet weak var speechTitle: UILabel!
    
    var appDelegate: AppDelegate!
    
    var buttonState: Int = 0
    var isSpeaking = false
    
    var timer = Timer()
    var blinkTimer = Timer()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        setupNextSpeech()
        
        let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Alarm-tone", ofType: "mp3")!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: alertSound as URL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
        } catch {
            print("Error getting the audio file")
        }
    }
    
    @IBAction func MPButtonAction(_ sender: Any) {
        if(buttonState==0){ // START
            start()
        } else if(buttonState==1){ // PAUSE
            pause()
        } else if(buttonState==2){ // RESUME
            start()
        } else if(buttonState==3){ // STOP
            reset()
            setupNextSpeech()
        }
    }
    
    @IBAction func PrepButtonPressed(_ sender: Any) {
        if(!isSpeaking){
            if(audioPlayer.isPlaying){
                audioPlayer.stop()
            }
            self.performSegue(withIdentifier: "usePrep", sender: self)
        }
    }
    
    func setTime(){
        let seconds: Int = appDelegate.speechTimeArray[appDelegate.speechID]%60
        if(seconds/10==0){
            timerLabel.text = "\(appDelegate.speechTimeArray[appDelegate.speechID]/60):0\(seconds)"
        } else{
            timerLabel.text = "\(appDelegate.speechTimeArray[appDelegate.speechID]/60):\(seconds)"
        }
    }
    
    func setupNextSpeech(){
        if(appDelegate.speechID >= appDelegate.speechTimeArray.count){
            self.performSegue(withIdentifier: "roundOver", sender: self)
            return
        }
        setTime()
        speechTitle.text = appDelegate.speechNameArray[appDelegate.speechID]
        
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        MPButton.setTitle("START SPEECH", for: .normal)
        buttonState = 0
    }
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainTimer.countdown), userInfo: nil, repeats: true)
        MPButton.backgroundColor = UIColor(red: 138/255, green: 12/255, blue: 0/255, alpha: 1)
        MPButton.setTitle("PAUSE", for: .normal)
        buttonState = 1
        isSpeaking = true
    }
    
    func countdown(){
        appDelegate.speechTimeArray[appDelegate.speechID] -= 1
        setTime()
        
        if(appDelegate.speechTimeArray[appDelegate.speechID] <= 0){
            timeOver()
        }
    }
    
    func pause(){
        timer.invalidate()
        MPButton.backgroundColor = UIColor(red: 4/255, green: 118/255, blue: 0/255, alpha: 1)
        MPButton.setTitle("RESUME", for: .normal)
        buttonState = 2
        isSpeaking = false
    }
    
    func timeOver(){
        timer.invalidate()
        appDelegate.speechID += 1
        MPButton.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
        MPButton.setTitle("STOP", for: .normal)
        blinkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainTimer.alarm), userInfo: nil, repeats: true)
        buttonState = 3
        audioPlayer.play()
        isSpeaking = false
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
        blinkTimer.invalidate()
        audioPlayer.stop()
    }
    
    
}








