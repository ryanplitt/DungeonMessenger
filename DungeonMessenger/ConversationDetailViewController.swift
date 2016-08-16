//
//  ConversationDetailViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/16/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class ConversationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var usersInMessageTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        let userNames = UserController.sharedController.usersInMessage.flatMap({$0.userName})
        usersInMessageTextField.text = userNames.joinWithSeparator(", ")
    }
    
    @IBAction func addNewUserToConversationButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    
    
}
