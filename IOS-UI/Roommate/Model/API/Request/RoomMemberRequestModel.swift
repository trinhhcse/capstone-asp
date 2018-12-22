//
//  MemberResponseModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import ObjectMapper
class RoomMemberRequestModel: Mappable {
    var roomId:Int?
    var memberRequestModels:[MemberRequestModel]?

    public init(roomId: Int?, memberRequestModels: [MemberRequestModel]?) {
        self.roomId = roomId
        self.memberRequestModels = memberRequestModels
    }
    
    public init(){
        
    }
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        roomId <- map["roomId"]
        memberRequestModels <- map["memberRequestModels"]
    }
    
}
