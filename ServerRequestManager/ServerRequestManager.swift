//
//  ServerRequestManager.swift
//  ServerRequestManager
//
//  Created by Synergy on 27/03/18.
//  Copyright © 2018 Synergy.com.nl. All rights reserved.
//

import Foundation
import UIKit

enum ServerRequestConstants {
    
    enum  URLS{
        static let LOGIN_TEXT_RESPONSE = "http://students.doubleuchat.com/list.php";
        static let LOGIN_BINARY_RESPONSE = "http://students.doubleuchat.com/list_bin.php";
    }
    
    struct JSON {
        static let RESPONSE_ERROR = "error"
        static let RESPONSE_SUCCESS = "success"
        static let TAG_RESPONSE = "response"
        static let TAG_ACTION = "action"
        static let TAG_MESSAGE = "msg"
        
    }
    
}

class ServerRequestManager: NSObject {
    
   
    static let instance = ServerRequestManager()
    
    
    func postRequest(params : Dictionary<NSString, NSString>,  url : String, postCompleted: @escaping (_ response: String, _ msg: String, _ json: NSDictionary?) -> ()) {
       
        let paramsStr = createStringFromDictionary(dict: params)
        let paramsLength = "\(paramsStr.characters.count)"
        let requestBodyData = (paramsStr as NSString).data(using: String.Encoding.utf8.rawValue)
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        request.allowsCellularAccess = true
        request.httpBody = requestBodyData;
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(paramsLength, forHTTPHeaderField: "Content-Length")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response , error -> Void in
            
            print("data = \(data) \n")
            print("response = \(response)")
            print("error = \(error)\n")

            let json: NSDictionary?
            
            do {
                if(data != nil) {
                    print("data != nil")
                    json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                } else {
                    print("data == nil")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again later.", nil)
                    json = nil
                    return
                }
            } catch _ {
                print("suntem in catch!")
                json = nil
            }
            
            if(json == nil) {
                if let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print("Error could not parse JSON: '\(jsonStr)'")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again later.", nil)
                }

            }
            else {

                if let parseJSON = json {
                    let response: String = parseJSON[ServerRequestConstants.JSON.TAG_RESPONSE] as? String ?? ""
                    let message: String = parseJSON[ServerRequestConstants.JSON.TAG_MESSAGE] as? String ?? ""
                    
                    if let jsonArray = parseJSON["raspuns"] as? NSArray {
                        print("jsonArray = \(jsonArray)")
                        for item in jsonArray {
                            let itemDictionary = item as! NSDictionary
                            print("email = \(itemDictionary["email"]!)")
                            print("user = \(itemDictionary["user"]!) /n")

                        }
                        
                    }

                    postCompleted(response, message, parseJSON)
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON1: \(jsonStr)")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again later.", nil);
                }
            }
        })
        task.resume()
    }
    

    
    private func createStringFromDictionary(dict: Dictionary<NSString, NSString>) -> String {
        var params = String();
        for (key, value) in dict {
            params += "&" + (key as String) + "=" + (value as String);
        }
        return params;
    }
    
    func runOnMainQueue(work: @escaping @convention(block) () -> Swift.Void){
        if Thread.isMainThread{
            work()
        }else{
            DispatchQueue.main.async(execute: work)
        }
        
    }
    
 }


extension ServerRequestManager:NSURLConnectionDelegate {
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("URLConnection error = \(error)")
    }
}


