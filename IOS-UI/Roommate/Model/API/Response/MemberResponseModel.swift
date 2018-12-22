//
//  MemberResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class MemberResponseModel: Mappable,Hashable,Equatable,NSCopying {
    var userId:Int?
    var roleId:Int?
    var username:String!
    
    var hashValue: Int{
        return username.hashValue
    }
    
    public init(username:String) {
        self.username = username
    }
    init(memberModel:MemberModel) {
        self.userId = memberModel.userId
        self.roleId = memberModel.roleId
        self.username = memberModel.username
    }
    public init(userId: Int?, roleId: Int?, username: String!) {
        self.userId = userId
        self.roleId = roleId
        self.username = username
    }
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        userId <- map["userId"]
        roleId <- map["roleId"]
        username <- map["username"]
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let member = MemberResponseModel(userId: self.userId, roleId: self.roleId, username: self.username)
        return member
    }
    
    static func == (lhs: MemberResponseModel, rhs: MemberResponseModel) -> Bool {
        return lhs.username == rhs.username
    }
    
}
