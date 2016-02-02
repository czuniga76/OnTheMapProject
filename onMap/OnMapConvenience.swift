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
            var studentRecords = [StudentInformation]()
            
            
            if let error = error {
                completionHandler(result:nil, error: error)
                print("error")
            } else {
                print("success")
                let studentLocations = (JSONResult["results"] as! NSArray) as Array
                
                for  dictionary in studentLocations {
                    
                    
                    
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    
                    
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                
                    let student = StudentInformation(firstName: first,lastName: last, latitude: lat, longitude: long, mediaURL: mediaURL)
                    
                    
                    
                    
                   
                    
                    //print(student.firstName,student.lastName,student.mediaURL)
                    studentRecords.append(student)
                }
                completionHandler(result: studentRecords, error:nil)
                
                
            }
        }
        
        
        
    }

    
    
}