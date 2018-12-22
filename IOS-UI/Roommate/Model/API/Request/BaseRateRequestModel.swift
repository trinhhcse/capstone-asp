//
//  BaseRateRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class BaseRateRequestModel: Mappable {
    var comment:String!
    var userId:Int!
    public init(comment: String!, userId: Int!) {
        self.comment = comment
        self.userId = userId
        
    }
    
    init() {
        self.comment = ""
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment <- map["comment"]
        userId <- map["userId"]
        
    }
}
