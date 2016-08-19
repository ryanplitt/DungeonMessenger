//
//  ConversationListTableViewController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/15/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import UIKit

class ConversationListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.sharedController.getContacts()
        UserController.sharedController.setCurrentUser {
            UserController.sharedController.ObtainActiveLoggedInUserReference({ (success) in
                if success != true {
                    print("it was not a success. Opening Registration page")
                    self.showRegistrationViewController()
                }
                    ConversationController.sharedController.fetchUsersConversations({
                        dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                })
                
            })
        }
    }
    
    
    func showRegistrationViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC = storyboard.instantiateViewControllerWithIdentifier("registrationVC")
        self.presentViewController(registrationVC, animated: true) { 
            //
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationController.sharedController.conversations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)

        guard ConversationController.sharedController.conversations.count > 0 else { return UITableViewCell() }
        let userz = ConversationController.sharedController.conversations[indexPath.row].userz
        let nameOfUserz = userz.flatMap({$0.userName})
        cell.textLabel?.text = nameOfUserz.joinWithSeparator(", ")
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
            ConversationController.sharedController.currentConversation = ConversationController.sharedController.conversations[indexPath.row]
                guard let usersInConversation = ConversationController.sharedController.currentConversation?.userz else {
                    print("the users in the conversation were not loaded properly.")
                    return
                }
                UserController.sharedController.usersInMessage = usersInConversation
                guard let detailVC = segue.destinationViewController as? ConversationDetailViewController else {
                    print("Couldn't cast as destination view controller")
                    return
                }
        ConversationController.sharedController.setCurrentConversationReference {

            dispatch_async(dispatch_get_main_queue(), { 
                let userNamesInConversation = usersInConversation.flatMap({$0.userName})
            detailVC.navigationItem.title = userNamesInConversation.joinWithSeparator(", ")
                detailVC.transitionFromExisting = true
            })
            }
        }
}
