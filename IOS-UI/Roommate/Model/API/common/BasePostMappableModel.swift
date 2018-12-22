//
//  BasePostMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class BasePostMappableModel: Mappable {

    
    var postId: Int = 0
    var phoneContact:String!
    var date: Date?
    var userResponseModel: UserResponseModel?
    var userId:Int!
    var isFavourite: Bool?
    var favouriteId:Int?
    var minPrice: Float!
    var hashValue: Int{
        return self.postId
    }
    
    init(){
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        postId <- map["postId"]
        phoneContact <- map["phoneContact"]
        date <- (map["date"],DateTransform())
        userResponseModel <- map["userResponseModel"]
        isFavourite <- map["favourite"]
        favouriteId <- map["favouriteId"]
        minPrice <- map["minPrice"]
        userId <- map["userId"]
    }
    
    static func ==(lhs:BasePostMappableModel,rhs:BasePostMappableModel)->Bool{
        return lhs.postId == rhs.postId
    }
}
