//
//  DistrictModel.swift
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
class DistrictModel:BaseModel{
    @objc dynamic var districtId = 0
    @objc dynamic var name:String?
    @objc dynamic var cityId = 0

    //MARK: ObjectMapper
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map){
        super.mapping(map: map)
        districtId <- map["districtId"]
        name <- map["name"]
        cityId <- map["cityId"]
    }
    
    override class func primaryKey() -> String? {
        return "districtId"
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
