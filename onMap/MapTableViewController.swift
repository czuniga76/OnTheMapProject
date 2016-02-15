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
    @IBAction func reloadData(sender: UIBarButtonItem) {
        getStudentData()
    }
    
    /*
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
    */
    
    //TODO override viewWillAppear to update data in case it was updated from the other view.
    
    func getStudentData() {
        onMapClient.sharedInstance().getParseLocationData { students, error in
            if let students  = students {
                
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
        cell.detailTextLabel?.text = student.mediaURL
        
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell

        
        if let url = NSURL(string:(cell.detailTextLabel?.text)!) {
            
            UIApplication.sharedApplication().openURL(url)
        } else {
            let errorMessage = "Invalid URL"
           
            let ac = UIAlertController(title: "", message: errorMessage, preferredStyle: .Alert)
            
            let acceptError = UIAlertAction(title: "OK", style: .Default, handler: nil)
            ac.addAction(acceptError)
            self.presentViewController(ac, animated: true,completion: nil)
            
        }
        
        
    }


}