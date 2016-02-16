//
//  ViewController.swift
//  onMap
//
//  Created by Christian D. Zuniga on 1/3/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    @IBAction func reloadData(sender: UIBarButtonItem) {
        getStudentLocations()
    }

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logoutSession(sender: UIBarButtonItem) {
        
        onMapClient.sharedInstance().logoutUdacity() {
            (error: NSError?) in
            
            if let error = error {
               
                
                dispatch_async(dispatch_get_main_queue()) {
                    var errorMessage = "Logout Failed \n"
                    errorMessage = errorMessage + error.localizedDescription
                    
                    
                    let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                    
                    let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    ac.addAction(acceptError)
                    self.presentViewController(ac, animated: true,completion: nil)
                    
                    
                }

            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
        }
                
    }
    
    var annotations = [MKPointAnnotation]()
    var student: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getStudentLocations()
        
      
    }

    // downloads student locations from Parse. Uses convenience metho in onMapClient. Updates map with annotations
    func getStudentLocations() {
        onMapClient.sharedInstance().getParseLocationData { students, error in
            if let students  = students {
               
                
                for student in students  {
                    let annotation = MKPointAnnotation()
                   
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
                    
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.firstName) \(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    self.annotations.append(annotation)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    // update display
                    self.mapView.addAnnotations(self.annotations)
                    
                }
            }else {
                
            }
            
            
        }
        
    }
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            // pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            } else {
                let errorMessage = "Invalid URL"
                
                let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
                
                let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
                ac.addAction(acceptError)
                self.presentViewController(ac, animated: true,completion: nil)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

