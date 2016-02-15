//
//  StudentInformation.swift
//  onMap
//
//  Created by Christian D. Zuniga on 1/3/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import MapKit

public struct StudentInformation{
    
    var firstName: String
    var lastName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var mediaURL: String
    var updatedLast: NSDate
    
    init(dictionary: [String : AnyObject]) {
            firstName = dictionary["firstName"] as! String
            lastName = dictionary["lastName"] as! String
            latitude = dictionary["latitude"] as! CLLocationDegrees
            longitude = dictionary["longitude"] as! CLLocationDegrees
            mediaURL = dictionary["mediaURL"] as! String
            updatedLast = dictionary["updatedLast"] as! NSDate
    }
}