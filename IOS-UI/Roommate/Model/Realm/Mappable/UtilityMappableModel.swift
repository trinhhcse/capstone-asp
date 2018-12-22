
//
//  UtilityMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift
import Realm
import ObjectMapper_Realm
class UtilityMappableModel:Mappable,Equatable,Hashable,NSCopying {
    var utilityId = 0
    var name = ""
    var quantity = 1
    var brand = ""
    var utilityDescription = ""

    var hashValue: Int{
        return self.utilityId.hashValue
    }

    init (){}

    init(utilityId: Int){
        self.utilityId = utilityId
    }
    public init(utilityModel:UtilityModel) {
        self.utilityId = utilityModel.utilityId
        self.name = utilityModel.name
    }
    public init(roomUtilityModel:RoomUtilityModel) {
        self.utilityId = roomUtilityModel.utilityId
        self.name = roomUtilityModel.name
        self.quantity = roomUtilityModel.quantity
        self.brand = roomUtilityModel.brand
        self.utilityDescription = roomUtilityModel.utilityDescription
    }
    public init(utilityId: Int, name: String, quantity: Int, brand: String, utilityDescription: String) {
        self.utilityId = utilityId
        self.name = name
        self.quantity = quantity
        self.brand = brand
        self.utilityDescription = utilityDescription
    }

    func copy(with zone: NSZone?) -> Any {
        let utilityModel = UtilityMappableModel(utilityId: utilityId, name: name, quantity: quantity, brand: brand, utilityDescription: utilityDescription)
        return utilityModel
    }
    
    required  init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        utilityId <- map["utilityId"]
        name <- map["name"]
        quantity <- map["quantity"]
        brand <- map["brand"]
        utilityDescription <- map["description"]
    }


    
    static func ==(lhs: UtilityMappableModel, rhs: UtilityMappableModel)->Bool{
        return lhs.utilityId == rhs.utilityId
    }
}
