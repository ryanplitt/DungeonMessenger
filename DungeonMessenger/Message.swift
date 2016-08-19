//
//  Message.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CloudKit


class Message {
    
    static let typeKey = "Message"
    static let textKey = "Text"
    static let conversationKey = "ConversationKey"
    static let senderKey = "SenderKey"
    static let timestampKey = "Timestamp"
    
    let text: String
    let conversation: CKReference
    let sender: CKReference
    let timestamp: NSDate
    var senderUser: User?
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Message.typeKey)
        
        record.setValue(text, forKey: Message.textKey)
        record.setValue(conversation, forKey: Message.conversationKey)
        record.setValue(sender, forKey: Message.senderKey)
        record.setValue(timestamp, forKey: Message.timestampKey)
        
        return record
    }
    
    init(text: String, conversation: CKReference, sender: CKReference, timestamp: NSDate) {
        self.text = text
        self.conversation = conversation
        self.sender = sender
        self.timestamp = timestamp
    }
    
    convenience init?(ckRecord: CKRecord) {
        //        guard ckRecord.recordType == Message.typeKey,
        guard let text = ckRecord[Message.textKey] as? String,
            let conversation = ckRecord[Message.conversationKey] as? CKReference,
            let sender = ckRecord[Message.senderKey] as? CKReference,
            let timestamp = ckRecord[Message.timestampKey] as? NSDate else {
                print("Unable to convert to Message.")
                return nil
        }
        self.init(text: text, conversation: conversation, sender: sender, timestamp: timestamp)
    }
    
}