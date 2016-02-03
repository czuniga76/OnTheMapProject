//
//  LoginViewController.swift
//  onMap
//
//  Created by Christian D. Zuniga on 2/2/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func loginUD(sender: UIButton) {
        
        let userDic: [String:AnyObject] = [
            "username": nameField.text!,
            "password": passwordField.text!
        ]
        let body : [String:AnyObject] = [
            "udacity": userDic
        ]
        
        let mutableMethod = "session"
        
        
        
        var parameters = [String: AnyObject] ()
        let task = onMapClient.sharedInstance().taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: body) { JSONResult, error in
            
            if let error = error {
                //self.completionHandler(nil, error)
                print("error")
            } else {
                print("success")
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ParseController") as! UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            }
        }

        
    }
}