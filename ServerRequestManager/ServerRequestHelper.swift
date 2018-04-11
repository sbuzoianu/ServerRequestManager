//
//  ServerRequestHelper.swift
//  ServerRequestManager
//
//  Created by Synergy on 11/04/18.
//  Copyright © 2018 Synergy.com.nl. All rights reserved.
//

import Foundation
import UIKit

class ServerRequestHelper:NSObject {
    
    func createGradientLayer(start startColor:UIColor, final finalColor: UIColor, viewController: UIViewController) {
        
        let gradient = CAGradientLayer()
        gradient.frame = viewController.view.bounds
        gradient.colors = [startColor.cgColor, finalColor.cgColor]
        
        viewController.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func isEmail(_ currentString:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: currentString, options: [], range: NSMakeRange(0, currentString.characters.count)) != nil
        } catch { return false }
    }

    
}
