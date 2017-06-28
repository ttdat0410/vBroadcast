//
//  AppDelegate.swift
//  viBroadCast
//
//  Created by DatTran on 4/25/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//

import UIKit

enum ConnectState {
    case Connecting
    case ToBeConfigure
    case Connected
    case Disconnected
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    func doBackgroundTask() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.beginBackgroundUpdateTask()
            
            // Do something with the result.
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "displayAlert", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
            
            // End the background task.
            self.endBackgroundUpdateTask()
                        
        })
    }
    
    var co = 0
    func displayAlert() {
        print ("begin background")
        
        for i in 0...500 {
            print ("\(co++)")
        }
        let note = UILocalNotification()
        note.alertBody = "As a test I'm hoping this will run in the background every X number of seconds..."
        note.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(note)
        
    }
    
    
    
    var reload: NSTimer?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!
        ]

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        let sr: SR = SR()
        
        let key = sr.ReadFromShareFre("deviceKey")
        let type = sr.ReadFromShareFre("deviceType")
        
        if (key.characters.count > 5 && type.characters.count > 0) {
            
            window?.rootViewController = UINavigationController(rootViewController: BroadCastPage(collectionViewLayout: UICollectionViewFlowLayout()))
        } else {
            window?.rootViewController = LoginPage(collectionViewLayout: UICollectionViewFlowLayout())
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = "S-Detector đang chạy nền!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0.5)
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.category = "invite"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
//        self.doBackgroundTask()

        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

