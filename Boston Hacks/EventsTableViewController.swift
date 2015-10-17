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
    
    // Data for the table
    var tableData = []
    
    var refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "Schedule"
        
        self.refreshControl = self.refresh
        self.refresh.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 98.0
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        let eventsQuery = PFQuery(className: "Events")
        eventsQuery.orderByAscending("date")
        eventsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = self.splitEvents(objects!)
                self.tableView.reloadData()
            }
        }
        
    }
    
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
    
    func didRefreshList() {
        
        let eventsQuery = PFQuery(className: "Events")
        eventsQuery.orderByAscending("date")
        eventsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableData = self.splitEvents(objects!)
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
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData[section].count
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let unformattedDate = tableData[section][0]["date"] as! NSDate
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        dateFormatter.dateFormat = "EEEE"
//        let date = dateFormatter.stringFromDate(unformattedDate)
//        
//        return date
//    }
    
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell

        cell.userInteractionEnabled = false
        
        let event = self.tableData[indexPath.section][indexPath.row]
        
        let title = event["title"] as! String
        let location = event["location"] as! String
        
        let unformattedDate = event["date"] as! NSDate
        let dateTimeFormatter = NSDateFormatter()
        dateTimeFormatter.timeZone = NSTimeZone(name: "UTC")
        dateTimeFormatter.dateFormat = "h:mm"
        let time = dateTimeFormatter.stringFromDate(unformattedDate)
        
        let dateDayNightFormatter = NSDateFormatter()
        dateDayNightFormatter.timeZone = NSTimeZone(name: "UTC")
        dateDayNightFormatter.dateFormat = "a"
        let dayNight = dateDayNightFormatter.stringFromDate(unformattedDate)
        
        
//        if (location == "") {
//            cell.eventLocation.hidden = true
//            cell.locationBottomConstraint.active = false
//        }
//        else {
//            cell.eventLocation.hidden = false
//            cell.locationBottomConstraint.active = true
//        }
        cell.eventLocation.text = location
        cell.eventTitle.text = title
        cell.eventTime.text = time
        cell.eventDayNight.text = dayNight
        
        return cell
    }

}
