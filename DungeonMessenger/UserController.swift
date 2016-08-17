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
    
    
    // MARK: - Conversation Variables
    var loggedInUserICloudRecord: CKRecord?
    var loggedInUserModelObject: User? {
        guard let loggedInUserICloudRecord = loggedInUserICloudRecord else {
            print("There was no logged in user")
            return nil
        }
        return User(ckRecord: loggedInUserICloudRecord)
    }
    var loggedInUserAppleReference: CKReference?
    var loggedInUserCustomModelReference: CKReference?
    var contacts: [User] = []
    
    
    // MARK: - Message Variables
    var usersInMessage: [User] = [] {
        didSet{
            print(usersInMessage.count)
        }
    }

    static let sharedController = UserController()
    
    init(){
        
    }
    
    func getContacts(){
        CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, recordFetchedBlock: { (record) in
            //
            }) { (records, error) in
                guard let records = records else {
                    print("Unable to obtain the contact records. \(error?.localizedDescription)")
                    return
                }
                self.contacts = records.flatMap({User(ckRecord: $0)})
                print("Contacts Imported Sucessfully")
        }
    }
    
    func setCurrentUser(completion: (() -> Void)){
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else {
                print(error?.localizedDescription)
                completion()
                return
            }
            self.loggedInUserAppleReference = CKReference(recordID: record.recordID, action: .None)
            self.loggedInUserICloudRecord = record
            
            completion()
        }
    }
    
    
    func ObtainActiveLoggedInUserReference(completion: ((success: Bool) -> Void)?) {
        guard let loggedInUserReference = self.loggedInUserAppleReference else {
            print("No User Reference. ")
            completion?(success: false)
            return
        }
        let predicate = NSPredicate(format: "ReferenceKey == %@", loggedInUserReference)
        CloudKitManager.sharedController.fetchRecordsWithType(User.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            //
        }) { (records, error) in
            guard let records = records else {
                print("There was a problem. \(error?.localizedDescription)")
                completion?(success: false)
                return
            }
            guard let userRecord = records.first else {
                print("There was no record")
                completion?(success: false)
                return
            }
            self.loggedInUserCustomModelReference = CKReference(recordID: userRecord.recordID, action: .None)
            completion?(success: true)
        }
    }
    
    
    
    func saveNewUser(name: String, race: String, className: String) {
        let record = CKRecord(recordType: User.typeKey)
        
        record.setValue(name, forKey: User.userKey)
        record.setValue(race, forKey: User.raceKey)
        record.setValue(className, forKey: User.classKey)
        
        CloudKitManager.sharedController.fetchLoggedInUserRecord { (LoggedInRecord, error) in
            guard let LoggedInRecord = LoggedInRecord else {
                print("Unable to acquire the logged in User's iCloud. \(error?.localizedDescription)")
                return
            }
            let reference = CKReference(recordID: LoggedInRecord.recordID, action: .None)
            
            record.setValue(reference, forKey: User.referenceKey)
            
            CloudKitManager.sharedController.saveRecord(record) { (record, error) in
                if error != nil {
                    print("Error. \(error?.localizedDescription)")
                }
                if record != nil {
                    print("The record was saved successfully")
                }
            }
        }
    }
}