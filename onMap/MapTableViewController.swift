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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        
        return cell
        
    }


}