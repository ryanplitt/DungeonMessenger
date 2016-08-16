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
    static let timestamp = "Timestamp"
    

    let users: [CKReference]
    let timestamp: NSDate
    
    init(users: [CKReference], timestamp: NSDate){
        self.users = users
        self.timestamp = timestamp
        
    }
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Conversation.typeKey)
        
        record.setValue(users, forKey: Conversation.usersKey)
        record.setValue(timestamp, forKey: Conversation.timestamp)
        
        return record
    }
    
    
    convenience init?(ckRecord: CKRecord){
        guard let users = ckRecord[Conversation.usersKey] as? [CKReference],
            let timestamp = ckRecord[Conversation.timestamp] as? NSDate else {return nil}
        
        self.init(users: users, timestamp: timestamp)
    }
    
}