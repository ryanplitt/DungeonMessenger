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
    static let referenceKey = "Reference"
    
    var userName: String
    var raceName: String
    var className: String
    var reference: CKReference
    
    init(userName: String, raceName: String, className: String, reference: CKReference){
        self.userName = userName
        self.raceName = raceName
        self.className = className
        self.reference = reference
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard ckRecord.recordType == User.typeKey else { return nil }
        guard let userName = ckRecord[User.userNameKey] as? String,
        let raceName = ckRecord[User.raceNameKey] as? String,
        let className = ckRecord[User.classNameKey] as? String,
        let reference = ckRecord[User.referenceKey] as? CKReference else {return nil}
        self.init(userName: userName, raceName: raceName, className: className, reference: reference)
    }
}