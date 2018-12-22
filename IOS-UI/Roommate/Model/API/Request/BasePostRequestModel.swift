//
//  BasePostResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/25/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class BasePostResquestModel:Mappable{
    var postId:Int = 0
    var userId:Int!
    var phoneContact:String!
    var minPrice: Float!

    init(){
        self.userId = DBManager.shared.getSingletonModel(ofType: UserModel.self)!.userId
        self.minPrice = 0
        self.phoneContact = ""
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        postId <- map["postId"]
        userId <- map["userId"]
        phoneContact <- map["phoneContact"]
        minPrice <- map["minPrice"]
        
    }

}
