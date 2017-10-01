//
//  ViewController.swift
//  BullsEye-Swift4
//
//  Created by Jay on 2017/10/1.
//  Copyright © 2017年 look4us. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    var currentValue:Int = 0
    
    var targetValue: Int = 0
    
    var score = 0
    
    var round = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
        
        
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert(){
        
        let difference = abs(currentValue - targetValue)
        
        var points = 100 - difference
        
        score += points
        
        let title: String
        
        if difference == 0 {
            
            title = "Perfect!"
            points += 100
            
        } else if difference < 5 {
            title = "You almost had it!"
            points += 50
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        
        let message = "You scored \(points) points!"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK!", style: .default, handler: {action in self.startNewRound()})
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }

    @IBAction func sliderMoved(_ slider:UISlider) {
        
        currentValue = lroundf(slider.value)
        print("The Value of the slider is now:\(slider.value)")
        
    }
    
    func startNewRound(){
        
        round += 1
        
        targetValue = 1 + Int(arc4random_uniform(100))
        
        currentValue = 50
        
        slider.value = Float(currentValue)
        
        updateLabels()
    }
    
    func updateLabels() {
        
        targetLabel.text = String(targetValue)
        
        scoreLabel.text = String(score)
        
        roundLabel.text = String(round)
        
    }
    
    func startNewGame(){
        
        score = 0
        round = 0
        startNewRound()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        view.layer.add(transition, forKey: nil)
    }
    
    @IBAction func startOver(){
        startNewGame()
    }
}

