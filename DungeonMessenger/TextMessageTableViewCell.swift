//
//  TextMessageTableViewCell.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/17/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {
    
    static var sharedView = TextMessageTableViewCell()
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!

    @IBOutlet weak var senderTraillingMargin: NSLayoutConstraint!
    @IBOutlet weak var senderLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var textMessageLeadingMargin: NSLayoutConstraint?
    @IBOutlet weak var textMessageTraillingMargin: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state        

    }
    
    func updateWithCell(message: Message){

        let altTextMessageLeadingMargin = NSLayoutConstraint(item: textMessageLabel, attribute: .Leading, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Trailing, multiplier: 1.0, constant: 108.0)
        let altTextMessageTraillingMargin = NSLayoutConstraint(item: textMessageLabel, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1.0, constant: -8.0)
        textMessageLabel.text = message.text
                dispatch_async(dispatch_get_main_queue()) {
        guard let senderUser = message.senderUser,
            let currentUser = UserController.sharedController.loggedInUserModelObject else {return}
        self.senderLabel.text = "\(senderUser.userName) / \(senderUser.raceName) \(senderUser.className)"
//        if senderUser.userName != currentUser.userName {
//            self.senderTraillingMargin.constant = 100
//            self.senderLeadingMargin.constant = 8
//            altTextMessageLeadingMargin.active = false
//            altTextMessageTraillingMargin.active = false
//            self.textMessageLeadingMargin?.active = true
//            self.textMessageTraillingMargin?.active = true
//            self.textMessageLabel.textAlignment = .Justified
//            self.highlightView.backgroundColor = UIColor.grayColor()
//            self.textMessageLabel.textColor = UIColor.blackColor()
//        }
//        else
            if senderUser.reference == currentUser.reference {
            
            self.senderTraillingMargin.constant = 8
            self.senderLeadingMargin.constant = 100
            self.textMessageLeadingMargin?.active = false
            self.textMessageTraillingMargin?.active = false
            self.senderLabel.textAlignment = .Right
            self.highlightView.backgroundColor = UIColor.purpleColor()
            self.textMessageLabel.textColor = UIColor.whiteColor()
            altTextMessageLeadingMargin.active = true
            altTextMessageTraillingMargin.active = true
            }
        }
    }
}
