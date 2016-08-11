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
    static let timestampKey = "Timestamp"
    static let senderKey = "SenderKey"
    static let conversationKey = "Conversation"
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Message.typeKey)
        record.setValue(text, forKey: Message.textKey)
        record.setValue(timestamp, forKey: Message.timestampKey)
        record.setValue(sender, forKey: Message.senderKey)
        record.setValue(conversation, forKey: Message.conversationKey)
        return record
    }
    
    let text: String
    let timestamp: NSDate
    let sender: CKReference
    let conversation: CKReference
    
    
    init(text: String, timestamp: NSDate = NSDate(), sender: CKReference = CKReference(recordID: CloudKitManager.sharedController.currentUserRecordID, action: .DeleteSelf), conversation: CKReference){
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
        self.conversation = conversation
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard ckRecord.recordType == Message.typeKey else {return nil}
        guard let text = ckRecord[Message.textKey] as? String,
        let timestamp = ckRecord[Message.timestampKey] as? NSDate,
        let sender = ckRecord[Message.senderKey] as? CKReference,
            let conversation = ckRecord[Message.conversationKey] as? CKReference else {return nil}
        self.init(text: text, timestamp: timestamp, sender: sender, conversation: conversation)
    }
}