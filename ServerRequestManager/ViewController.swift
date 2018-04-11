//
//  ViewController.swift
//  ServerRequestManager
//
//  Created by Synergy on 27/03/18.
//  Copyright © 2018 Synergy.com.nl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    private func login() {
        
        var params = Dictionary<String, String>();
        
        params["request"] = "request"
        params["tablename"] = "user"
        params["test"] = "test"
        
        print("Login params: \(params)")
        
        ServerRequestManager.instance.postRequest(params: params as Dictionary<NSString, NSString>, url: ServerRequestConstants.URLS.LOGIN_BINARY_RESPONSE, postCompleted: { (response, msg, json) -> () in
            if  response != ""  {
                if(response == ServerRequestConstants.JSON.RESPONSE_ERROR) {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        DispatchQueue.main.async {
                            
                            AlertManager.showGenericDialog(msg, viewController: self)
                        }
                    }
                } else if(response == ServerRequestConstants.JSON.RESPONSE_SUCCESS) {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        DispatchQueue.main.async {
                            //TO-DO: prelucrare JSON
                            print("JSON = \(json!)")
                        }
                    }
                }
            } else {
                AlertManager.showGenericDialog("response from server undefined!!!", viewController: self)

            }
        })
        
    }
    
    
    
}

