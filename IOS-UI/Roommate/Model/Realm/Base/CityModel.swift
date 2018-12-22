//
//  CityModel.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Realm
class CityModel:BaseModel {
    
    @objc dynamic var cityId = 45
    @objc dynamic var name:String?
    
    //MARK: ObjectMapper
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map){
        super.mapping(map: map)
        cityId <- map["cityId"]
        name <- map["name"]
        
    }
    
    override class func primaryKey() -> String? {
        return "cityId"
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

}
