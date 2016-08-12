//
//  ConversationController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CloudKit

class ConversationController {
    
    static let sharedController = ConversationController()
    
    var conversations: [Conversation] = []
    
    func addNewConversation(users: [CKReference]) {
        // TODO: GUARD TO MAKE SURE THERE ISN"T ALREADY A CONVERSATION
        let conversation = Conversation(users: users)
        conversations.append(conversation)
        CloudKitManager.sharedController.saveRecord(conversation.ckRecord) { (record, error) in
            guard error != nil else {
                print("there was a problem saving the new conversation")
                return
            }
        }
    }
    
    func loadConversationsForLoggedInUser() {
        guard let userReference = UserController.sharedController.currentUserReference else {
            print("unable to load User Reference")
            return
        }
        let predicate = NSPredicate(format: "SUBQUERY(conversationsArray, $conversation, $conversation.users.contains(userReference)")
        CloudKitManager.sharedController.fetchRecordsWithType(Conversation.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            self.conversations.append(Conversation(ckRecord: record)!)
            }) { (records, error) in
                if error != nil {
                    print("There was an error obtaining the Conversation Record. \(error?.localizedDescription)")
                }
        }
        
//        
//        
//        let whateveer = Conversation(users: [UserController.sharedController.currentUserReference!])
//        whateveer.users.contains(<#T##element: CKReference##CKReference#>)
    }
    
}