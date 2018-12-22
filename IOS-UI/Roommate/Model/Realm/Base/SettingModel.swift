//
//  SettingModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/31/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Realm
class SettingModel: Object {
    @objc dynamic var id = 1
    @objc dynamic var cityId = 45
    var longitude = RealmOptional<Double>()
    var latitude = RealmOptional<Double>()

    convenience init(settingMappableModel:SettingMappableModel){
        self.init()
        self.cityId = settingMappableModel.cityId
        self.longitude.value = settingMappableModel.longitude
        self.latitude.value = settingMappableModel.latitude
    }

    //MARK: Object
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
}
