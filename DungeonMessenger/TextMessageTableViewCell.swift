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

    @IBOutlet weak var senderTraillingMargin: NSLayoutConstraint!
    @IBOutlet weak var senderLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var textMessageLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var textMessageTraillingMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithCell(message: Message){
        textMessageLabel.text = message.text
        
        guard let senderUser = message.senderUser,
            let currentUser = UserController.sharedController.loggedInUserModelObject else {return}
        senderLabel.text = "\(senderUser.userName) / \(senderUser.raceName) \(senderUser.className)"
        if senderUser.userName == currentUser.userName {
            senderTraillingMargin.constant = 8
            senderLeadingMargin.constant = 100
            textMessageLeadingMargin.constant = 100
            textMessageTraillingMargin.constant = 0
            textMessageLabel.textAlignment = .Right
            senderLabel.textAlignment = .Right
        }
    }
}
