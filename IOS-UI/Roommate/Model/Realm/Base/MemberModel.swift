//
//  MemberModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/13/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Realm
class MemberModel: BaseModel {
//    let userId = RealmOptional<Int>()
//    let roleId = RealmOptional<Int>()
    @objc dynamic var userId = 0
    @objc dynamic var roleId = 0
    @objc dynamic var username = ""
    
    public convenience init(userId: Int?, roleId: Int?, username: String!) {
        self.init()
        self.userId = userId!
        self.roleId = roleId!
        self.username = username
    }
    
    //MARK: ObjectMapper
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map){
        super.mapping(map: map)
        userId <- map["userId"]
        roleId <- map["roleId"]
        username <- map["username"]
    }
    
    
    //MARK: Object
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override class func primaryKey() -> String? {
        return "userId"
    }
}
