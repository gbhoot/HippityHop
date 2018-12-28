//
//  ViewController.swift
//  HippityHop
//
//  Created by Gurpal Bhoot on 11/1/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import CoreData
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate, UITextFieldDelegate {
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
   
   @IBOutlet weak var bannerView: GADBannerView!
   let MAX_ERROR = 3
   var num_error = 0
   @IBOutlet weak var gameClockLabel: UILabel!
   @IBOutlet weak var stopBtn: UIButton!
   @IBOutlet weak var playPauseBtn: UIButton!
   @IBOutlet weak var currentScoreLbl: UILabel!
   @IBOutlet weak var heartLifeAImg: UIImageView!
   @IBOutlet weak var heartLifeBImg: UIImageView!
   @IBOutlet weak var heartLifeCImg: UIImageView!
   @IBOutlet weak var alphaView: UIView!
   
    var motionManager: CMMotionManager?
    var player: AVAudioPlayer?
   
    var startRoll = 0.0
    var startPitch = 0.0
    
   var directions = [ "Left", "Right", "Up", "Down"]
   
    var current = 0
   var currentScore = 0
    var turn : String = "Normal"
   var seconds = 3
   var timer = Timer()
   var gmaeTimer = Timer()
   var isTimerRunning = false
   var isStart  = true
   
   
   
   var highestScore : Int?
    var currDirection = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      effect = visualEffectView.effect
      visualEffectView.effect = nil
      visualEffectView.isHidden = true
      popUpView.layer.cornerRadius = 5
      
      self.playPauseBtn.isEnabled = false
//        bannerView.adUnitID = "ca-app-pub-2882661438073065/9079075290"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
      
        stopBtn.isHidden = true
        currentScoreLbl.isHidden = true
        alphaView.isHidden = false
      
        motionManager = CMMotionManager()
        startGame()
      
        getHighestScore()
    }
   
   
   func convertSecondsToStr(seconds: Int) -> String {
      return  String(format: "%02d", seconds / 60) + ":" + String(format: "%02d", seconds % 60)
   }
   
   func getHighestScore(){
      let recordRequest:NSFetchRequest<Record> = Record.fetchRequest()
      do {
         var items = try context.fetch(recordRequest)
         items = items.sorted(by: {Int($0.score!)! > Int($1.score!)!})
         if items.count > 0{
            highestScore = Int(items[0].score!)!
         }
         
         
      } catch {
         print(error)
      }
   }
   
   var gameTime = 60
   func runGame(){
      num_error = 0
      gameTime = 0
      currentScore = 0
      currentScoreLbl.text = "\(currentScore)"
      self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      alphaView.isHidden = false
      

      if let manager = motionManager {
         if manager.isDeviceMotionAvailable {
            let myQ = OperationQueue()
            manager.deviceMotionUpdateInterval = 0.01 // Need to check on that 0.01
            manager.startDeviceMotionUpdates(to: myQ, withHandler: { (data: CMDeviceMotion?, error: Error?) in
               if let myData = data {
                  let attitude = myData.attitude
                  let pitch = self.degrees(radians: attitude.pitch)
                  let roll = self.degrees(radians: attitude.roll)
//                  print("roll:", roll)
//                  print("pitch:", pitch)

                  if self.startRoll == 0 || self.startPitch == 0 {
                     self.startRoll = roll
                     self.startPitch = pitch
                  } else if (self.turn == "Up" || self.turn == "Down") && abs(self.startPitch - pitch) < 10 {
                     if self.turn == "Up"{
                        DispatchQueue.main.async {
                           print("*******flip up*******", pitch)
                           if self.currDirection == "Up"{
                              self.rightDirection()
                           }else{
                              self.wrongDirection()
                           }
                        }
                        
                        self.turn = "Normal"
                     }else if self.turn == "Down"{
                        DispatchQueue.main.async {
                           print("******flip Down********", pitch)
                           if self.currDirection == "Down"{
                              self.rightDirection()
                           }else{
                              self.wrongDirection()
                           }
                        }
                        
                        self.turn = "Normal"
                     }
                     
                  }else if (self.turn == "Right" || self.turn == "Left") && abs(self.startRoll - roll) < 10 {
                     if self.turn == "Left"{
                        DispatchQueue.main.async {
                           print("*******flip Left*******", roll)
                           if self.currDirection == "Left"{
                              self.rightDirection()
                           }else{
                              self.wrongDirection()
                           }
                        }
                        
                        self.turn = "Normal"
                     }else if self.turn == "Right"{
                        DispatchQueue.main.async {
                           print("******flip Right********", roll)
                           if self.currDirection == "Right"{
                              self.rightDirection()
                           }else{
                              self.wrongDirection()
                           }
                           
                           
                        }
                        
                        self.turn = "Normal"
                     }
                     
                  }else if self.turn == "Normal" && abs(self.startPitch - pitch) > 35{
                     if self.startPitch - pitch < 0 {
                        self.turn = "Up"
                     } else {
                        self.turn = "Down"
                     }
                  } else if self.turn == "Normal" && abs(self.startRoll - roll) > 45{
                     if abs(roll - self.startRoll) < 10 {
                        print("Back to normal", roll)
                     } else if self.startRoll - roll < -40 {
                        self.turn = "Right"
                     } else if self.startRoll - roll > 40 {
                        self.turn = "Left"
                     }
                  }

               }
            })
         }
      }
   }
   
   func rightDirection() {
      currentScore += 5
      DispatchQueue.main.async {
         self.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
         self.playPauseBtn.isHidden = true
         
      }
      currentScoreLbl.isHidden = false
      currentScoreLbl.text = "\(currentScore)"
   }
   
   @objc func updateGameTimer() {
      gameTime += 1     //This will decrement(count down)the seconds.
      
      //      DispatchQueue.main.async {
      if self.view.backgroundColor == #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) {
            self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.playPauseBtn.isHidden = false
            self.getDirection()
            self.runTimer()
      }else if self.view.backgroundColor == #colorLiteral(red: 0.9988920093, green: 0.1356536225, blue: 0.09543365591, alpha: 1){
         self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      }
      
      //      }
      
   }
   
   func wrongDirection() {
      num_error += 1
      
      for _ in 1 ... num_error{
         AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
      }

      self.view.backgroundColor = #colorLiteral(red: 0.9988920093, green: 0.1356536225, blue: 0.09543365591, alpha: 1)
      seconds = 3
      self.makeSiriSay(direction: currDirection)
      currentScore -= 10
      currentScoreLbl.text = "\(currentScore)"
      loseGameLife()
      self.playPauseBtn.isHidden = false

      if num_error == MAX_ERROR {
         stopGame()
      }
   }
   
   func restartGameLives() {
      heartLifeAImg.image = UIImage(named: "heart")
      heartLifeBImg.image = UIImage(named: "heart")
      heartLifeCImg.image = UIImage(named: "heart")
   }
   
   func loseGameLife() {
      switch num_error {
      case 1:
         heartLifeAImg.image = UIImage(named: "broken-heart")
      case 2:
         heartLifeBImg.image = UIImage(named: "broken-heart")
      case 3:
         heartLifeCImg.image = UIImage(named: "broken-heart")
      default:
         break
      }
   }
    
    func musicPlayer(playPause: Bool) {
        if let asset = NSDataAsset(name: "funkTheFloor") {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"caf")
                player?.volume = 0.5
                if playPause {
                    player?.play()
                } else {
                    player?.pause()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
   
   func runTimer() {
      seconds = 3
      if (isTimerRunning == false){
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
         
         isTimerRunning = true
      }
   }
   
   func runGameTimer() {
         gmaeTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateGameTimer)), userInfo: nil, repeats: true)

   }
   @objc func updateTimer() {
      if isStart{
         playPauseBtn.setTitle(String(seconds), for: .normal)
         if seconds == 0 {
            visualEffectView.effect = nil
            getDirection()
            runGameTimer()
            runGame()
            
            timer.invalidate()
            makeSiriSay(direction: currDirection)
            isTimerRunning = false
            alphaView.isHidden = true
            stopBtn.isHidden = false
            currentScoreLbl.isHidden = false
            isStart = false
         }
      }else{
         gameClockLabel.text = convertSecondsToStr(seconds: seconds) //This will update the label.
         if seconds == 0 {
            
            self.wrongDirection()
            if num_error < MAX_ERROR {
               self.runTimer()
               return
            }else{
               num_error = 0
            }
         }
      }
      seconds -= 1     //This will decrement(count down)the seconds.
   }
   
   
   
   func startGame(){
      gameClockLabel.text = "00:00"
//      playPauseBtn.setTitle("3", for: .normal)
      playPauseBtn.setBackgroundImage(UIImage(), for: .normal)
      musicPlayer(playPause: true)
      isStart = true
      isTimerRunning = false
      restartGameLives()
      runTimer()
   }
   
   
   func getDirection(){
      let index = Int.random(in: 0 ... 3)
      currDirection = directions[index]
      makeSiriSay(direction: currDirection)
   }
    
    func makeSiriSay(direction: String) {
        let utterance = AVSpeechUtterance(string: direction)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        playPauseBtn.isEnabled = false
        playPauseBtn.setTitle("", for: .normal)
        DispatchQueue.main.async {
            self.playPauseBtn.setBackgroundImage(UIImage(named: direction), for: .normal)
        }
        stopBtn.isHidden = false
    }
    
    func degrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
   @IBAction func stopBtnClicked(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
      stopGame()
   }
   
   func stopGame(){
      gmaeTimer.invalidate()
      musicPlayer(playPause: false)
      motionManager?.stopDeviceMotionUpdates()
      stopBtn.isHidden = true
      playPauseBtn.isEnabled = true
      playPauseBtn.setBackgroundImage(UIImage(), for: .normal)
      timer.invalidate()
      self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      
      popUpAlert()
   }
   
   func popUpAlert(){
      

      if let bestScore = highestScore {
         if currentScore > bestScore{
            title = "Congrats! You have the highest score!"
            highestScore = currentScore
            anotherViewBestScore.text = String(currentScore)
         }else{
            anotherViewBestScore.text = String(bestScore)
         }
      }else{
         anotherViewBestScore.text = String(currentScore)
      }
      anotherViewScoreLabel.text = String(currentScore)
      
      
      
      animateIn()

   }
   
