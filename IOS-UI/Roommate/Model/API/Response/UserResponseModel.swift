//
//  UserResponeModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/17/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
class UserResponseModel: Mappable {
    var userId = 0
    var username:String?
    var email:String?
    var fullname:String?
    var imageProfile:String?
    var dob:Date?
    var phone:String?
    var gender = 1
    var roleId = 4
    var avgBehaviourRate = 0.0
    var avgLifeStyleRate = 0.0
    var avgPaymentRate = 0.0
    var userRateResponseModels:[UserRateResponseModel]?
    var suggestSettingMappedModel:SuggestSettingMappableModel?
    
    init() {
        
    }
    
    public init(userModel:UserModel){
        self.userId = userModel.userId
        self.username = userModel.username
        self.roleId = userModel.roleId
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
    public init(userId: Int = 0, username: String?, email: String?, fullname: String?, imageProfile: String?, dob: Date?, phone: String?, gender: Int, userRateResponseModels:[UserRateResponseModel]?,suggestSettingMappedModel: SuggestSettingMappableModel?) {
        self.userId = userId
        self.username = username
        self.email = email
        self.fullname = fullname
        self.imageProfile = imageProfile
        self.dob = dob
        self.phone = phone
        self.gender = gender
        self.userRateResponseModels = userRateResponseModels
        self.suggestSettingMappedModel = suggestSettingMappedModel
    }
    
    
    //MARK: ObjectMapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        userId <- map["userId"]
        username <- map["username"]
        email <- map["email"]
        fullname <- map["fullname"]
        imageProfile <- map["imageProfile"]
        dob <- (map["dob"],CustomDateFormatTransform(formatString: Constants.USER_DATE_FORMAT))
        phone <- map["phone"]
        gender <- map["gender"]
        roleId <- map["roleId"]
        avgBehaviourRate <- map["avgBehaviourRate"]
        avgLifeStyleRate <- map["avgLifeStyleRate"]
        avgPaymentRate <- map["avgPaymentRate"]
        userRateResponseModels <- map["userRateResponseModels"]
        suggestSettingMappedModel <- map["userSuggestSettingModel"]
    }
}
