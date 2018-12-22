
//
//  SearchRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/15/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//
import Foundation
import ObjectMapper
class FilterRequestModel: Mappable {
    //default send nil for backend
    var utilities:[Int]?
    var districts:[Int]?
    var price:[Float]?
    var gender:Int?
    var userId:Int?
    
    init(){
        
    }
    
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        utilities <- map["utilities"]
        districts <- map["districts"]
        price <- map["price"]
        gender <- map["gender"]
        userId <- map["userId"]
    }
    
    
}

