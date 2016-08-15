//
//  ConversationDetailTableViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit
import CloudKit

class ConversationDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var listOfUsersArrayTextField: UITextField!
    @IBOutlet weak var textInputTextField: UITextField!
    @IBOutlet weak var SendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let users = UserController.sharedController.usersInConversation{
            let userNameArray = users.flatMap({$0.userName})
            let stringOfNames = userNameArray.joinWithSeparator(", ")
            listOfUsersArrayTextField.text = stringOfNames
        }
        self.navigationItem.hidesBackButton = true
        reloadInputViews()
        tableView.reloadData()
    }
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        UserController.sharedController.usersInConversation = []
        performSegueWithIdentifier("unwindToConversationList", sender: self)
    }
    @IBAction func SendButtonTapped(sender: AnyObject) {
        UserController.sharedController.loadUsersInConversationReferences(nil)
        if ConversationController.sharedController.currentConversationDetailReference == nil {
            ConversationController.sharedController.addNewConversation(UserController.sharedController.usersInConversationReferences!, completion: {
                guard self.textInputTextField.text?.characters.count > 0 else {
                    return
                    //TODO: Make a Alert Controller that says type something
                }
                guard let capturedText = self.textInputTextField.text else {return}
                ConversationController.sharedController.addMessageToConversation(capturedText)
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ConversationController.sharedController.messagesInConversation.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        let text = ConversationController.sharedController.messagesInConversation[indexPath.row]
        cell.textLabel?.text = text.text
        cell.detailTextLabel?.text = text.timestamp.description
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
