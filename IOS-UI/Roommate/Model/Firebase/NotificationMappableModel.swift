//
//  NotificationMappableModel.swift
//  Roommate
//
//  Created by TrinhHC on 12/2/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
class NotificationMappableModel: Mappable,Equatable,Hashable {
    var notificationId:String!
    var date: Date!
    var roleId: Int?
    var roomId: Int?
    var roomName: String!
    var status: Int!
    var type: Int!
    var userId: Int?
    var hashValue: Int{
        return notificationId.hashValue
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        roleId <- (map["role_id"],TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        roomId <- (map["room_id"],TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        status <- (map["status"],TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        type <- (map["type"],TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        userId <- (map["user_id"],TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
        roomName <- map["room_name"]
        date <- (map["date"],CustomDateFormatTransform(formatString:"yyyy-MM-dd HH:mm:ss.SSS"))
    }
    static func ==(lhs:NotificationMappableModel,rhs:NotificationMappableModel)->Bool{
        return lhs.notificationId == rhs.notificationId
    }
}
