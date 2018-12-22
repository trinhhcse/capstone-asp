//
// Created by TrinhHC on 11/24/18.
// Copyright (c) 2018 TrinhHC. All rights reserved.
//

import Foundation
class SettingMappableModel {
    var cityId = 45
    var longitude:Double?
    var latitude:Double?

    init(cityId:Int,longitude: Double?, latitude: Double?) {
        self.cityId = cityId
        self.longitude = longitude
        self.latitude = latitude
    }

    convenience init(settingModel:SettingModel){
        self.init(cityId: settingModel.cityId, longitude: settingModel.longitude.value, latitude: settingModel.latitude.value)
    }
}
