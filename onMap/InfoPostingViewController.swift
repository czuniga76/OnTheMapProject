//
//  InfoPostingViewController.swift
//  onMap
//
//  Created by Christian D. Zuniga on 2/10/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InfoPostingViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var linkLabel: UITextField!
 
    @IBOutlet weak var locationTextView: UITextView!
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
   
    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var jsonDic: [String: AnyObject] = ["uniqueKey": "christian.zuniga@hotmail.com",
        "firstName":"Christian",
        "lastName": "Zuniga"]
    
    @IBAction func findOnMap(sender: UIButton) {
    
        let loc = locationTextView.text!
        
        
        
        let geo = CLGeocoder()
        let annotation = MKPointAnnotation()
        
        
        geo.geocodeAddressString(loc)  {
            ( placemarks, error) in
            if error != nil {
                var errorMessage = ""
                if error?.code == 8 {
                    errorMessage =  errorMessage + "Invalid Location"
                }
                if error?.code == 2 {
                    errorMessage = errorMessage + "No network connection"
                }
                
                let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                
                let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                ac.addAction(acceptError)
                self.presentViewController(ac, animated: true,completion: nil)
                
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                annotation.coordinate = location!.coordinate
                annotation.title = "Christian Zuniga"
                self.mapView.hidden = false
                self.locationTextView.hidden = true
                self.linkLabel.hidden = false
                self.queryLabel.hidden = true
                self.findButton.hidden = true
                
                self.mapView.addAnnotation(annotation)
                self.submitButton.enabled = true
                self.submitButton.hidden = false
                self.jsonDic["latitude"] = annotation.coordinate.latitude
                self.jsonDic["longitude"] = annotation.coordinate.longitude
                self.jsonDic["mapString"] = loc
                
            }
            
            
            
            
        }
        
    }

    
    
    @IBAction func submitLocation(sender: UIButton) {
   
        let link = linkLabel!.text
        
        if link!.characters.count  > 0 {
            jsonDic["mediaURL"] = link
            
            onMapClient.sharedInstance().postStudentInformation(jsonDic) {
                JSONResult, error in
                
                if let error = error {
                    //print("error")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var errorMessage = "Failed with code"
                        errorMessage = errorMessage + error.code.description
                        
                        let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                        
                        let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        ac.addAction(acceptError)
                        self.presentViewController(ac, animated: true,completion: nil)
                        
                        
                    }
                    
                } else {
                    print("succes in posting to parse")
                    print(JSONResult)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
            }
            
        } else {
            let ac = UIAlertController(title: "", message: "Please write link", preferredStyle: .Alert)
            
            let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
            ac.addAction(acceptError)
            self.presentViewController(ac, animated: true,completion: nil)
            
            
        }
    
    
    }
    
    @IBAction func cancelPosting(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion:nil)
        
    }
    
   
    
    
    override func viewDidLoad() {
        submitButton.hidden = true
        submitButton.enabled = false
        linkLabel.hidden = true
        
        
        mapView.hidden = true
        
        view.backgroundColor = UIColor.blueColor()
        
        
    }
    
}