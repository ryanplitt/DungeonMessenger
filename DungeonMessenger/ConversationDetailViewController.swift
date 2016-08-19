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
    @IBOutlet weak var usersAndButtonHeaderView: UIView!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var transitionFromExisting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(self.updateTableView), name: "messagesUpdated", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
        if self.transitionFromExisting == false {
            ConversationController.sharedController.setCurrentConversationReference({ 
                self.transitionFromExisting = true
                print("Conversation Reference Set")
            })
        }
        guard ConversationController.sharedController.currentConversationReference != nil else {
            print("The while loop didn't work properly. The Conversation Reference was not set in time")
            return
        }
        guard let conversation = ConversationController.sharedController.currentConversation else {return}
        let userNames = conversation.userz.flatMap({$0.userName})
            self.usersInMessageTextField.text = userNames.joinWithSeparator(", ")
        ConversationController.sharedController.loadMessagesFromConversation(ConversationController.sharedController.currentConversationReference!) {
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableViewOutlet.reloadData()
            })
        }
        }
    }
    
    func updateTableView(){
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableViewOutlet.reloadData()
            self.scrollToBottom()
        }
    }
    
    
    func scrollToBottom(){
        let indexPath = NSIndexPath(forRow: ConversationController.sharedController.messagesInConversation.count-1, inSection: 0)
        tableViewOutlet.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func updateViewControllerForExistingConversation(){
        self.usersAndButtonHeaderView.hidden = false
        self.tableViewOutlet.sizeToFit()
    }
    
    @IBAction func addNewUserToConversationButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if ConversationController.sharedController.currentConversationReference == nil {
            ConversationController.sharedController.createNewConversation(ConversationController.sharedController.ckReferencesOfUsersInConversation, completion: {
                if let messageText = self.textMessageInputTextField.text {
                    ConversationController.sharedController.sendNewMessage(messageText, completion: {
                        self.updateTableView()
                    })
                }
            })
        } else if let messageText = self.textMessageInputTextField.text {
            ConversationController.sharedController.sendNewMessage(messageText, completion: {
                self.updateTableView()
            })
        }
        self.textMessageInputTextField.text = ""
        self.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ConversationController.sharedController.messagesInConversation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as? TextMessageTableViewCell
        
        cell?.senderLabel.text = ConversationController.sharedController.messagesInConversation[indexPath.row].senderUser?.userName
        cell?.textMessageLabel.text = ConversationController.sharedController.messagesInConversation[indexPath.row].text
        return cell ?? UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 35.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    
}
