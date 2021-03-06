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

class InfoPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var linkLabel: UITextField!
 
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
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
        
        activityWheel.hidden = false
        
        activityWheel.startAnimating()
        
        geo.geocodeAddressString(loc)  {
            ( placemarks, error) in
            if error != nil {
                self.activityWheel.stopAnimating()
                self.activityWheel.hidden = true
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
                self.activityWheel.stopAnimating()
                self.activityWheel.hidden = true
                
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
                
              
                var mapRegion = MKCoordinateRegion();
                
                mapRegion.center = annotation.coordinate;
                mapRegion.span.latitudeDelta = 0.2;
                mapRegion.span.longitudeDelta = 0.2;
                
               
                self.mapView.setRegion(mapRegion, animated: true)
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
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var errorMessage = "Posting Failed \n"
                        errorMessage = errorMessage + error.localizedDescription
                        
                        let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                        
                        let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        ac.addAction(acceptError)
                        self.presentViewController(ac, animated: true,completion: nil)
                        
                        
                    }
                    
                } else {
                    
                    
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
    
   
    @IBAction func dismissKeyBoard(sender: UITapGestureRecognizer) {
        locationTextView.resignFirstResponder()
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        submitButton.hidden = true
        submitButton.enabled = false
        linkLabel.hidden = true
        linkLabel.clearsOnBeginEditing = true
        
        activityWheel.hidden = true
        
        mapView.hidden = true
        
        view.backgroundColor = UIColor.blueColor()
        
        
    }
    
}