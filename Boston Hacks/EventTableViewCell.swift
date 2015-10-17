//
//  EventTableViewCell.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/13/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDayNight: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var locationBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
