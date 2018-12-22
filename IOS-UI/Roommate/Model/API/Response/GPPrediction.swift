//
//  GPPlaceResult.swift
//  Roommate
//
//  Created by TrinhHC on 10/26/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper

class GPPrediction: Mappable,Hashable,Equatable {
    var hashValue: Int{
        return place_id.hashValue
    }
    var address:String!
    var place_id:String!
    //MARK: Objectmapper
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        print("Call mapping(map: Map) for SearchRequestModel")
        address <- map["description"]
        place_id <- map["place_id"]
    }
    
    static func == (lhs: GPPrediction, rhs: GPPrediction) -> Bool {
        return lhs.place_id.elementsEqual(rhs.place_id)
    }
}
