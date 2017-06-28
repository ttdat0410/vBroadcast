//
//  SR.swift
//  viBroadCast
//
//  Created by DatTran on 5/15/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//


import Foundation
import UIKit


class SR {
    
    func SaveToShareFre (key: String, value: String) {
        
        let preferences     = NSUserDefaults.standardUserDefaults()
        
        let key             = key
        
        let content_key     = value
        
        preferences.setObject(content_key, forKey: key)
        
        let didSave = preferences.synchronize()
        
        if !didSave {
            debugPrint("Couldn't save!")
        }
        
    }
    
    func ReadFromShareFre (forKey: String) -> String {
        
        var output          : String = ""
        
        let preferences     = NSUserDefaults.standardUserDefaults()
        
        let getKey          = "\(forKey)"
        
        if preferences.objectForKey(getKey) == nil {
            debugPrint("Don't exits key")
            
        } else {
            
            output = preferences.objectForKey(getKey) as! String
            debugPrint("\(forKey): \(output)")
            
        }
        
        return output
        
    }
    
}