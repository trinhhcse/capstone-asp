//
//  UploadImageModel.swift
//  Roommate
//
//  Created by TrinhHC on 10/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class UploadImageModel:Equatable,Hashable {
    var name:String?
    var image:UIImage?
    var linkUrl:String?
    var hashValue: Int{
        return name!.hashValue
    }

    public init() {
    }
    public init(name: String?) {
        self.name = name
    }
    
    public init(name: String?, image: UIImage?, linkUrl: String?) {
        self.name = name
        self.image = image
        self.linkUrl = linkUrl
    }
    public convenience init(name: String?, image: UIImage?) {
        self.init(name: name, image: image, linkUrl: nil)
    }
    public convenience init(name: String?, linkUrl: String?) {
        self.init(name: name, image: nil, linkUrl: linkUrl)
    }
    static func ==(lhs:UploadImageModel,rhs:UploadImageModel)->Bool{
        return lhs.name == rhs.name
    }
}
