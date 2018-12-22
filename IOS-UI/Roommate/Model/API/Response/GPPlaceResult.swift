//
//  GPPlaceResult.swift
//  Roommate
//
//  Created by TrinhHC on 10/26/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class GPPlaceResult: Mappable {
    var status:String!
    var lat:Double!
    var lng:Double!
    //MARK: Objectmapper
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        lat <- map["result.geometry.location.lat"]
        lng <- map["result.geometry.location.lng"]
    }
}
