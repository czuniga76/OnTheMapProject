//
//  OnMapConstants.swift
//  onMap
//
//  Created by Christian D. Zuniga on 1/3/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation

extension onMapClient {
    
    struct Constants {
        
        static let BaseURLSecure: String = "https://www.udacity.com/api/"
        static let ParseBaseURLSecure: String = "https://api.parse.com/1/classes/"
        
    }
    
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
    }
    
}
