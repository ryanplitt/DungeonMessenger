
//
//  UserController.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let ckManager = CloudKitManager()
    static let sharedController = UserController()
    
    var currentUserReference: CKReference?
    
    var usersInConversation: [User]? = [] {
        didSet {
            print(usersInConversation?.count)
        }
    }
    
    var usersInConversationReferences: [CKReference]? = []
    
    var contactsList: [User] = [] {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("contactsUpdated", object: self)
            print("contactsUpdated")
        }
    }
    
    
    func getContacts() {
            CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, recordFetchedBlock: nil) { (records, error) in
                guard let records = records else {return}
                for record in records {
                    guard let user = User(ckRecord: record) else {return}
                    self.contactsList.append(user)
                }
        }
    }
    
    func createUser(userName: String, raceName: String, className: String, completion: () -> Void) {
        
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { return }
            
            let newRecord = CKRecord(recordType: User.typeKey)
            newRecord.setValue(userName, forKey: User.userNameKey)
            newRecord.setValue(raceName, forKey: User.raceNameKey)
            newRecord.setValue(className, forKey: User.classNameKey)
            newRecord.setValue(CKReference(recordID: record.recordID, action: .None), forKey: User.referenceKey)
            CloudKitManager.sharedController.saveRecord(newRecord, completion: { (record, error) in
                if error != nil {
                    print("Error saving new user record to CloudKit: \(error?.localizedDescription)")
                }
                if record != nil {
                    print("created new user successfully")
                }
                completion()
            })
        }
        completion()
    }
    
    func fetchCurrentUser(completion: (success: Bool) -> Void) {
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { completion(success: false);  return }
            let reference = CKReference(recordID: record.recordID, action: .None)
            
            let predicate = NSPredicate(format: "Reference == %@", reference)
            CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
                //
            }) { (records, error) in
                guard let record = records?.first else { completion(success: false); return }
                self.currentUserReference = CKReference(recordID: record.recordID, action: .None)
                completion(success: true)
            }
        }
    }
    
    func loadUsersInConversationReferences(completion: (() -> Void)?) {
        var userReferences: [CKReference] = []
        guard let users = UserController.sharedController.usersInConversation else {return}
        for user in users {
            userReferences.append(user.reference)
        }
        self.usersInConversationReferences = userReferences
        completion?()
    }
}