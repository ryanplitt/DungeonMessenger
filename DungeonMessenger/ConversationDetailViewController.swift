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
    @IBOutlet weak var textMessageInputTextField: UITextField!

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.enabled = false
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(updateTableView), name: "messagesUpdated", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let userNames = UserController.sharedController.usersInMessage.flatMap({$0.userName})
        usersInMessageTextField.text = userNames.joinWithSeparator(", ")
        ConversationController.sharedController.setCurrentConversationReference { 
            self.updateTableView()
        }
    }
    
    func updateTableView(){
        tableViewOutlet.reloadData()
    }
    
    @IBAction func addNewUserToConversationButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if ConversationController.sharedController.currentConversationReference == nil {
            ConversationController.sharedController.createNewConversation(ConversationController.sharedController.ckReferencesOfUsersInConversation, completion: { 
                if let messageText = self.textMessageInputTextField.text {
                    ConversationController.sharedController.sendNewMessage(messageText)
                    self.tableViewOutlet.reloadData()
                }
            })
        } else if let messageText = textMessageInputTextField.text {
        ConversationController.sharedController.sendNewMessage(messageText)
            self.tableViewOutlet.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ConversationController.sharedController.messagesInConversation.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as? TextMessageTableViewCell
     
    cell?.senderLabel.text = ConversationController.sharedController.messagesInConversation[indexPath.row].sender.description
        cell?.textMessageLabel.text = ConversationController.sharedController.messagesInConversation[indexPath.row].text
     
     return cell ?? UITableViewCell()
     }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    
    
}
