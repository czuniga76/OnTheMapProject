//
//  MapTableViewController.swift
//  onMap
//
//  Created by Christian D. Zuniga on 2/6/16.
//  Copyright © 2016 ZTechnology. All rights reserved.
//

import Foundation
import UIKit

class MapTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
                    
        onMapClient.sharedInstance().getParseLocationData { students, error in
            if let students  = students {
                //print("succes")
                dispatch_async(dispatch_get_main_queue()) {

                    self.tableView.reloadData()
                }
            }
            
        
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onMapClient.sharedInstance().studentRecords.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        
        let student = onMapClient.sharedInstance().studentRecords[indexPath.row]
        var name = student.firstName
        name.appendContentsOf(" ")
        name.appendContentsOf(student.lastName)
        
        cell.textLabel?.text = name
        
        
        
        return cell
        
    }


}