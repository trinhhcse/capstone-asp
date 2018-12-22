//
//  SearchRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class SearchRequestModel: Mappable {
    var address:String?
    var latitude:Double?
    var longitude:Double?
    var userId:Int?
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        userId <- map["userId"]
    }
    init() {
        userId = DBManager.shared.getUser()?.userId
    }
}
