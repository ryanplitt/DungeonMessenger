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
    
    // MARK: - Conversation List Variables
    
    var conversations: [Conversation] = []
    
    // MARK: - Conversation Detail Variables
    
    var currentConversationDetailReference: CKReference?
    var messagesInConversation: [Message] = []
    
    
    
    // MARK: - Conversation List Functions
    
    func addNewConversation(users: [CKReference],completion: (() -> Void)?) {
        // TODO: GUARD TO MAKE SURE THERE ISN"T ALREADY A CONVERSATION
        let conversation = Conversation(users: users)
        conversations.append(conversation)
        CloudKitManager.sharedController.saveRecord(conversation.ckRecord) { (record, error) in
            if error != nil {
                print("there was a problem saving the new conversation")
            }
            if let record = record  {
                print("You suck")
            self.currentConversationDetailReference = CKReference(recordID: record.recordID, action: .None)
                if let completion = completion {
                    completion()
                }
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
    
    // MARK: - Conversation Detail Functions
    
    func addMessageToConversation(message: String){
        guard let currentUserReference = UserController.sharedController.currentUserReference else {
            print("There was a problem getting the Current User info or it was nil")
            return
        }
        let message = Message(text: message, sender: currentUserReference, conversation: ConversationController.sharedController.currentConversationDetailReference!)
        CloudKitManager.sharedController.saveRecord(message.ckRecord) { (record, error) in
            print("Message Saved In ICloud")
        }
    }
    
    func loadMessagesToConversationDetail(conversation: Conversation){
//        let message = Message(text: "Hey", sender: UserController.sharedController.currentUserReference!, conversation: CKReference(recordID: conversation.ckRecord.recordID, action: .None)
//        let predicate = NSPredicate(format: "ALL ", <#T##args: CVarArgType...##CVarArgType#>)
    }
}