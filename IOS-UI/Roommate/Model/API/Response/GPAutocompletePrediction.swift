//
//  GPAutocompletePrediction.swift
//  Roommate
//
//  Created by TrinhHC on 10/26/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
class GPAutocompletePrediction: Mappable {
    var predictions:[GPPrediction]?
    var status:String?
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        predictions <- map["predictions"]
        status <- map["status"]
    }
}
