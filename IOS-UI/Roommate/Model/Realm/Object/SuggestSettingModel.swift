//
//  SuggestSettingModel.swift
//  Roommate
//
//  Created by TrinhHC on 11/22/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import Realm
class SuggestSettingModel: Object {
    @objc dynamic var userId = 0
    //default send nil for backend
    var utilities = List<Int>()
    var districts = List<Int>()
    var price = List<Float>()
    
    init(suggestSettingMappedModel:SuggestSettingMappableModel) {
        super.init()
        self.userId = suggestSettingMappedModel.userId
        suggestSettingMappedModel.utilities?.forEach{self.utilities.append($0)}
        suggestSettingMappedModel.districts?.forEach{self.districts.append($0)}
        suggestSettingMappedModel.price?.forEach{self.price.append($0)}
    }
    //MARK: Object
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override class func primaryKey() -> String? {
        return "userId"
    }
}
