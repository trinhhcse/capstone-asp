//
//  UserRateRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class UserRateRequestModel: BaseRateRequestModel {
    var behaviourRate:Double!
    var lifeStyleRate:Double!
    var paymentRate:Double!
    var ownerId:Int!
    public init(behaviourRate: Double!, lifeStyleRate: Double!, paymentRate: Double!, comment: String!, userId: Int!, ownerId: Int!) {
        super.init(comment: comment, userId: userId)
        self.behaviourRate = behaviourRate
        self.lifeStyleRate = lifeStyleRate
        self.paymentRate = paymentRate
        self.ownerId = ownerId
    }
    override init() {
        super.init()
        self.behaviourRate = 0.0
        self.lifeStyleRate = 0.0
        self.paymentRate = 0.0
    }
    convenience init(userId:Int,ownerId:Int){
        self.init()
        self.userId = userId
        self.ownerId = ownerId
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map:map)
        behaviourRate <- map["behaviourRate"]
        lifeStyleRate <- map["lifeStyleRate"]
        paymentRate <- map["paymentRate"]
        ownerId <- map["ownerId"]
    }
}
