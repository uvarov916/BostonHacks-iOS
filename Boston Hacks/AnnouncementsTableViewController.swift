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
    
    // MARK: VARIABLES
    
    var tableData = []
    var refresh = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    // MARK: INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the activity indicator (loading spinner)
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonItem
        activityIndicator.startAnimating()
        
        // Add the refresh control (pull to refresh)
        self.refreshControl = self.refresh
        self.refresh.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        
        // Set up the tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 98.0
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        // Get the data
        retreiveAndInsertDataFromServer()
    }

    // MARK: TABLEVIEW DATA SOURCE

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! AnnouncementTableViewCell
        
        // Get details about announcement
        let announcement = self.tableData[indexPath.row]
        let title  = announcement["title"] as! String
        let description = announcement["description"] as! String
        let timePosted = announcement.createdAt
        let timeSincePosted = NSDate().offsetFrom(timePosted!!)
        
        // Handle empty title
        if title == "" {
            title == "No title"
        }
        
        // Display details in cell
        cell.announcementTile.text = title
        cell.announcementDescription.text = description
        cell.announcementTime.text = timeSincePosted

        return cell
    }
    
    // MARK: SERVER COMMUNICATION
    
    func retreiveAndInsertDataFromServer() {
        let announcementsQuery = PFQuery(className: "Announcements")
        announcementsQuery.orderByDescending("createdAt")
        announcementsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = objects!
                self.tableView.reloadData()
            } else {
                self.presentErrorWithDescription(error!.localizedDescription)
            }
            
            self.activityIndicator.stopAnimating()
            self.refresh.endRefreshing()
        }
    }
    
    // MARK: USER ACTIONS
    
    func didRefreshList() {
        retreiveAndInsertDataFromServer()
    }
    
    // MARK: ERRORS
    
    func presentErrorWithDescription(description: String) {
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .Alert)
        let button = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(button)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}