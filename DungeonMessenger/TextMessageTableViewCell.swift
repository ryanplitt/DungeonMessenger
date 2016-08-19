//
//  TextMessageTableViewCell.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/17/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
