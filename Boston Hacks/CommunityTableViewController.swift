//
//  CommunityTableViewController.swift
//  Boston Hacks
//
//  Created by Aleksander Skjoelsvik on 10/19/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit
import Parse
import Social

class CommunityTableViewController: UITableViewController {
    
    // MARK: VARIABLES
    
    @IBOutlet weak var joinSlackButton: UIButton!
    
    var tableData: [PFObject] = []
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    // MARK: INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the activity indicator (loading spinner)
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonItem
        activityIndicator.startAnimating()
        
        // Set up the join slack button
        joinSlackButton.layer.borderColor = UIColor.whiteColor().CGColor
        joinSlackButton.layer.borderWidth = 1
        joinSlackButton.layer.cornerRadius = 4
        
        // Get a list of the people and update the tableview
        let query = PFQuery(className: "People")
        query.orderByAscending("updatedAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // Check if there are any objects
                if objects?.count != 0 {
                    for object in objects! {
                        self.tableData.append(object)
                    }
                } else {
                    // Present an error to the user if there are no objects
                    self.presentErrorWithDescription("No people found")
                }
            } else {
                // Present an error to the user if there was an error with the database
                self.presentErrorWithDescription(error!.localizedDescription)
            }
            
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    // MARK: TABLEVIEW DATA SOURCE
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommunityTableViewCell", forIndexPath: indexPath) as! CommunityTableViewCell
        
        // Re-enable the buttons (if they were disabled in the past)
        cell.twitterButton.enabled = true
        cell.emailButton.enabled = true
        
        // Update the button actions accordingly
        cell.twitterButton.addTarget(self, action: "twitterButtonDidPress:", forControlEvents: .TouchUpInside)
        cell.twitterButton.tag = indexPath.row
        cell.emailButton.addTarget(self, action: "emailButtonDidPress:", forControlEvents: .TouchUpInside)
        cell.emailButton.tag = indexPath.row
        
        // Get the person for the current row
        let person = tableData[indexPath.row]
        
        // Get the name of the current person
        var personName = "No name"
        if let tempPersonName = person["name"] {
            if tempPersonName as! String != "" {
                personName = tempPersonName as! String
            }
        }
        
        // Get the role of the current person
        var personRole = "No role"
        if let tempPersonRole = person["role"] {
            if tempPersonRole as! String != "" {
                personRole = tempPersonRole as! String
            }
        }
        
        // Get the twitter handle of the correct person
        var personTwitter = ""
        if let tempPersonTwitter = person["twitter"] {
            personTwitter = tempPersonTwitter as! String
        }
        
        // Get the email address of the current person
        var personEmail = ""
        if let tempPersonEmail = person["email"] {
            personEmail = tempPersonEmail as! String
        }
        
        // Display the name and role in the cell
        cell.personNameLabel.text = personName
        cell.personRoleLabel.text = personRole
        
        // Disable the buttons if there is no twitter/ email info
        if personTwitter == "" {
            cell.twitterButton.enabled = false
        }
        if personEmail == "" {
            cell.emailButton.enabled = false
        }
        
        return cell
    }
    
    // MARK: ACTIONS
    
    func twitterButtonDidPress(sender: UIButton) {
        // Get the tapped person and his twitter handle
        let person = tableData[sender.tag]
        let twitter = person["twitter"] as! String
        
        // Check if twitter account is linked with iOS
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            // Open the twitter view controller and tag the person
            let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText("@\(twitter) ")
            self.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            // Open twitter in Safari (app if installed)
            UIApplication.sharedApplication().openURL((NSURL(string: "https://www.twitter.com/\(twitter)"))!)
        }
    }
    
    func emailButtonDidPress(sender: UIButton) {
        // Get the person and his email
        let person = tableData[sender.tag]
        let email = person["email"] as! String
        
        // Open the email app with the person as the recipient
        UIApplication.sharedApplication().openURL((NSURL(string: "mailto:\(email)"))!)
    }
    
    @IBAction func joinSlackButtonDidPress(sender: UIButton) {
        // Open the slack website
        UIApplication.sharedApplication().openURL((NSURL(string: "https://bostonhacks.slack.com/signup"))!)
    }
    
    // MARK: ERRORS
    
    func presentErrorWithDescription(description: String) {
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .Alert)
        let button = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(button)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}