//
//  BroadCastPage.swift
//  viBroadCast
//
//  Created by DatTran on 4/25/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//

import AVFoundation
import UIKit
import CoreBluetooth

class BroadCastPage: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate {
    
    let login_cell = "broadcast_cell"
    
    var timer = NSTimer()
    var backgroundTask = BackgroundTask()
    
    var reload: NSTimer?
    var player = AVAudioPlayer()
    
    // DETECTOR
    var bluetoothServices:CBMutableService?
    var nameCharacteristic:CBMutableCharacteristic?
    var peripheralManager:CBPeripheralManager?
    
    var peripheralServiceUUID = CBUUID(string: "04107777-F4CB-0410-BD38-7375CD0DD777")
    
    // --
    
    // FORMAT: <pin>S<key>
    override func viewDidLoad() {
        
        let image = UIImage(named: "ic_title_40")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        collectionView?.alwaysBounceVertical = false
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(BRCell.self, forCellWithReuseIdentifier: login_cell)
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        bluetoothServices = CBMutableService(type: peripheralServiceUUID, primary: true)
        peripheralManager?.addService(bluetoothServices!)
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)

        
    }
    
    func appMovedToBackground() {
        print ("background mode")
        
//        self.doBackgroundTask()
        
    }
    
    var isToggle: Bool = false
    
    func handleToggle(sender: UIButton) {
        
        isToggle = !isToggle
        
        if (isToggle && stateBLE == "ON") {
            
            sender.setImage(UIImage(named: "toggle_on"), forState: .Normal)
            
            let sr: SR = SR()
            
            let content = "dS\(sr.ReadFromShareFre("deviceKey"))"
            
            let manufacturerData = content.dataUsingEncoding(
                NSUTF8StringEncoding,
                allowLossyConversion: false)
            
            let serviceUUID = CBUUID(string: "04100410-F4CB-0410-BD38-7375CD0DD777")

            
            let uuid = NSUUID()

            _ = CBUUID(NSUUID: uuid)

            var byteArray = [UInt8]()
            byteArray.append(0b11011110);
            
            _ = NSData(bytes: byteArray,length: byteArray.count)
            
            let dataToBeAdvertised:[String: AnyObject!] = [
                CBAdvertisementDataLocalNameKey             : "dS\(sr.ReadFromShareFre("deviceKey"))",
//                CBAdvertisementDataServiceDataKey           : [serviceUUID],
                CBAdvertisementDataOverflowServiceUUIDsKey  : [serviceUUID],
                CBAdvertisementDataManufacturerDataKey      : manufacturerData!]
            
            self.peripheralManager?.startAdvertising(dataToBeAdvertised)
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)


        } else if (!isToggle && stateBLE == "ON"){
            
            sender.setImage(UIImage(named: "toggle_off"), forState: .Normal)
            if ((peripheralManager?.isAdvertising) != nil) {
                peripheralManager?.stopAdvertising()
            }
            
            
        } else if (stateBLE == "OFF") {
            
            if ((peripheralManager?.isAdvertising) != nil) {
                peripheralManager?.stopAdvertising()
            }
            
            sender.setImage(UIImage(named: "toggle_off"), forState: .Normal)

            let alert = UIAlertController(title: "Bluetooth is powered off",
                                          message: "Please turn on your bluetooth in Settings or Control Center to continue",
                                          preferredStyle: .Alert);
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);

            
        } else if (stateBLE == "UNSUPPORT") {
            
            sender.setImage(UIImage(named: "toggle_off"), forState: .Normal)

            let alert = UIAlertController(title: "Bluetooth is not supported", message: "Please find another phone and try again.", preferredStyle: .Alert);
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        let reset = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(BroadCastPage.handleReset))
        
        self.navigationItem.rightBarButtonItems = [reset]
    }
    
    func handleReset() {
        
        let sr: SR = SR()
        
        let alertController = UIAlertController(title: "Đặt lại Key?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let handleOK = UIAlertAction(title: "Đồng ý", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            sr.SaveToShareFre("deviceType", value: "")
            sr.SaveToShareFre("deviceKey", value: "")
            exit(0)
            
        })
        
        let handleCancle = UIAlertAction(title: "Huỷ bỏ", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(handleOK)
        alertController.addAction(handleCancle)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: BRCell = collectionView.dequeueReusableCellWithReuseIdentifier(login_cell, forIndexPath: indexPath) as! BRCell
        
        cell.toggleButton.addTarget(self, action: #selector(handleToggle), forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.frame.width, view.frame.height)
    }
    
    // BROAD_CAST
    var stateBLE: String = ""
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        switch (peripheral.state) {
            
        case .PoweredOn:
            print("Current Bluetooth State:  PoweredOn")
            stateBLE = "ON"
            publishServices(bluetoothServices)
            
            break;
        case .PoweredOff:
            print("Current Bluetooth State:  PoweredOff")
            stateBLE = "OFF"

            if ((peripheralManager?.isAdvertising) != nil) {
//                removeService(bluetoothServices)
//                let sr: SR = SR()
                
            }
            break;
        case .Resetting:
            print("Current Bluetooth State:  Resetting")
            break;
        case .Unauthorized:
            print("Current Bluetooth State:  Unauthorized")
        case .Unknown:
            print("Current Bluetooth State:  Unknown")
            break;
        case .Unsupported:
            stateBLE = "UNSUPPORT"

            print("Current Bluetooth State:  Unsupported")
            break;
            
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
        if (error != nil) {
            
        } else {
            
//            let sr: SR = SR()
//            
//            peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey : "S\(sr.ReadFromShareFre("deviceKey"))"])
            
        }
    }
    
    func publishServices(newService: CBMutableService!) {
        peripheralManager?.addService(newService)
    }
    
    func removeService(newService: CBMutableService!) {
        peripheralManager?.removeService(newService)
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager,
                                              error: NSError?) {
        if (error != nil) {
            print("peripheralManagerDidStartAdvertising encountered an error.")
            print(error!.localizedDescription)      // Error: One or more parameters were invalid
            print(error!.localizedFailureReason)    // Error: nil
        }
        print ("Debug: peripheralManagerDidStartAdvertising()")
    }

    // BACKGROUND TASK
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            
            print ("stop")
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
        
        print ("end")
    }
    var tim : NSTimer?
    
    func doBackgroundTask() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.beginBackgroundUpdateTask()
            
            // Do something with the result.
            self.tim = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(BroadCastPage.handleBG), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.tim!, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
            
            // End the background task.
            self.endBackgroundUpdateTask()
            
        })
    }
    
    var fBroad = false
    
    func handleBG() {
        
        fBroad = !fBroad
        
        if (fBroad) {
            
            if ((peripheralManager?.isAdvertising) != nil) {
                
                peripheralManager?.stopAdvertising()
                
                let sr: SR = SR()
                
                let content = "dS\(sr.ReadFromShareFre("deviceKey"))"
                
                let manufacturerData = content.dataUsingEncoding(
                    NSUTF8StringEncoding,
                    allowLossyConversion: false)
                
                let serviceUUID = CBUUID(string: "04100410-F4CB-0410-BD38-7375CD0DD777")
                
                
                let uuid = NSUUID()
                
                _ = CBUUID(NSUUID: uuid)
                
                var byteArray = [UInt8]()
                byteArray.append(0b11011110);
                
                _ = NSData(bytes: byteArray,length: byteArray.count)
                
                let dataToBeAdvertised:[String: AnyObject!] = [
                    CBAdvertisementDataLocalNameKey             : "dS\(sr.ReadFromShareFre("deviceKey"))",
                    //                CBAdvertisementDataServiceDataKey           : [serviceUUID],
                    CBAdvertisementDataOverflowServiceUUIDsKey  : [serviceUUID],
                    CBAdvertisementDataManufacturerDataKey      : manufacturerData!]
                
                self.peripheralManager?.startAdvertising(dataToBeAdvertised)
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            }
        
        } else {
            
            if(peripheralManager?.isAdvertising != nil) {
                
                peripheralManager?.stopAdvertising()
            }
            
        }
        
        print ("in BG \(timerAction())")
        
    }
    
    func timerAction() -> String {
                let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        
        return ("\(hour):\(minutes) \(seconds)")
    }
    
}