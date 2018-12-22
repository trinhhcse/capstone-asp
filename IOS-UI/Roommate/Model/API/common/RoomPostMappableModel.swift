//
//  RoomPostMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class RoomPostMappableModel: BasePostMappableModel {
    var roomId:Int?
    var name:String!
    var numberPartner:Int = 1
    var genderPartner:Int = 0
    var postDescription:String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        roomId <- map["roomId"]
        name <- map["name"]
        numberPartner <- map["numberPartner"]
        genderPartner <- map["genderPartner"]
        postDescription <- map["description"]
        
    }
}
