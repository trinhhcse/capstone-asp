
//
//  FavoriteRequestModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/22/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class BookmarkRequestModel: Mappable {
    var userId = 0
    var postId = 0
    init(){
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        postId <- map["postId"]
    }
    
    
}
