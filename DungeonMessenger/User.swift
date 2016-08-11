//
//  User.swift
//  DungeonMessenger
//
//  Created by Ryan Plitt on 8/9/16.
//  Copyright © 2016 Ryan Plitt. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
    static let typeKey = "User"
    static let userNameKey = "UserName"
    static let raceNameKey = "RaceName"
    static let classNameKey = "ClassName"
    static let recordIDKey = "RecordID"
    
    var userName: String
    var raceName: String
    var className: String
    var recordID: CKReference
    
    init(userName: String, raceName: String, className: String, recordID: CKReference){
        self.userName = userName
        self.raceName = raceName
        self.className = className
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard ckRecord.recordType == User.typeKey else { return nil }
        guard let userName = ckRecord[User.userNameKey] as? String,
        let raceName = ckRecord[User.raceNameKey] as? String,
        let className = ckRecord[User.classNameKey] as? String else {return nil}
        let reference = CKReference(recordID: ckRecord.recordID, action: .DeleteSelf)
        self.init(userName: userName, raceName: raceName, className: className, recordID: reference)
    }
}