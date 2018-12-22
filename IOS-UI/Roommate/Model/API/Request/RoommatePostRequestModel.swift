//
//  RoommatePostResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class RoommatePostRequestModel:BasePostResquestModel {
    var utilityIds:[Int]!
    var maxPrice:Float?
    var districtIds:[Int]!
    var cityId:Int!

    override init(){
        super.init()
        utilityIds = []
        maxPrice = 0
        districtIds = []
        cityId = 0
    }
    init(model:RoommatePostResponseModel){
        super.init()
        self.postId = model.postId!
        self.userId = model.userResponseModel?.userId
        self.cityId = model.cityId
        self.districtIds = model.districtIds
        self.utilityIds = model.utilityIds
        self.minPrice = model.minPrice
        self.maxPrice = model.maxPrice
        self.phoneContact = model.phoneContact
    }
    init(cityId:Int,suggestSettingMappableModel:SuggestSettingMappableModel,phoneContact:String){
        super.init()
        self.cityId = cityId
        self.districtIds = suggestSettingMappableModel.districts
        self.utilityIds = suggestSettingMappableModel.utilities
        self.minPrice = suggestSettingMappableModel.price!.first
        self.maxPrice = suggestSettingMappableModel.price!.last
        self.phoneContact = phoneContact
    }

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cityId <- map["cityId"]
        utilityIds <- map["utilityIds"]
        maxPrice <- map["maxPrice"]
        districtIds <- map["districtIds"]
    }
    
}
