//
//  UserRateMappedModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/24/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class UserRateMappableModel: Mappable {
    var id:Int = 0
    var behaviourRate:Double?
    var lifeStyleRate:Double?
    var paymentRate:Double?
    var date:Date?
    var comment:String?
    var userId:Int!
    var ownerId:Int!
    
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        behaviourRate <- map["behaviourRate"]
        lifeStyleRate <- map["lifeStyleRate"]
        paymentRate <- map["paymentRate"]
        date <- (map["date"],CustomDateFormatTransform(formatString: Constants.DATE_FORMAT))
        comment <- map["comment"]
        userId <- map["userId"]
        ownerId <- map["ownerId"]
    }
    
}
