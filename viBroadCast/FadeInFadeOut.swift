//
//  FadeInFadeOut.swift
//  viBroadCast
//
//  Created by DatTran on 5/15/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//

import UIKit
import QuartzCore


class FadeInFadeOut: NSObject {
    
    func makeButtonFadeInFadeOut(sender: UIButton) {
        sender.highlighted = true
        
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {sender.alpha = 0.0},
                                   completion:{(finished:Bool) -> Void in
                                    
                                    UIView.animateWithDuration(0.1,
                                        delay: 0.0,
                                        options: UIViewAnimationOptions.CurveEaseIn,
                                        animations: {sender.alpha = 1.0},
                                        completion: nil)
        })
    }
    
    func makeTextFieldFadeInFadeOut(sender: UITextField) {
        sender.highlighted = false
        
        UIView.animateWithDuration(0.1,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseOut,
                                   animations: {sender.alpha = 0.0},
                                   completion:{(finished:Bool) -> Void in
                                    
                                    UIView.animateWithDuration(0.1,
                                        delay: 0.0,
                                        options: UIViewAnimationOptions.CurveEaseIn,
                                        animations: {sender.alpha = 1.0},
                                        completion: nil)
        })
    }
    
}