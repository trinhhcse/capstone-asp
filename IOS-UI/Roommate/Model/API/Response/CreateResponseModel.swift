//
//  CreateResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/24/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class CreateResponseModel: Mappable {
    var id:Int?
    //MARK: Objectmapper
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    init() {
        id = 0
    }
}
