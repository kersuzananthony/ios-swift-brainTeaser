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
    
    var currentCard: Card!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let card = createCardFromNIB() {
            currentCard = card
            currentCard.center = AnimationEngine.screenCenterPosition
            self.view.addSubview(currentCard)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func yesPressed(sender: UIButton) {
        if sender.titleLabel?.text == "YES" {
            checkAnswer()
        } else {
            titleLabel.text = "Does this card match the previous?"
        }
        
        showNextCard()
    }
    
    @IBAction func noPressed(sender: UIButton) {
        checkAnswer()
        showNextCard()
    }
    
    func checkAnswer() {
        
    }
    
    func showNextCard() {
        if let current = currentCard {
            let cardToRemove = current
            currentCard = nil
            
            AnimationEngine.animateToPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition, completion: { (animation:POPAnimation!, finished: Bool) in
                cardToRemove.removeFromSuperview()
            })
        }
        
        if let next = createCardFromNIB() {
            next.center = AnimationEngine.offScreenRightPosition
            self.view.addSubview(next)
            currentCard = next
            
            if noButton.hidden {
                noButton.hidden = false
                yesButton.setTitle("YES", forState: UIControlState.Normal)
            }
            
            AnimationEngine.animateToPosition(next, position: AnimationEngine.screenCenterPosition, completion: nil)
        }
    }
    
    func createCardFromNIB() -> Card? {
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
    }
}
