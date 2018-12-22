//
//  RoomRateMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class RoomRateRequestModel: BaseRateRequestModel {
    var securityRate:Double!
    var locationRate:Double!
    var utilityRate:Double!
    var roomId:Int!

    public init(securityRate: Double!, locationRate: Double!, utilityRate: Double!,comment: String!, userId: Int!, roomId:Int!) {
        super.init(comment: comment, userId: userId)
        self.securityRate = securityRate
        self.locationRate = locationRate
        self.utilityRate = utilityRate
        self.roomId = roomId
    }
    override init() {
        super.init()
        self.securityRate = 0.0
        self.locationRate = 0.0
        self.utilityRate = 0.0
    }
    convenience init(userId:Int,roomId:Int){
        self.init()
        self.userId = userId
        self.roomId = roomId
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map:map)
        securityRate <- map["securityRate"]
        locationRate <- map["locationRate"]
        utilityRate <- map["utilityRate"]
        roomId <- map["roomId"]
    }
}
