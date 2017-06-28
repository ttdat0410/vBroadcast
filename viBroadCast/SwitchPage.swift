//
//  SwitchPage.swift
//  viBroadCast
//
//  Created by DatTran on 4/26/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//

import Foundation
import UIKit

class SwitchPage: UIViewController {
    
    let sr: SR = SR()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = sr.ReadFromShareFre("deviceKey") as String
        
        dispatch_async(dispatch_get_main_queue()) {
            
        }
        
        if (key.characters.count > 5) {
            
            print ("FINE")
            let layout = UICollectionViewFlowLayout()
            let controller = BroadCastPage(collectionViewLayout: layout)
            self.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            
        } else {
            
            print ("FAIL")
        }
        
    }
    
}