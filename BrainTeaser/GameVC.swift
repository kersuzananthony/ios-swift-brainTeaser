//
//  GameVC.swift
//  BrainTeaser
//
//  Created by Kersuzan on 10/06/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController {

    @IBOutlet weak var yesButton: CustomButton!
    @IBOutlet weak var noButton: CustomButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentCard: Card!
    var scoreCard: ScoreCard!
    var previousShape: String!
    var correctAnswer: Int = 0
    var incorrectAnswer: Int = 0
    var timer = NSTimer()
    var counter: NSTimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let card = createCardFromNIB() {
            currentCard = card
            currentCard.center = AnimationEngine.screenCenterPosition
            self.view.addSubview(currentCard)
        }
        
        if let card = createScoreCardFromNIB() {
            scoreCard = card
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func yesPressed(sender: UIButton) {
        if sender.titleLabel?.text == "YES" {
            checkAnswer(true)
            previousShape = currentCard.currentShape
            showNextCard()
        } else if sender.titleLabel?.text == "RESTART" {
            titleLabel.text = "Remember this image"
            scoreCard.removeFromSuperview()
            correctAnswer = 0
            incorrectAnswer = 0
            yesButton.setTitle("START", forState: .Normal)
            
            currentCard = createCardFromNIB()
            currentCard.center = AnimationEngine.screenCenterPosition
            self.view.addSubview(currentCard)
            timeLabel.text = "1:00"
        } else {
            titleLabel.text = "Does this card match the previous?"
            previousShape = currentCard.currentShape
            showNextCard()
        }
    }
    
    @IBAction func noPressed(sender: UIButton) {
        checkAnswer(false)
        previousShape = currentCard.currentShape
        showNextCard()
    }
    
    func checkAnswer(answer: Bool) {
        if (answer == true && currentCard.currentShape == previousShape) || (answer == false && currentCard.currentShape != previousShape) {
            correctAnswer += 1
            currentCard.answerImage.hidden = false
            currentCard.answerImage.image = UIImage(named: "correct")
        } else {
            incorrectAnswer += 1
            currentCard.answerImage.hidden = false
            currentCard.answerImage.image = UIImage(named: "incorrect")
        }
        
        print("Correct Answers: \(correctAnswer)")
        print("Incorrect Answers: \(incorrectAnswer)")
    }
    
    func gameOver() {
        self.noButton.hidden = true
        self.yesButton.setTitle("RESTART", forState: .Normal)
        self.titleLabel.text = "Game Over!"
        
        removeCurrentCard()
        
        self.scoreCard.center = AnimationEngine.offScreenRightPosition
        self.view.addSubview(self.scoreCard)
        self.scoreCard.hidden = true
        
        scoreCard.correctScore.text = "\(correctAnswer)"
        scoreCard.incorrectScore.text = "\(incorrectAnswer)"
        scoreCard.totalScore.text = "\(correctAnswer + incorrectAnswer)"
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.3) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.scoreCard.hidden = false
            AnimationEngine.animateToPosition(self.scoreCard, position: AnimationEngine.screenCenterPosition, completion: nil)
        }
    }
    
    func showNextCard() {
        removeCurrentCard()
        
        if let next = createCardFromNIB() {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.3) * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                next.center = AnimationEngine.offScreenRightPosition
                self.view.addSubview(next)
                
                AnimationEngine.animateToPosition(next, position: AnimationEngine.screenCenterPosition, completion: nil)
            }
            
            currentCard = next
            
            if noButton.hidden {
                noButton.hidden = false
                yesButton.setTitle("YES", forState: UIControlState.Normal)
                setTimer()
            }
        }
    }
    
    func removeCurrentCard() {
        if let current = currentCard {
            let cardToRemove = current
            currentCard = nil
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.3) * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue()) {
                AnimationEngine.animateToPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition, completion: { (animation:POPAnimation!, finished: Bool) in
                    cardToRemove.removeFromSuperview()
                })
            }
        }
    }
    
    func createCardFromNIB() -> Card? {
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
    }
    
    func createScoreCardFromNIB() -> ScoreCard? {
        return NSBundle.mainBundle().loadNibNamed("ScoreCard", owner: self, options: nil)[0] as? ScoreCard
    }
    
    func setTimer() {
        print("Set timer called")
        counter = NSTimeInterval(60)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameVC.onTimer), userInfo: nil, repeats: true)
    }
    
    func setTimeLabelText(time: NSTimeInterval) -> String {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        return String(format:"%d:%02d", minutes, seconds)
    }
    
    func onTimer() {
        if counter > 0 {
            counter = counter - 1
            timeLabel.text = setTimeLabelText(counter)
        } else {
            counter = 0
            gameOver()
            timer.invalidate()
        }
    }
}
