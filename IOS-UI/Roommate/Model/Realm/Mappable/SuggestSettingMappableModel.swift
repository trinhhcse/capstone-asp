//
//  SuggestSettingMappedModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/23/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class SuggestSettingMappableModel: Mappable {
    //default send nil for backend
    var utilities:[Int]?
    var districts:[Int]?
    var price:[Float]?
    var userId:Int = 0
    
    init(){
        userId = DBManager.shared.getSingletonModel(ofType: UserModel.self)!.userId
        self.utilities = []
        self.districts = []
        self.price = []
        
    }
    
    convenience init(suggestSettingModel:SuggestSettingModel){
        self.init()
        self.utilities = Array(suggestSettingModel.utilities)
        self.districts = Array(suggestSettingModel.districts)
        self.price = Array(suggestSettingModel.price)
        self.userId =  suggestSettingModel.userId
    }
    
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        utilities <- map["utilities"]
        districts <- map["districts"]
        price <- map["price"]
        userId <- map["userId"]
    }
    
    
    

}
