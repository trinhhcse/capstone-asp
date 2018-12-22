//
//  RoommatePostResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class RoommatePostResponseModel:BasePostResponseModel {
    var utilityIds:[Int]!
    var maxPrice:Float!
    var districtIds:[Int]!
    var cityId:Int!
    var model:RoommatePostRequestModel!{
        didSet{
            self.postId = model.postId
            self.cityId = model.cityId
            self.districtIds = model.districtIds
            self.utilityIds = model.utilityIds
            self.minPrice = model.minPrice
            self.maxPrice = model.maxPrice
            self.phoneContact = phoneContact
            
        }
    
    }
    override init(postId:Int){
        super.init(postId: postId)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        utilityIds <- map["utilityIds"]
        maxPrice <- map["maxPrice"]
        districtIds <- map["districtIds"]
        cityId <- map["cityId"]
    }
    
}
