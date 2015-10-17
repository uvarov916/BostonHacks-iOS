//
//  AnnouncementTableViewCell.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/12/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    @IBOutlet weak var announcementTile: UILabel!
    @IBOutlet weak var announcementDescription: UILabel!
    @IBOutlet weak var announcementTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
