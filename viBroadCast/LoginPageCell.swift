//
//  LoginPageCell.swift
//  viBroadCast
//
//  Created by DatTran on 5/15/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//


import Foundation
import UIKit


class LoginPageCell: BaseCell {
    
    let profile : UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .ScaleAspectFill
        return image
        
    }()
    
    let username : TintTextField = {
        
        let textField = TintTextField()
        textField.placeholder = "Tên đăng nhập"
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        textField.textAlignment = .Left
        
        return textField
        
    }()
    
    let password : TintTextField = {
        
        let textField = TintTextField()
        textField.placeholder = "Mật khẩu"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.secureTextEntry = true
//        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        textField.textAlignment = .Left
        
        return textField
        
    }()
    
    let lineDivider : UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    let remember : CheckboxButton = {
        let check = CheckboxButton()
        check.selected = false
        check.checkLineColor = UIColor.redColor()
        check.boxLineColor = UIColor.grayColor()
        check.boxLineWidth = 2.0
        check.checkLineWidth = 4.0
        check.layer.cornerRadius = 5
        check.layer.masksToBounds = true
        
        return check
    }()
    
    let rememberText: UILabel = {
        
        let label = UILabel()
        label.text = "Ghi nhớ đăng nhập!"
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
//    lazy var loginRegisterButton: UIButton = {
//        let button = UIButton(type: .System)
//        button.backgroundColor = UIColor.orangeColor()
//        button.setTitle("ĐĂNG NHẬP", forState: .Normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
//        
//        //button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
//        
//        return button
//    }()
    let login : UIButton = {
        
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle("ĐĂNG NHẬP", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        return button
    }()
    
    let version : UILabel = {
        
        let label = UILabel()
        label.text = "ANSV"
        label.textColor = UIColor.redColor()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textAlignment = .Center
        
        return label
        
    }()
    
    override func setupViews() {
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "ic_bg_login")
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(backgroundImage)
        addSubview(profile)
        addSubview(username)
        addSubview(password)
        addSubview(remember)
        addSubview(rememberText)
        addSubview(login)
        addSubview(version)
        
        addConstraintsWithFormat("H:|-50-[v0]-50-|", views: profile)
        addConstraintsWithFormat("H:|-15-[v0]-15-|", views: username)
        addConstraintsWithFormat("H:|-15-[v0]-15-|", views: password)
        addConstraintsWithFormat("H:|-35-[v0]", views: remember)
        addConstraintsWithFormat("H:|-15-[v0]-15-|", views: login)
        addConstraintsWithFormat("V:[v0(30)]-55-[v1(45)]-5-[v2(45)]-7-[v3(25)]-10-[v4(45)]", views: profile, username, password, remember ,login)
        
        addConstraintsWithFormat("H:|-30-[v0]-30-|", views: version)
        addConstraintsWithFormat("V:[v0]-10-|", views: version)
        
        addConstraint(NSLayoutConstraint(item: password, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: rememberText, attribute: .Left, relatedBy: .Equal, toItem: remember, attribute: .Right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: rememberText, attribute: .CenterY, relatedBy: .Equal, toItem: remember, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rememberText, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 19))
    }
}

