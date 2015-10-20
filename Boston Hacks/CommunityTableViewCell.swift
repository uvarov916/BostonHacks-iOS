//
//  CommunityTableViewCell.swift
//  Boston Hacks
//
//  Created by Aleksander Skjoelsvik on 10/19/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personRoleLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func drawRect(rect: CGRect) {
        // Set up the email button
        emailButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        emailButton.layer.borderWidth = 1
        emailButton.layer.cornerRadius = 4
        
        // Set up the twitter button
        twitterButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        twitterButton.layer.borderWidth = 1
        twitterButton.layer.cornerRadius = 4
    }
}