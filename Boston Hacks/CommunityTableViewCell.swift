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
        //let borderColor = UIColor(red: 233/255.0, green: 31/255.0, blue: 99/255.0, alpha: 1.0).CGColor
        
        // Set up the email button
        /*emailButton.layer.borderColor = borderColor
        emailButton.layer.borderWidth = 1
        emailButton.layer.cornerRadius = 4*/
        
        // Set up the twitter button
        /*twitterButton.layer.borderColor = borderColor
        twitterButton.layer.borderWidth = 1
        twitterButton.layer.cornerRadius = 4*/
    }
}