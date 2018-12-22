//
//  SearchResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class SearchResponseModel: Mappable {
    var roomPostResponseModel:[RoomPostResponseModel]?
    var nearByRoomPostResponseModels:[RoomPostResponseModel]?
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        roomPostResponseModel <- map["roomPostResponseModel"]
        nearByRoomPostResponseModels <- map["nearByRoomPostResponseModels"]
    }
}
