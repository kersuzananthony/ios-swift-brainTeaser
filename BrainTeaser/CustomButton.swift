//
//  CustomButton.swift
//  BrainTeaser
//
//  Created by Kersuzan on 10/06/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit
import pop

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            setUpView()
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.whiteColor() {
        didSet {
            setUpView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func setUpView() {
        self.layer.cornerRadius = cornerRadius
        self.tintColor = fontColor
        
        self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: #selector(CustomButton.scaleToSmall), forControlEvents: UIControlEvents.TouchDragEnter)
        self.addTarget(self, action: #selector(CustomButton.scaleAnimation), forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: #selector(CustomButton.scaleToDefault), forControlEvents: UIControlEvents.TouchDragExit)
    }
    
    func scaleToSmall() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    func scaleAnimation() {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
    }
    
    func scaleToDefault() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleDefaultAnimation")
    }
}
