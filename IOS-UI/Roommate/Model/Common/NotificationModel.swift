//
//  Notification.swift
//  Roommate
//
//  Created by TrinhHC on 9/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
class NotificationModel{
    var id:Int?
    var title:String?
    var date:Date?
    
    init(id:Int?,title:String?,date:Date?) {
        self.id = id
        self.title = title
        self.date = date
    }
}
