//
//  Conversation.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CloudKit

class Conversation {
    
    static let typeKey = "Conversation"
    static let usersKey = "Users"
    static let timestampKey = "Timestamp"
    
    var users: [CKReference]
    var timestamp: NSDate
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Conversation.typeKey)
        record.setValue(users, forKey: Conversation.usersKey)
        record.setValue(timestamp, forKey: Conversation.timestampKey)
        return record
    }
    
    init(users: [CKReference], timestamp: NSDate = NSDate()){
        self.users = users
        self.timestamp = timestamp
    }
    
    convenience required init?(ckRecord: CKRecord){
        guard Conversation.typeKey == ckRecord.recordType else {
            print("Error converting. CKType was not a Conversation.")
            return nil
        }
        guard let timestamp = ckRecord.creationDate,
            let users = ckRecord["users"] as? [CKReference] else {
                print("Error converting the Users of the CKRecord")
                return nil
        }
        self.init(users: users, timestamp: timestamp)
    }
}