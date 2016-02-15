//
//  LoginViewController.swift
//  onMap
//
//  Created by Christian D. Zuniga on 2/2/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func signUp(sender: UIButton) {
        
        if let url = NSURL(string: "https://www.udacity.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.orangeColor()
        nameField.clearsOnBeginEditing = true
        passwordField.clearsOnBeginEditing = true
        
    }
    
    @IBAction func loginUD(sender: UIButton) {
        
        let userDic: [String:AnyObject] = [
            "username": nameField.text!,
            "password": passwordField.text!
        ]
        let body : [String:AnyObject] = [
            "udacity": userDic
        ]
        
       
        
        // use convenience method in onMapClient
        
        onMapClient.sharedInstance().authenticateThruUdacity(body) { JSONResult, error in
            
            if let error = error {
                
                                
                dispatch_async(dispatch_get_main_queue()) {
                    var errorMessage = "Login Failed \n"
                    errorMessage = errorMessage + error.localizedDescription
                    
                    
                    let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                    
                    let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    ac.addAction(acceptError)
                    self.presentViewController(ac, animated: true,completion: nil)
                    
                    
                }
                
            } else {
                // authentication through Udacity succeeded. Load MapView
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                    
                    controller.tabBar.items![0].title = "Map"
                    controller.tabBar.items![1].title = "List"
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            }

            
            
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
}