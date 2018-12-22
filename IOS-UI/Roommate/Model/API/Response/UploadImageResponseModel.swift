//
//  UploadImageResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class UploadImageResponseModel: Mappable {
    var name:String!
    var imageUrl:String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        imageUrl <- map["imageUrl"]
    }
}
