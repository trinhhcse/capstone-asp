//
//  ImageModel.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class ImageModel{
    var image_id:Int?
    var link_url:String?

    public init(id: Int, link_url: String) {
        self.image_id = id
        self.link_url = link_url
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image_id <- map["image_id"]
        link_url <- map["link_url"]
    }
    
    
}
