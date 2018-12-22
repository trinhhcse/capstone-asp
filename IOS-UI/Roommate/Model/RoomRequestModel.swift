//
//  Room.swift
//  Roommate
//
//  Created by TrinhHC on 9/24/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
class RoomRequestModel{
    
    var roomId:Int = 0
    private String name:String
    private Double price:Integer
    private Integer area:Integer
    private String address:String
    private Integer maxGuest:Int
    private Date dateCreated:Int
    private Integer currentNumber:Int
    private String description;
    private int status;
    private int userId;
    private int cityId;
    private int districtId;
    private Double longitude;
    private Double latitude;
    private List<UtilityRequestModel> utilities;
    private List<String> imageUrls;

    public init(roomId: Int = 0, name: String, price: Float, area: Int, address: String, maxGuest: Int, date_create: Date, current_member: Int, description: String?, status: StatusModel, city: CityModel, district: DistrictModel, image: [ImageModel], utilities: [UtilityMappableModel], users: [User]?, requiredGender: Int) {
        self.roomId = roomId
        self.name = name
        self.price = price
        self.area = area
        self.address = address
        self.maxGuest = maxGuest
        self.date = date_create
        self.currentMember = current_member
        self.description = description
        self.status = status
        self.city = city
        self.district = district
        self.image = image
        self.utilities = utilities
        self.users = users
        self.requiredGender = requiredGender
    }



}
