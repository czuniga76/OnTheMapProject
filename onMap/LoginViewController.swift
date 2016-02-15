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
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.orangeColor()
        
    }
    
    @IBAction func loginUD(sender: UIButton) {
        
        let userDic: [String:AnyObject] = [
            "username": nameField.text!,
            "password": passwordField.text!
        ]
        let body : [String:AnyObject] = [
            "udacity": userDic
        ]
        
       
        
        
        onMapClient.sharedInstance().authenticateThruUdacity(body) { JSONResult, error in
            
            if let error = error {
                
                print("error")
                //TODO insert alert with error
            } else {
                print("success")
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                    
                    controller.tabBar.items![0].title = "Map"
                    controller.tabBar.items![1].title = "List"
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            }

            
            
        }
        
        
        /*
        let parameters = [String: AnyObject] ()
        let urlString = "https://www.udacity.com/api/" + method + onMapClient.escapedParameters(parameters)
        
        let task = onMapClient.sharedInstance().taskForPOSTMethod(urlString, parameters: parameters, jsonBody: body) { JSONResult, error in
            
            if let error = error {
                //self.completionHandler(nil, error)
                print("error")
                //TODO insert alert with error
            } else {
                print("success")
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            }
        }

      */
    }

    
}