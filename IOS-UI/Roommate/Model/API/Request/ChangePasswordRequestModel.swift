//
//  ChangePasswordRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/9/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class ChangePasswordRequestModel: Mappable {
    var userId:Int!
    var oldPassword:String!
    var newPassword:String!
    


    public init(userId: Int!, oldPassword: String!, newPassword: String!) {
        self.userId = userId
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }
    init() {
        userId = 0
        oldPassword = ""
        newPassword = ""
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        oldPassword <- map["oldPassword"]
        newPassword <- map["newPassword"]
    }
    
}
