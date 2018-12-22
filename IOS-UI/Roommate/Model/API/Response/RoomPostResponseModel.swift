//
//  RoomPostResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/17/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class RoomPostResponseModel:BasePostResponseModel {
    var name:String?
    var  area: Int?
    var address: String?
    var utilities: [UtilityMappableModel]!
    var imageUrls: [String]?
    var numberPartner, genderPartner: Int!
    var postDesription: String?
    var avarageSecurity = 0.0
    var avarageLocation = 0.0
    var avarageUtility = 0.0
    var roomRateResponseModels:[RoomRateResponseModel]?
    var model:RoomPostRequestModel!{
        didSet{
            self.postId = model.postId
            self.minPrice = model.minPrice
            self.phoneContact = model.phoneContact
            self.name = model.name
            self.numberPartner = model.numberPartner
            self.genderPartner = model.genderPartner
            self.postDesription = model.postDescription
            
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
        name <- map["name"]
        area <- map["area"]
        address <- map["address"]
        utilities <- map["utilities"]
        imageUrls <- (map["imageUrls"])
        numberPartner <- map["numberPartner"]
        genderPartner <- map["genderPartner"]
        postDesription <- map["description"]
        avarageSecurity <- map["avarageSecurity"]
        avarageLocation <- map["avarageLocation"]
        avarageUtility <- map["avarageUtility"]
        roomRateResponseModels <- map["roomRateResponseModels"]
    }
    
    
}
