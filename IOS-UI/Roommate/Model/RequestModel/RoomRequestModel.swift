//
// Created by TrinhHC on 10/5/18.
// Copyright (c) 2018 TrinhHC. All rights reserved.
//

import Foundation
class BaseRoomRequestModel{
    var room_id:Int = 0
    var name:String
    var price:Float
    var area:Int
    var address:String
    var max_guest:Int
    var current_member:Int
    var description:String?
    var status:StatusModel
    var district:DistrictModel
    var image:[ImageModel]
    var utilities:[UtilityMappableModel]
    var users:[User]?
    var requiredGender:Int

    public init(){
        self.room_id = 0
        self.name = ""
        self.price = 0.0
        self.area = 0
        self.address = ""
        self.max_guest = 0
        self.current_member = 0
        self.description = ""
        self.status = status
        self.district = district
        self.image = image
        self.utilities = utilities
        self.users = users
        self.requiredGender = requiredGender
    }
    
    public init(room_id: Int = 0, name: String, price: Float, area: Int, address: String, max_guest: Int, date_create: Date, current_member: Int, description: String?, status: StatusModel, district: DistrictModel, image: [ImageModel], utilities: [UtilityMappableModel], users: [User]?, requiredGender: Int) {
        self.room_id = room_id
        self.name = name
        self.price = price
        self.area = area
        self.address = address
        self.max_guest = max_guest
        self.date_create = date_create
        self.current_member = current_member
        self.description = description
        self.status = status
        self.district = district
        self.image = image
        self.utilities = utilities
        self.users = users
        self.requiredGender = requiredGender
    }
}
