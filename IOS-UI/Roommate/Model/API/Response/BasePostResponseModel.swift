//
//  BasePostResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/25/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class BasePostResponseModel:Mappable,Equatable,Hashable{
    var postId: Int!
    var phoneContact:String!
    var date: Date?
    var userResponseModel: UserResponseModel?
    var isFavourite: Bool?
    var favouriteId:Int?
    var minPrice: Float!
    var hashValue: Int{
        return self.postId!
    }
    
    init(postId:Int){
        self.postId = postId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        postId <- map["postId"]
        phoneContact <- map["phoneContact"]
        date <- (map["date"],CustomDateFormatTransform(formatString: Constants.DATE_FORMAT))
        userResponseModel <- map["userResponseModel"]
        isFavourite <- map["favourite"]
        favouriteId <- map["favouriteId"]
        minPrice <- map["minPrice"]
        
    }
    
    static func ==(lhs:BasePostResponseModel,rhs:BasePostResponseModel)->Bool{
        return lhs.postId == rhs.postId
    }
}
