//
//  UserModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/8/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class UserModel:Object{
    
    @objc dynamic var userId = 0
    @objc dynamic var username:String?
    @objc dynamic var password:String?
    @objc dynamic var email:String?
    @objc dynamic var fullname:String?
    @objc dynamic var imageProfile:String?
    @objc dynamic var dob:Date?
    @objc dynamic var phone:String?
    @objc dynamic var gender = 1
    @objc dynamic var roleId = 4
    @objc dynamic var suggestSettingModel:SuggestSettingModel?

    init(userMappedModel:UserMappableModel) {
        super.init()
        self.userId = userMappedModel.userId
        self.username = userMappedModel.username
        self.password = userMappedModel.password
        self.email = userMappedModel.email
        self.fullname = userMappedModel.fullname
        self.imageProfile = userMappedModel.imageProfile
        self.dob = userMappedModel.dob
        self.phone = userMappedModel.phone
        self.gender = userMappedModel.gender
        self.roleId = userMappedModel.roleId
        if let suggestSettingMappedModel = userMappedModel.suggestSettingMappedModel{
            self.suggestSettingModel =  SuggestSettingModel(suggestSettingMappedModel: suggestSettingMappedModel)
        }
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
