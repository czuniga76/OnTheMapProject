//
//  OnMapConvenience.swift
//  onMap
//
//  Created by Christian D. Zuniga on 1/24/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension onMapClient {
    
    
    
    func getParseLocationData(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        
        
        let mutableMethod = "session"
        let url = "https://api.parse.com/1/classes/StudentLocation?limit=100"
        let headerDic = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr" ,
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]
        
        let parameters = [String: AnyObject] ()
                
        taskForGETMethod(mutableMethod , baseURL: url, headers: headerDic, parameters: parameters) { JSONResult, error in
           
            
            if let error = error {
                completionHandler(result:nil, error: error)
                
            } else {
                
                let studentLocations = (JSONResult["results"] as! NSArray) as Array
                
                for  dictionary in studentLocations {
                    
                    
                    
                    
                    
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    
                    
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
                    
                    
                    let dateString = dictionary["updatedAt"] as! String
                    var updated = NSDate()
                    
                    if let date = dateFormatter.dateFromString(dateString)
                    {
                        updated = date
                    
                        
                    }
                    
                    let studentDic : [String:AnyObject] = ["firstName":first,
                                    "lastName": last,
                                    "latitude": lat,
                                    "longitude": long,
                                    "mediaURL": mediaURL,
                                    "updatedLast": updated]
                    
                    let student = StudentInformation(dictionary: studentDic)
                    
                    //let student = StudentInformation(firstName: first,lastName: last, latitude: lat, longitude: long, mediaURL: mediaURL,updatedLast: updated)
                    
                
                    
                   
                    
                    onMapClient.sharedInstance().studentRecords.append(student)
                }
                
                // sort by most recent (found in stackoverflow questions)
                
                onMapClient.sharedInstance().studentRecords.sortInPlace({$0.updatedLast.compare($1.updatedLast) == .OrderedDescending })
                
                completionHandler(result: onMapClient.sharedInstance().studentRecords, error:nil)
                
                
            }
        }
        
        
        
    }

    func postStudentInformation(infoDic: [String:AnyObject], completionHandler:(result: AnyObject!, error: NSError?) -> Void ) {
        
        let url = "https://api.parse.com/1/classes/StudentLocation"
        
        let headerDic = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr" ,
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type":"application/json"]
        
       
        
         onMapClient.sharedInstance().taskForPOSTMethod(url, headers: headerDic, jsonBody: infoDic, offset: 0) { JSONResult, error in
            
            if let error = error {
                
                completionHandler(result: nil, error: error)

                
            } else {
                
                completionHandler(result: JSONResult, error: error)
            }
        }
        
    }
    
    ///
    func authenticateThruUdacity(body: [String:AnyObject],completionHandler:(result: AnyObject!, error: NSError?) -> Void ) {
        
        let method = "session"
       // let parameters = [String: AnyObject] ()
        let urlString = "https://www.udacity.com/api/" + method //+ onMapClient.escapedParameters(parameters)
      
        let headerDic = ["Accept":"application/json","Content-Type":"application/json" ]

            onMapClient.sharedInstance().taskForPOSTMethod(urlString, headers: headerDic, jsonBody: body,offset: 5) { JSONResult, error in
            
            if let error = error {
                
                
                completionHandler(result: nil, error: error)
                
            } else {
                
                completionHandler(result: JSONResult, error: error)
            }
        }

        
    }
    
    func logoutUdacity(completionHandler: (error: NSError?) -> Void) {
        
        let requestString = "https://www.udacity.com/api/session"
        
        
      
        onMapClient.sharedInstance().taskForDELETEMethod(requestString, completionHandler: completionHandler)
        

        
    }
    
    
}