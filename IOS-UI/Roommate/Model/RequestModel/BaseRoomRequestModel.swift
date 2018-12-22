//
// Created by TrinhHC on 10/5/18.
// Copyright (c) 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseRoomRequestModel :Mappable{
    
    var roomId:Int?
    var name:String!
    var price:Float!
    var area:Int!
    var address:String!
    var phone:String!
    var maxGuest:Int!
    var description:String?
    
    var imageUrls:[String]!
    var utilities:[UtilityMappableModel]!
    var requiredGender:Int!
    var userId:Int?
    var districtId:Int?
    var cityId:Int?

    public init(roomId: Int?, name: String!, price: Float!, area: Int!, address: String!, phone: String!, maxGuest: Int!, description: String?, imageUrls: [String]!, utilities: [UtilityMappableModel]!, requiredGender: Int!, userId: Int, districtId: Int, cityId: Int) {
        self.roomId = roomId
        self.name = name
        self.price = price
        self.area = area
        self.address = address
        self.phone = phone
        self.maxGuest = maxGuest
        self.description = description
        self.imageUrls = imageUrls
        self.utilities = utilities
        self.requiredGender = requiredGender
        self.userId = userId
        self.districtId = districtId
        self.cityId = cityId
    }
    
//    private int roomId;
//    private String name;
//    private Double price;
//    private Integer area;
//    private String address;
//    private Integer maxGuest;
//    private Date dateCreated;
//    private Integer currentNumber;
//    private String description;
//    private int status;
//    private int userId;
//    private int cityId;
//    private int districtId;
//    private List<UtilityRequestModel> utilities;
//    private List<String> imageUrls;

    init(){
        self.roomId = 0
        self.name = ""
        self.price = 0.0
        self.area = 0
        self.address = ""
        self.phone = ""
        self.maxGuest = 0
        self.description = ""
        self.imageUrls = []
        self.utilities = []
        self.requiredGender = 0
        self.userId = 0
        self.districtId = 0
        self.cityId = 0
    }



    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        roomId <- map["roomId"]
        name <- map["name"]
        price <- map["price"]
        area <- map["area"]
        address <- map["address"]
        phone <- map["phone"]
        maxGuest <- map["max_guest"]
        description <- map["description"]
        imageUrls <- map["imageUrls"]
        utilities <- map["utilities"]
        requiredGender <- map["requiredGender"]
        userId <- map["userId"]
        districtId <- map["districtId"]
        cityId <- map["cityId"]
    }
    

}

