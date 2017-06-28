//
//  BRCell.swift
//  viBroadCast
//
//  Created by DatTran on 4/25/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//


import Foundation
import UIKit

class BRCell: BaseCell {
    
    
    let profile: UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(named: "toggle_off")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .ScaleAspectFit
        return img
        
    }()
    
    let toggleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.setImage(UIImage(named: "toggle_off"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let username: UITextField = {
        
        let textfield = UITextField()
        let str = NSAttributedString(string: "BROADCASTING...", attributes: [NSForegroundColorAttributeName:UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1)])
        textfield.attributedPlaceholder = str
        textfield.backgroundColor = UIColor.whiteColor()
        textfield.enabled = false
        textfield.textColor = UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1)
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 3.5
        textfield.layer.borderColor = UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1).CGColor
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        textfield.textAlignment = .Center
        return textfield
    }()
    
    let broadcastTitle: UILabel = {
        
        let label = UILabel()
        label.text = "BROADCADTING..."
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1)
        label.layer.masksToBounds = true
        label.layer.borderWidth = 3.5
        label.layer.borderColor = UIColor(red: 61/255, green: 167/255, blue: 244/255, alpha: 1).CGColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .Center
        
        return label
    }()
    
    let password: UITextField = {
        
        let textfield = UITextField()
        textfield.placeholder = "MAT KHAU"
        textfield.backgroundColor = UIColor.whiteColor()
        textfield.layer.cornerRadius = 10
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 2.5
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        textfield.textAlignment = .Center
        return textfield
    }()
    
    let login: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("DANG NHAP", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.redColor()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        
        return btn
    }()
    
    override func setupViews() {
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "ic_bg_broadcast")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(backgroundImage)

        
        addSubview(toggleButton)
        
        let W       = UIScreen.mainScreen().bounds.width
        let sizeW   = W / 2 + W / 3
        
        username.layer.cornerRadius = sizeW / 2
        addConstraintsWithFormat("H:[v0(\(sizeW))]", views: toggleButton)
        addConstraintsWithFormat("V:[v0(\(sizeW))]", views: toggleButton)
        
        addConstraint(NSLayoutConstraint(item: toggleButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: toggleButton, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        
    }
}