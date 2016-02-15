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
    var studentRecords = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
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
    
    
    
    func taskForPOSTMethod(requestURL:String, headers: [String : String], jsonBody: [String:AnyObject], offset: Int, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
     
        
        let url = NSURL(string: requestURL)!
        let request = NSMutableURLRequest(URL: url)
        
    
        
        
        var jsonifyError: NSError? = nil
        
        request.HTTPMethod = "POST"
        
        if (headers.count > 0) {
            for (header, value) in headers {
                request.addValue(value , forHTTPHeaderField: header)
            }
        }
        
        
        do {
            
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
            
            
        } catch let error as NSError {
            // error in forming request
            jsonifyError = error
            request.HTTPBody = nil
        }
        
        /* 4. Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            let newData = data!.subdataWithRange(NSMakeRange(offset, data!.length - offset))
            if let error = downloadError {
                let newError = onMapClient.errorForData(newData, response: response, error: error)
                
                completionHandler(result: nil, error: downloadError)
            } else {
                
                onMapClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[onMapClient.JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "OntheMap Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        
        var parsedResult = [String:AnyObject]()
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
            
            
            
            
        } catch let error as NSError {
            parsingError = error
            // parsedResult = nil
        }
        
        if let error = parsingError {
            //print("parsing error in json serialization")
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }

    
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    

    
    class func sharedInstance() -> onMapClient {
        struct Singleton {
            static var sharedInstance = onMapClient()
        }
        return Singleton.sharedInstance
    }
}

