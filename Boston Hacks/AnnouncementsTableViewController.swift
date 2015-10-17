//
//  AnnouncementsTableViewController.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/10/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit
import Parse


class AnnouncementsTableViewController: UITableViewController {
    
    // Data for the table
    var tableData = []
    
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Announcements"
        
        self.refreshControl = self.refresh
        self.refresh.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 98.0
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        let announcementsQuery = PFQuery(className: "Announcements")
        announcementsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = objects!
                self.tableView.reloadData()
            }
        }
        
    }
    
    func didRefreshList() {
        
        let announcementsQuery = PFQuery(className: "Announcements")
        announcementsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = objects!
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! AnnouncementTableViewCell
        cell.userInteractionEnabled = false
        
        let announcement = self.tableData[indexPath.row]
        
        let title  = announcement["title"] as! String
        let description = announcement["description"] as! String
        
        cell.announcementTile.text = title
        cell.announcementDescription.text = description
        cell.announcementTime.text = "20m"
        
        /*cell.textLabel!.text = title
        cell.detailTextLabel!.text = description*/
        

        return cell
    }
    

}
