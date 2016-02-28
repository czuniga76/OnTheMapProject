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
    //var studentRecords = [StudentInformation]()
    
    var annotations = [MKPointAnnotation]()
    
    override init() {
        //session = NSURLSession.sharedSession()
        //super.init()
        
    }
    
    func taskForGETMethod(method: String, baseURL: String, headers: [String: String] ,parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> Void {
        
        
        
        let urlString = baseURL + method
            
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
                
                    completionHandler(result: nil, error: error)

            } else {
                
                let httpResponse = response as? NSHTTPURLResponse
                    //print(httpResponse.statusCode)
                if (httpResponse!.statusCode >= 200) && (httpResponse!.statusCode < 300) {
                
                
                    var parsedResult = [String:AnyObject]()
                    var parsingError: NSError? = nil
                    //CHECK if parseJSONwithCompletionhandler can be called here
                    do {
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                    
                    
                        completionHandler(result: parsedResult, error: nil)
                    }
                    catch let error as NSError {
                        parsingError = error
                        completionHandler(result: nil, error: parsingError)
                    }
                
                } else {
                    let responseError = onMapClient.errorForHTTPResponse(urlString, response: httpResponse!)
                    
                    completionHandler(result: nil, error: responseError)
                }
                
            }
        }
        task.resume()
        

        
    }
    
    
    
    func taskForPOSTMethod(requestURL:String, headers: [String : String], jsonBody: [String:AnyObject], offset: Int, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> Void {
        
     
        
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
            
            
        
        
            /* 4. Make the request */
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* 5/6. Parse the data and use the data  */
            
                
                if let error = downloadError {
                   
                
                    completionHandler(result: nil, error: error)
                
                } else {
                     let httpResponse = response as? NSHTTPURLResponse
                        
                        if (httpResponse!.statusCode >= 200) && (httpResponse!.statusCode < 300 ) {
                        
                    
                           
                   
                    
                            let newData = data!.subdataWithRange(NSMakeRange(offset, data!.length - offset))
                            onMapClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
                        } else {
                            
                           
                          
                            
                            let responseError = onMapClient.errorForHTTPResponse(requestURL, response: httpResponse!)
                            
                            completionHandler(result: nil, error: responseError)
                        }
                    
                   
                }
            }
        
            /* 7. Start the request */
            task.resume()
        
           
        
        } catch let error as NSError {
            // error in forming request body
            jsonifyError = error
            request.HTTPBody = nil
            completionHandler(result: nil, error: jsonifyError)
            
        }

    }

    
    func taskForDELETEMethod(requestString:String,completionHandler: (error: NSError?) -> Void) -> Void {
        
         let requestURL = NSURL(string: requestString)
         let request = NSMutableURLRequest(URL: requestURL!)
        
         request.HTTPMethod = "DELETE"
         var xsrfCookie: NSHTTPCookie? = nil
         let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
         for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
         }
         if let xsrfCookie = xsrfCookie {
             request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
         }

        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
        
                completionHandler(error: error)
           
            
        }
        task.resume()

    
    }
    
    class func errorForHTTPResponse(urlString: String, response: NSHTTPURLResponse) -> NSError {
        
        let domainDic: [Int: String] = [403: "Invalid Username/Password"]
        
        var messageDescription : String
        
        if domainDic[response.statusCode] != nil {
            messageDescription = domainDic[response.statusCode]!
        } else {
            messageDescription = NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode)
        }
        print(response)
        
        let userInfo: [NSObject : AnyObject] =
        [
        
        
            NSLocalizedDescriptionKey :  NSLocalizedString("Bad Response", value: messageDescription, comment: ""),
            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Error", value: messageDescription, comment: "")
        ]
        let udError  = NSError(domain: urlString, code: response.statusCode, userInfo: userInfo)
        return udError
        
        
    }
    
    /* unsure if needed
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[onMapClient.JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "OntheMap Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    */
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        
        var parsedResult = [String:AnyObject]()
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
            
          
            
            
            
            
            if let errorMessage = parsedResult["error"] {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                parsingError = NSError(domain: "OntheMap Error", code: 1, userInfo: userInfo)
                completionHandler(result: nil, error: parsingError )
            } else {
                completionHandler(result: parsedResult, error: nil)
            }
            
            
            
        } catch let error as NSError {
            parsingError = error
            completionHandler(result: nil, error: parsingError)
        }
        
    }

    
    /*
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
    
    */
    
    
    class func sharedInstance() -> onMapClient {
        struct Singleton {
            static var sharedInstance = onMapClient()
        }
        return Singleton.sharedInstance
    }
}

