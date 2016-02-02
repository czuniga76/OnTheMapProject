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
    
    
    @IBAction func loginUD(sender: UIButton) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ParseController") as! UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}