//*****************************************************
//   another view
//*****************************************************
   
   @IBOutlet weak var anotherViewNameTextField: UITextField!
   @IBOutlet weak var anotherViewBestScore: UILabel!
   @IBOutlet weak var anotherViewScoreLabel: UILabel!
   @IBOutlet weak var visualEffectView: UIVisualEffectView!
   @IBOutlet var popUpView: UIView!
   var effect : UIVisualEffect!
   
   @IBAction func anotherViewCancelBtnClicked(_ sender: Any) {
      animateOut()
      dismiss(animated: true, completion: nil)
   }
   
   
   @IBAction func anotherViewSaveBtnClicked(_ sender: Any) {
      
         let newRecord = Record(context: self.context)
      
         if anotherViewNameTextField.text! == ""{
            newRecord.name = "Unknown"
         }else{
            newRecord.name = anotherViewNameTextField.text!
         }


         newRecord.score = String(self.currentScore)
         self.saveContext()
         self.dismiss(animated: true, completion: nil)
   }
   @IBAction func anotherViewPlayAgainClicked(_ sender: Any) {
      animateOut()
      self.startGame()
      
   }
   func animateIn(){
      self.view.addSubview(popUpView)
      popUpView.center = self.view.center
      popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      popUpView.alpha = 0
      
      UIView.animate(withDuration: 0.4){
         self.visualEffectView.effect = self.effect
         self.visualEffectView.isHidden = false
         self.popUpView.alpha = 1
         self.popUpView.transform = CGAffineTransform.identity
      }
   }
   
   
   func animateOut()  {
      UIView.animate(withDuration: 0.3, animations: {
         self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
         self.popUpView.alpha = 0
         self.visualEffectView.effect = nil
         self.visualEffectView.isHidden = true
         self.currentScoreLbl.text = "0"
      }){(success :Bool) in
         self.popUpView.removeFromSuperview()
      }
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      anotherViewNameTextField.delegate = self
      anotherViewNameTextField.returnKeyType = .done
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool{
      textField.resignFirstResponder()
      return true
   }
   
}


