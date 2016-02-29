//
//  StudentRecordsClass.swift
//  onMap
//
//  Created by Christian D. Zuniga on 2/27/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation

class StudentRecordsClass: NSObject {
    
    var studentRecords = [StudentInformation]()
    
   
    
    class func sharedInstance() -> StudentRecordsClass {
        struct Singleton {
            static var sharedInstance = StudentRecordsClass()
        }
        return Singleton.sharedInstance
    }
}
