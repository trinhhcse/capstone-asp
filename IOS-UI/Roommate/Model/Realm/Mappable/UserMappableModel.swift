//
//  UserMappedModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/24/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class UserMappableModel: Mappable {
    var userId = 0
    var username:String?
    var password:String?
    var email:String?
    var fullname:String?
    var imageProfile:String?
    var dob:Date?
    var phone:String?
    var gender = 1
    var roleId = 4
    var userRateList:[UserRateMappableModel]?
    var suggestSettingMappedModel:SuggestSettingMappableModel?
    
    init() {
        
    }
    public init(userModel:UserModel){
        self.userId = userModel.userId
        self.username = userModel.username
        self.roleId = userModel.roleId
        self.password = userModel.password
        self.email = userModel.email
        self.fullname = userModel.fullname
        self.imageProfile = userModel.imageProfile
        self.dob = userModel.dob
        self.phone = userModel.phone
        self.gender = userModel.gender
        if let suggestSettingModel  = userModel.suggestSettingModel{
            self.suggestSettingMappedModel = SuggestSettingMappableModel(suggestSettingModel: suggestSettingModel)
        }
        
    }
    public init(userId: Int = 0, username: String?, password: String?, email: String?, fullname: String?, imageProfile: String?, dob: Date?, phone: String?, gender: Int, userRateList:[UserRateMappableModel]?,suggestSettingMappedModel: SuggestSettingMappableModel?) {
        self.userId = userId
        self.username = username
        self.password = password
        self.email = email
        self.fullname = fullname
        self.imageProfile = imageProfile
        self.dob = dob
        self.phone = phone
        self.gender = gender
        self.suggestSettingMappedModel = suggestSettingMappedModel
    }
    
    
    //MARK: ObjectMapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        userId <- map["userId"]
        username <- map["username"]
        password <- map["password"]
        email <- map["email"]
        fullname <- map["fullname"]
        imageProfile <- map["imageProfile"]
        dob <- (map["dob"],CustomDateFormatTransform(formatString: Constants.USER_DATE_FORMAT))
        phone <- map["phone"]
        gender <- map["gender"]
        roleId <- map["roleId"]
        userRateList <- map["userRateResponseModels"]
        suggestSettingMappedModel <- map["userSuggestSettingModel"]
    }
}
