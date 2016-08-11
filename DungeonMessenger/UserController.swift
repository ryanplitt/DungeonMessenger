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
    
    var currentUserCustomUserID: CKRecordID?
    var currentUserCloudKitReference: CKReference?
    
    init(){
        
    }
    
    var usersInConversation: [User]? = [] {
        didSet {
            print(usersInConversation?.count)
        }
    }
    
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
    
    func createUser(userName: String, raceName: String, className: String) {
        let record = CKRecord(recordType: User.typeKey)
        record.setValue(userName, forKey: User.userNameKey)
        record.setValue(raceName, forKey: User.raceNameKey)
        record.setValue(className, forKey: User.classNameKey)
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else {return}
            let reference = CKReference(recordID: record.recordID, action: .DeleteSelf)
            self.currentUserCustomUserID = reference.recordID
            record.setValue(reference, forKey: User.recordIDKey)
        }
        NSUserDefaults.standardUserDefaults().setValue(record.recordID.recordName, forKey: "currentUserRecordID")
        CloudKitManager.sharedController.saveRecord(record) { (record, error) in
            //
        }
    }
    
    func getCurrentUser() {
        guard let currentUserID = UserController.sharedController.currentUserCustomUserID else {return}
        let predicate = NSPredicate(format: "recordID == %@", currentUserID)
        CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            //
        }) { (records, error) in
            guard let record = records?.first else {return}
            UserController.sharedController.currentUserCloudKitReference = CKReference(recordID: record.recordID, action: .DeleteSelf)
        }
    }
}