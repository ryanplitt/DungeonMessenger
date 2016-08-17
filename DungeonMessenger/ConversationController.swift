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

    // MARK: - Conversation variables
    var conversations: [Conversation] = []
    var currentConversation: Conversation? {
        didSet{
            print("The Conversation has been set")
        }
    }
    var currentConversationReference: CKReference? {
        didSet{
            print("The current ConversationReference has been set")
        }
    }
    var ckReferencesOfUsersInConversation: [CKReference] {
        return UserController.sharedController.usersInMessage.flatMap({$0.reference})
    }
    
    
    // MARK: - Message variables
    var messagesInConversation: [Message] = [] {
        didSet{
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName("messagesUpdated", object: self)
            print("The message count in this thread is \(messagesInConversation.count)")
        }
    }
    
    
    // MARK: - CONVERSATION FUNCTIONS
    
    func createNewConversation(users: [CKReference], completion: (() -> Void)?){
        let newConversation = Conversation(users: users, timestamp: NSDate())
        conversations.append(newConversation)
        CloudKitManager.sharedController.saveRecord(newConversation.ckRecord) { (record, error) in
            guard let record = record else {
                print("There was no conversation saved. \(error?.localizedDescription)")
                completion?()
                return
            }
            self.currentConversationReference = CKReference(record: record, action: .None)
            completion?()
        }
    }
    
    func setCurrentConversationReference(completion: () -> Void) {
        
//        let predicate = NSPredicate(format: "Users == %@", self.ckReferencesOfUsersInConversation)
        let predicate = NSPredicate(value: true)
        CloudKitManager.sharedController.fetchRecordsWithType(Conversation.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            print("There was a conversation record found!")
            }) { (records, error) in
                guard let records = records else {
                    print("There was no matching Conversation with the selected Users")
                    completion()
                    return
                }
                guard let conversationRecord = records.first else {
                    print("The record returned for the Conversation w/ users was empty.")
                    completion()
                    return
                }
                self.currentConversationReference = CKReference(record: conversationRecord, action: .None)
                completion()
        }
    }
    
    func fetchUsersConversations(completion: () -> Void){
        CloudKitManager.sharedController.fetchRecordsWithType(Conversation.typeKey, predicate: NSPredicate(value: true), recordFetchedBlock: { (record) in
            //
        }) { (records, error) in
            guard let records = records else {completion() ; return}
            self.conversations = records.flatMap({Conversation(ckRecord: $0)})
            print("Conversations Loaded")
            self.getUserNamesFromConversation(self.conversations, completion: {
                completion()
            })
            completion()
        }
    }
    
    func getUserNamesFromConversation(conversations: [Conversation], completion: () -> Void){
        for conversation in conversations {
            for user in conversation.users {
                let predicate = NSPredicate(format: "ReferenceKey == %@", user.recordID)
                CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
                    guard let user = User(ckRecord: record) else {
                        print("Can't convert to User")
                        completion()
                        return
                    }
                    conversation.userz.append(user)
                    print("User added sucessfully. \(record.recordID)")
                    }, completion: { (records, error) in
                        completion()
                })
            }
            completion()
        }
    }
    
    
    // MARK: - MESSAGE FUNCTIONS
    
    func sendNewMessage(text: String) {
        guard let sender = UserController.sharedController.loggedInUserCustomModelReference,
            let conversation = ConversationController.sharedController.currentConversationReference else {
                print("There was either a conversation reference or user reference not made")
                return
        }
        let newMessage = Message(text: text, conversation: conversation, sender: sender, timestamp: NSDate())
        self.messagesInConversation.append(newMessage)
        CloudKitManager.sharedController.saveRecord(newMessage.ckRecord) { (record, error) in
            guard record != nil else {
                print("There was a problem saving the new Message in iCloud")
                return
            }
            print("The Message was saved to icloud")
        }
    }
    
    
    func loadMessagesFromConversation(conversationReference: CKReference, completion: () -> Void){
        let predicate = NSPredicate(format: "ConversationKey == %@", conversationReference)
        CloudKitManager.sharedController.fetchRecordsWithType(Message.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            //completion
        }) { (records, error) in
            guard let records = records else {
                print("There was no messages")
                completion()
                return
            }
            self.messagesInConversation = records.flatMap({Message(ckRecord: $0)})
        }
    }
    
    
    
    
    
    
    
    
}