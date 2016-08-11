//
//  ConversationListTableViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit
import CloudKit

class ConversationListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let user = NSUserDefaults.standardUserDefaults().objectForKey("currentUserRecordID") as? String {
        UserController.sharedController.fetchCurrentUser({ (success) in
            if success != true {
                self.setupRegistrationPage()
            }
        })
    }
    
    
    func setupRegistrationPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("registrationVC")
        self.presentViewController(controller, animated: true, completion: nil)
        return
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
    }
    
    
    @IBAction func newMessageButtonTapped(sender: AnyObject) {
        guard UserController.sharedController.contactsList.count > 0 else {
            let alert = UIAlertController(title: "Wait A Second", message: "Please wait while the contacts are being loaded", preferredStyle: .Alert)
            let okay = UIAlertAction(title: "Okay", style: .Default, handler: { (_) in
                //
            })
            alert.addAction(okay)
            presentViewController(alert, animated: true, completion: { 
                //
            })
            return
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationController.sharedController.conversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)
        
        let conversations = ConversationController.sharedController.conversations
        let references = conversations[indexPath.row].users
        var users: [User] = []
        for reference in references {
            CloudKitManager.sharedController.fetchRecordWithID(reference.recordID, completion: { (record, error) in
                guard let record = record, user = User(ckRecord: record) else {return}
                
                users.append(user)
            })
        }
        
        cell.textLabel?.text = users[indexPath.row].userName
        cell.detailTextLabel?.text = "\(users[indexPath.row].raceName) \(users[indexPath.row].className)"
        
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
        
    }
}
