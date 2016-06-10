//
//  AnimationEngine.swift
//  BrainTeaser
//
//  Created by Kersuzan on 10/06/16.
//  Copyright © 2016 Kersuzan. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    var originalConstants = [CGFloat]()
    var constraints = [NSLayoutConstraint]()
    
    init(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            originalConstants.append(constraint.constant)
            constraint.constant = AnimationEngine.offScreenRightPosition.x // Move to Right
        }
        
        self.constraints = constraints
    }
    
    func animateOnScreen(delay: Double?) {
        
        let d = delay == nil ? 0.8 * Double(NSEC_PER_SEC) : delay! * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        
        dispatch_after(time, dispatch_get_main_queue()) { 
            var index = 0
            repeat {
                let moveAnimation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnimation.toValue = self.originalConstants[index]
                moveAnimation.springBounciness = 12.0
                moveAnimation.springSpeed = 12.0
                
                if index > 0 {
                    moveAnimation.dynamicsFriction += 5 + CGFloat(index)
                }
                
                let constraint = self.constraints[index]
                constraint.pop_addAnimation(moveAnimation, forKey: "moveOnScreen")
                
                index += 1
                
            } while (index < self.constraints.count)
        }
    }
}
