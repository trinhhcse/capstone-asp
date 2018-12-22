//
//  MemberRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class MemberRequestModel: Mappable {
    
    var userId:Int?
    var roleId:Int?

    public init(userId: Int?, roleId: Int?) {
        self.userId = userId
        self.roleId = roleId
    }
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        roleId <- map["roleId"]
    }
    

}
