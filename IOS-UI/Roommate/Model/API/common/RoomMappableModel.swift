//
//  RoomMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class RoomMappableModel: Mappable,NSCopying,Equatable,Hashable {
    var roomId:Int = 0
    var name:String = ""
    var price:Int = 0
    var area:Int = 0
    var address:String = ""
    var maxGuest:Int = 0
    var userId:Int = 0
    var cityId:Int = 0
    var districtId:Int = 0
    var date:Date?
    var statusId:Int = 0
    var roomDescription:String?
    var phoneNumber:String = ""
    var utilities:[UtilityMappableModel]  = []
    var imageUrls:[String] = []
    var members:[MemberResponseModel]? = []
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    var avarageSecurity:Double!
    var avarageLocation:Double!
    var avarageUtility:Double!
    var roomRateResponseModels:[RoomRateResponseModel]?

    public init(roomId: Int = 0, name: String = "", price: Int = 0, area: Int = 0, address: String = "", maxGuest: Int = 0, userId: Int = 0, cityId: Int = 0, districtId: Int = 0, date: Date?, statusId: Int = 0, roomDescription: String?, phoneNumber: String = "", utilities: [UtilityMappableModel]  = [], imageUrls: [String] = [], members: [MemberResponseModel]? = [], longitude: Double = 0.0, latitude: Double = 0.0, avarageSecurity: Double!, avarageLocation: Double!, avarageUtility: Double!, roomRateResponseModels: [RoomRateResponseModel]?) {
        self.roomId = roomId
        self.name = name
        self.price = price
        self.area = area
        self.address = address
        self.maxGuest = maxGuest
        self.userId = userId
        self.cityId = cityId
        self.districtId = districtId
        self.date = date
        self.statusId = statusId
        self.roomDescription = roomDescription
        self.phoneNumber = phoneNumber
        self.utilities = utilities
        self.imageUrls = imageUrls
        self.members = members
        self.longitude = longitude
        self.latitude = latitude
        self.avarageSecurity = avarageSecurity
        self.avarageLocation = avarageLocation
        self.avarageUtility = avarageSecurity
        self.roomRateResponseModels = roomRateResponseModels
    }
    
    


    
    var hashValue: Int{
        return roomId.hashValue
    }
    
    init(roomId:Int){
        self.roomId = roomId
    }
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        roomId <- map["roomId"]
        name <- map["name"]
        price <- map["price"]
        area <- map["area"]
        address <- map["address"]
        maxGuest <- map["maxGuest"]
//        currentMember <- map["currentMember"]
        userId <- map["userId"]
        cityId <- map["cityId"]
        districtId <- map["districtId"]
        date <- (map["dateCreated"],CustomDateFormatTransform(formatString: Constants.DATE_FORMAT))
        statusId <- map["statusId"]
        roomDescription <- map["description"]
        phoneNumber <- map["phoneNumber"]
        utilities <- map["utilities"]
        imageUrls <- map["imageUrls"]
        members <- map["members"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        avarageSecurity <- map["avarageSecurity"]
        avarageLocation <- map["avarageLocation"]
        avarageUtility <- map["avarageUtility"]
        if members == nil{
            members = []
        }
        roomRateResponseModels <- map["roomRateResponseModels"]
        if roomRateResponseModels == nil{
            roomRateResponseModels = []
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let room = RoomMappableModel(roomId: self.roomId, name: self.name, price: self.price, area: self.area, address: self.address, maxGuest: self.maxGuest, userId: self.userId, cityId: self.cityId, districtId: self.districtId, date: self.date, statusId: self.statusId, roomDescription: self.roomDescription,phoneNumber:self.phoneNumber, utilities: self.utilities.copiedElements(), imageUrls: self.imageUrls.copiedElements(), members: self.members?.copiedElements(),longitude: self.longitude,latitude:self.latitude ,avarageSecurity: self.avarageSecurity, avarageLocation: self.avarageLocation, avarageUtility: self.avarageUtility,roomRateResponseModels:self.roomRateResponseModels)
        
        return room
    }
    static func == (lhs: RoomMappableModel, rhs: RoomMappableModel) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    
    
}
