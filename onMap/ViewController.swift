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
    
    
    
    // WHAT DOES THIS DO?
    /*
    let completionHandler = { (status_code: Int?, error: NSError?) -> Void in
        if let err = error {
            print(err, terminator: "")
        } else {
            if status_code == 1 || status_code == 12 {
                // self.isFavorite = true
                print("success")
                dispatch_async(dispatch_get_main_queue()) {
                    //self.toggleFavoriteButton.tintColor = nil
                }
            } else {
                print("Unexpected status code \(status_code)", terminator: "")
            }
        }
    }

    */
    
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

