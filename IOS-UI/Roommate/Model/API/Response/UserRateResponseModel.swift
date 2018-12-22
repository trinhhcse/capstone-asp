//
//  UserRateResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/6/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class UserRateResponseModel: BaseRateResponseModel {
    var behaviourRate:Double?
    var lifeStyleRate:Double?
    var paymentRate:Double?
    override init() {
        super.init()
        self.behaviourRate = 0.0
        self.lifeStyleRate = 0.0
        self.paymentRate = 0.0
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map:map)
        behaviourRate <- map["behaviourRate"]
        lifeStyleRate <- map["lifeStyleRate"]
        paymentRate <- map["paymentRate"]
    }
}
