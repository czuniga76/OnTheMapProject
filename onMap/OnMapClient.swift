//
//  OnMapClient.swift
//  onMap
//
//  Created by Christian D. Zuniga on 1/3/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import MapKit


class onMapClient : NSObject {
    
    //var session: NSURLSession
    
    override init() {
        //session = NSURLSession.sharedSession()
        //super.init()
        
    }
    
    func taskForGETMethod(method: String, baseURL: String, headers: [String: String] ,parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        
        let urlString = baseURL// + method
            
            //+ onMapClient.escapedParameters(mutableParameters)
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        if (headers.count > 0) {
            for (header, value) in headers {
                request.addValue(value , forHTTPHeaderField: header)
        }
        }
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
           
            if let error = downloadError {
                    print("download error")
                    completionHandler(result: nil, error: downloadError)

            } else {
                // print(NSString(data: data, encoding: NSUTF8StringEncoding))
                var parsedResult = [String:AnyObject]()
                var parsingError: NSError? = nil
                
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                    print(response)
                    
                    //print(parsedResult)
                    
                    completionHandler(result: parsedResult, error: nil)
                }
                catch let error as NSError {
                    parsingError = error
                    // parsedResult = nil
                }
                
                if let error = parsingError {
                    print("parsing error in json serialization")
                    
                } else {
                    print("success in parse download")
                   
                }
                
                
            }
        }
        task.resume()
        

        return task
    }
    
    
    class func sharedInstance() -> onMapClient {
        struct Singleton {
            static var sharedInstance = onMapClient()
        }
        return Singleton.sharedInstance
    }
}

