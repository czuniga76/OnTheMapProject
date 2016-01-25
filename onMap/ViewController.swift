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

    @IBOutlet weak var mapView: MKMapView!
    
    //var studentRecord = StudentInformation()
    
    var studentRecords = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    var student: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        
        /*
        let Locations = hardCodedLocationData()
        
        for dictionary in Locations {
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            let record = StudentInformation(firstName: first,lastName: last,latitude: lat,longitude: long, mediaURL: mediaURL)
            studentRecords.append(record)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        
        }
        
        self.mapView.addAnnotations(annotations)
        */
        
    }

    override func viewWillAppear(animated: Bool) {
        
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
                //print(error, terminator: "")
            }

            
        }
    }
        
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

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            // pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            pinView!.rightCalloutAccessoryView = UIButton()
            
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
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // use to simulate downloaded data
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }

}

