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

    let users: [CKReference]
    let timestamp: NSDate
    
    init(users: [CKReference], timestamp: NSDate){
        self.users = users
        self.timestamp = timestamp
        
    }
    
    
}