//
//  LoginPage.swift
//  viBroadCast
//
//  Created by DatTran on 5/15/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//


import Foundation
import UIKit
import SwiftyJSON
import PKHUD


class LoginPage: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    struct passData {
        
        private let stationId: Int?
        
    }
    
    private var _restApi: RestAPI!
    
    private var reload: NSTimer?
    
    private let login_cell = "login_cell"
    
    private var sr: SR?
    
    private var hud: PKHUD = PKHUD.sharedHUD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.dimsBackground = false
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(LoginPageCell.self, forCellWithReuseIdentifier: login_cell)
        
        sr = SR()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self._restApi = RestAPI.sharedInstance
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginPage.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginPage.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        let blackView = view
        
        if let window = UIApplication.sharedApplication().keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardDidHide)))
            
            window.addSubview(blackView)
            
        }
        
        let cell = collectionView?.cellForItemAtIndexPath(indexRow!) as! LoginPageCell
        
        cell.password.text = ""
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
        
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    var indexRow: NSIndexPath?
    var myBOOL: Bool = false
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        indexRow = indexPath
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(login_cell, forIndexPath: indexPath) as! LoginPageCell
        
        cell.username.text = sr?.ReadFromShareFre("USERNAME")
        
        setUpDatePicker(cell.username, pass: cell.password)
        
        let isCheck = sr?.ReadFromShareFre("IS_CHECK")
        
        if (isCheck == "1") {
            cell.remember.boxLineColor = UIColor(r: 80, g: 220, b: 180)
            cell.remember.selected = true
            cell.remember.boxLineWidth = 4.0

            
        } else if (isCheck == "0"){
            cell.remember.boxLineColor = UIColor.grayColor()
            cell.remember.selected = false
            
        }
        
        cell.remember.addTarget(self, action: #selector(handleRememberInfo), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.login.addTarget(self, action: #selector(handleLogin), forControlEvents: .TouchUpInside)
        
        
        return cell
    }
    
    // HANDLE
    func handleRememberInfo(sender : CheckboxButton) {
        
        let flag = !sender.selected
        
        sender.selected = flag
        
        let cell = collectionView?.cellForItemAtIndexPath(indexRow!) as? LoginPageCell
        
        if (flag) {
            sender.boxLineColor = UIColor(r: 80, g: 220, b: 180)
            sender.boxLineWidth = 4.0
            
            sr?.SaveToShareFre("USERNAME", value: (cell?.username.text)!)
            sr?.SaveToShareFre("IS_CHECK", value: "1")
            
        } else {
            sender.boxLineColor = UIColor.grayColor()
            sender.boxLineWidth = 2.0
            
            sr?.SaveToShareFre("USERNAME", value: "")
            sr?.SaveToShareFre("IS_CHECK", value: "0")
            
        }
    }
    
    func handleLogin (sender: UIButton) {
        
        //reload = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LoginPage.handleReload), userInfo: nil, repeats: true)
        
        FadeInFadeOut().makeButtonFadeInFadeOut(sender)
        handleReload()
        
    }
    
    func handleReload () {
        
        let cell = collectionView?.cellForItemAtIndexPath(indexRow!) as? LoginPageCell
        
        let user: String = (cell?.username.text)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) // DELETE ALL WHITESPACE
        let pass: String = (cell?.password.text)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let url: String = "\(Config().URL)/device/getDeviceKey?username=\(user)&password=\(pass.sha1())"
        
        print (url)
        dispatch_async(dispatch_get_main_queue()) {
            
            if (user.characters.count <= 0) {
                self.reload?.invalidate()
                self.hud.contentView = PKHUDTextView(text: "Tên đăng nhập không được để trống!")
                self.hud.show()
                self.hud.hide(afterDelay: 1.5)
                
                //self.view.makeToast("Ten dang nhap khong duoc de trong", duration: 1.5, position: .Top)
                
            } else if (pass.characters.count <= 0) {
                
                self.reload?.invalidate()
                self.hud.contentView = PKHUDTextView(text: "Mật khẩu không được để trống!")
                self.hud.show()
                self.hud.hide(afterDelay: 1.5)
                //self.view.makeToast("Mat khau khong duoc de trong", duration: 1.5, position: .Top)
                
            } else {
                
                self.hud.contentView = PKHUDProgressView()
                self.hud.show()
                
                self._restApi.doGet(url) { (response) in
                    
                    if response != nil {
                        
                        self.handleResponse(response!)
                        
                    } else {
                        
                        self.reload?.invalidate()
                        dispatch_async(dispatch_get_main_queue(), {
                            if (self.hud.isVisible) {
                                self.hud.hide()
                            }
                            
                            self.hud.contentView = PKHUDTextView(text: "Lỗi kết nối mạng, vui lòng kiểm tra kết nối mạng!")
                            self.hud.show()
                            self.hud.hide(afterDelay: 3.5)
                        })
                    }
                }
            }
        }
        
    }
    
    
    var loadCount = 0
    var timeOut = 5
    func handleResponse (response : NSData) {
        
        let json = JSON(data: response)
        
        let statusCode: Int = json["status"]["statusCode"].intValue
        
        if (statusCode == StatusCode().SUCCESS) {
            
            print ("Dang nhap thanh cong!")
            
            let deviceType = json["data"]["deviceType"].stringValue
            sr!.SaveToShareFre("deviceType", value: deviceType)
            
            let deviceKey = json["data"]["deviceKey"].stringValue
            
            sr!.SaveToShareFre("deviceKey", value: deviceKey)
            
            // phai them vao main thread
            dispatch_async(dispatch_get_main_queue(),{
                
                if (self.hud.isVisible) {
                    self.hud.hide()
                }
                self.hud.contentView = PKHUDSuccessView()
                self.hud.show()
                self.hud.hide(afterDelay: 1.5)
                
                self.presentViewController(UINavigationController(rootViewController: BroadCastPage(collectionViewLayout: UICollectionViewFlowLayout())), animated: true, completion: nil)
                
            })
            //            self.navigationController?.pushViewController(AllStation(), animated: true)
            
            
        } else if (statusCode == StatusCode().USER_OR_PASSWORD_INCORRECT) {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.reload?.invalidate()
                if (self.hud.isVisible) {
                    
                    self.hud.hide()
                    
                }
                
                self.hud.contentView = PKHUDTextView(text: "Tên đăng nhập hoặc mật khẩu không đúng!")
                self.hud.show()
                self.hud.hide(afterDelay: 1.5)
                
            })
            
        } else {
            
            debugPrint("WTH?")
        }
        // CASE: SERVER BI NGAT KET NOI
        // CASE: INTERNET BI NGAT
        // REQUEST LIEN TUC, KHI NAO CO DATA THI NGUNG QUET
    }
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -90, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: { (completed) in
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
                
                
        })
        
        self.view.endEditing(true)
        
    }
    
    func setUpDatePicker (user: UITextField, pass: UITextField) {
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        
        
        //        let todayBtn = UIBarButtonItem(title: "Hôm nay", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChartController.tappedToolBarBtn))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(LoginPage.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Nhập thông tin"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([textBtn,flexSpace,okBarBtn], animated: true)
        
        user.inputAccessoryView = toolBar
        pass.inputAccessoryView = toolBar
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        self.view.endEditing(true)
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        let cell = collectionView?.cellForItemAtIndexPath(indexRow!) as? LoginPageCell
        cell!.username.resignFirstResponder()
        cell!.password.resignFirstResponder()
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height)
    }
    
}
