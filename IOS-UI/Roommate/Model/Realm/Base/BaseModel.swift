//
//  BaseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Realm
class BaseModel:Object,Mappable,NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let base = BaseModel()
        return base
    }
    required convenience init?(map: Map) {
        self.init()
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

    func mapping(map: Map) {

    }
}
