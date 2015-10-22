//
//  EventsTableViewController.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/13/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit
import Parse


class EventsTableViewController: UITableViewController {
    
    // MARK: VARIABLES
    
    var tableData = []
    var refresh = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)

    // MARK: INITIALIZATOIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the activity indicator (loading spinner)
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonItem
        activityIndicator.startAnimating()
        
        // Set up the refresh control (pull to refresh)
        self.refreshControl = self.refresh
        self.refresh.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        
        // Set up the table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        // Get data from server
        retreiveAndInsertDataFromServer()
    }

    // MARK: TABLEVIEW DATA SOURCE

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count + 2
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0;
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! EventsTableViewCustomHeaderCell
        
        let unformattedDate = tableData[section][0]["date"] as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "EEEE"
        let date = dateFormatter.stringFromDate(unformattedDate)
        
        headerCell.headerLabel.text = date.uppercaseString
        
        return headerCell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 || (indexPath.row == tableData[indexPath.section].count + 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SpacingCell", forIndexPath: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
            
            // Get event and details about event
            let event = self.tableData[indexPath.section][indexPath.row-1]
            var title = event["title"] as! String
            var location = event["location"] as! String
            
            // Handle empty title
            if title == "" {
                title = "No title"
            }
            if location == "" {
                location = " "
            }
            
            // Get time of event
            let unformattedDate = event["date"] as! NSDate
            let dateTimeFormatter = NSDateFormatter()
            dateTimeFormatter.timeZone = NSTimeZone(name: "UTC")
            dateTimeFormatter.dateFormat = "h:mm"
            let time = dateTimeFormatter.stringFromDate(unformattedDate)
            
            // Get time period
            let dateDayNightFormatter = NSDateFormatter()
            dateDayNightFormatter.timeZone = NSTimeZone(name: "UTC")
            dateDayNightFormatter.dateFormat = "a"
            let dayNight = dateDayNightFormatter.stringFromDate(unformattedDate)
            
            // Display information in cells
            cell.eventLocation.text = location
            cell.eventTitle.text = title
            cell.eventTime.text = time
            cell.eventDayNight.text = dayNight
            
            return cell
        }
    }
    
    // MARK: SERVER COMMUNICATION
    
    func retreiveAndInsertDataFromServer() {
        let eventsQuery = PFQuery(className: "Events")
        eventsQuery.orderByAscending("date")
        eventsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = self.splitEvents(objects!)
                self.tableView.reloadData()
            } else {
                self.presentErrorWithDescription(error!.localizedDescription)
            }
            
            self.refresh.endRefreshing()
            self.activityIndicator.stopAnimating()
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
    
    // MARK: HELPERS
    
    func splitEvents(events: Array<PFObject>) -> Array<Array<PFObject>> {
        var currentDay = "0"
        var formattedEvents = Array<Array<PFObject>>()
        
        for event in events {
            let unformattedDate = event["date"] as! NSDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.stringFromDate(unformattedDate)
            
            if (day != currentDay) {
                formattedEvents.append([])
                currentDay = day
            }
            
            formattedEvents[formattedEvents.count - 1].append(event)
        }
        
        return formattedEvents
    }
}