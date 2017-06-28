//
//  RestAPI.swift
//  viBroadCast
//
//  Created by DatTran on 5/15/29 H.
//  Copyright © 29 Heisei ANSV. All rights reserved.
//

import Foundation
import UIKit

class RestAPI : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var connection      : NSURLConnection = NSURLConnection()
    
    var responseData    : NSMutableData = NSMutableData()
    
    var requestDic      = [String : NSObject]()
    
    var activity_indicator_count :Int = 0
    
    class var sharedInstance: RestAPI {
        struct Singleton {
            static let instance = RestAPI()
        }
        
        return Singleton.instance
    }
    
    func doGet(url: String, callback:((response: NSData?) -> Void)) {
        
        
        showNetworkActivity()
        
        let sr          : SR     = SR()
        let api_key     : String = sr.ReadFromShareFre("API_KEY")
        let session     = NSURLSession.sharedSession()
        
        let urlPath     = NSURL (string: url)
        
        let request     = NSMutableURLRequest(URL: urlPath!)
        var timeout     = 60.0
        
        request.timeoutInterval = timeout
        request.cachePolicy     = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        request.HTTPMethod = "GET"
        
        let dataTask = session.dataTaskWithRequest(request) {
            
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                timeout -= 0.1
                if (timeout < 0) {
                    debugPrint("timeout")
                }
                callback(response: nil)
                
            } else {
                
                //                  let s = String(data: data!, encoding: NSUTF8StringEncoding)
                //                let _: NSError
                //
                // MAIN THREAD
                dispatch_async(dispatch_get_main_queue(), {
                    callback(response: data!)
                })
            }
            
        }
        dataTask.resume()
    }
    
    func doPost(url:String, data:[String: AnyObject], callback: ((response: NSData?) -> Void)){
        
        let sr      : SR     = SR()
        let api_key : String = sr.ReadFromShareFre("API_KEY")
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            data ,
            options: NSJSONWritingOptions())
        
        let jsonString = NSString(data: theJSONData!,
                                  encoding: NSASCIIStringEncoding)
        
        print("Request string = \(jsonString!)")
        
        let session = NSURLSession.sharedSession()
        
        let urlPath = NSURL(string: url)
        
        let request = NSMutableURLRequest(URL: urlPath!)
        
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type") // fix loi
        
        request.HTTPMethod = "POST"
        
        request.HTTPBody = jsonString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            
            if((error) != nil) {
                
                callback(response: nil)
                
            }else {
                
                //                let s = String(data: data!, encoding: NSUTF8StringEncoding)
                //                let _: NSError
                //
                //                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                callback(response: data!)
                
                //                print (s!)
            }
        }
        dataTask.resume()
    }
    // POST 2
    
    func doPost2(url:String, data: String, callback: ((response: NSData?) -> Void)){
        
        let sr      : SR     = SR()
        let api_key : String = sr.ReadFromShareFre("API_KEY")
        
        //        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
        //            data ,
        //            options: NSJSONWritingOptions())
        
        //        let jsonString = NSString(data: theJSONData!,
        //                                  encoding: NSASCIIStringEncoding)
        
        //        print("Request string = \(jsonString!)")
        
        let session = NSURLSession.sharedSession()
        
        let urlPath = NSURL(string: url)
        
        let request = NSMutableURLRequest(URL: urlPath!)
        
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type") // fix loi
        
        request.HTTPMethod = "POST"
        
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            
            if((error) != nil) {
                
                callback(response: nil)
                
            }else {
                
                let s = String(data: data!, encoding: NSUTF8StringEncoding)
                //                let _: NSError
                //
                //                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                callback(response: data!)
                
                print (s!)
            }
        }
        dataTask.resume()
    }
    
    
    
    
    func doPut(url:String, data:[String: AnyObject], callback: ((response: NSData?) -> Void)){
        
        let sr      : SR     = SR()
        let api_key : String = sr.ReadFromShareFre("API_KEY")
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            data ,
            options: NSJSONWritingOptions(rawValue: 2))
        
        let jsonString = NSString(data: theJSONData!,
                                  encoding: NSASCIIStringEncoding)
        
        print("Request string = \(jsonString!)")
        let session = NSURLSession.sharedSession()
        
        let urlPath = NSURL(string: url)
        
        let request = NSMutableURLRequest(URL: urlPath!)
        request.timeoutInterval = 60
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        
        request.HTTPMethod = "PUT"
        
        request.HTTPBody = jsonString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            //            self.hideNetworkActivity()
            
            if((error) != nil) {
                
                callback(response: nil)
                
            }else {
                
                let s = String(data: data!, encoding: NSUTF8StringEncoding)
                //                let _: NSError
                //
                //                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                callback(response: data!)
                
                print (s!)
            }
        }
        dataTask.resume()
    }
    
    func makeHTTPPostRequest(path: String, body: [String: AnyObject]) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let sr          : SR     = SR()
        let api_key     : String = sr.ReadFromShareFre("API_KEY")
        
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    //let json:JSON = JSON(data: jsonData)
                    //onCompletion(jsonData, nil)
                    let s = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    print (s)
                } else {
                    //onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            //onCompletion(nil, nil)
        }
    }
    func doDelete (url: String, callback: ((response: NSData?) -> Void)) {
        
        showNetworkActivity()
        
        let sr          : SR     = SR()
        let api_key     : String = sr.ReadFromShareFre("API_KEY")
        let session     = NSURLSession.sharedSession()
        
        let urlPath     = NSURL (string: url)
        
        let request     = NSMutableURLRequest(URL: urlPath!)
        var timeout     = 60.0
        
        request.timeoutInterval = timeout
        request.cachePolicy     = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(api_key, forHTTPHeaderField: "API_KEY")
        request.HTTPMethod = "DELETE"
        
        let dataTask = session.dataTaskWithRequest(request) {
            
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                timeout -= 0.1
                if (timeout < 0) {
                    debugPrint("timeout")
                }
                callback(response: nil)
                
            } else {
                
                let s = String(data: data!, encoding: NSUTF8StringEncoding)
                //                let _: NSError
                //
                //                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                print ("RECEIVED: \(s!)")
                
                // MAIN THREAD
                dispatch_async(dispatch_get_main_queue(), {
                    callback(response: data!)
                })
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
    
    //Method For Https Certification Approve
    func connection(connection: NSURLConnection,
                    willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge){
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == "YOUR_ADDRESS" {
            let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            challenge.sender!.useCredential(credential, forAuthenticationChallenge: challenge)
        } else {
            challenge.sender?.performDefaultHandlingForAuthenticationChallenge!(challenge)
        }
    }
    
    
    func showNetworkActivity(){
        activity_indicator_count += 1
        if (activity_indicator_count > 0) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    func hideNetworkActivity(){
        activity_indicator_count -= 1;
        if(activity_indicator_count < 1){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}