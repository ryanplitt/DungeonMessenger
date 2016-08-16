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
    static let userKey = "UserName"
    static let raceKey = "RaceName"
    static let classKey = "ClassName"
    static let referenceKey = "ReferenceKey"
    
    let userName: String
    let raceName: String
    let className: String
    let reference: CKReference
    
    //    var ckRecord: CKRecord {
    //        let record = CKRecord(recordType: User.typeKey)
    //
    //        record.setValue(userName, forKey: User.userKey)
    //        record.setValue(raceName, forKey: User.raceKey)
    //        record.setValue(className, forKey: User.classKey)
    //
    //
    //        return record
    //    }
    
    init(userName: String, raceName: String, className: String, reference: CKReference) {
        self.userName = userName
        self.raceName = raceName
        self.className = className
        self.reference = reference
    }
    
    init?(ckRecord: CKRecord) {
        guard let userName = ckRecord[User.userKey] as? String,
            let raceName = ckRecord[User.raceKey] as? String,
            let className = ckRecord[User.classKey] as? String,
            let reference = ckRecord[User.referenceKey] as? CKReference else {return nil}
        self.userName = userName
        self.raceName = raceName
        self.className = className
        self.reference = reference
    }
    
}