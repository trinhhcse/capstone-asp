//
//  RoomDetailForMasterVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/26/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class RoomDetailForMasterVC:BaseVC,UtilitiesViewDelegate{
    lazy var util:UtilitiesView = {
        let v:UtilitiesView = .fromNib()
//        v.utilityForSC = .create
        return v
    }()
    var utilities:[UtilityMappableModel] = []
//        [UtilityModel(utility_id: 1, name: "24-hours", quantity: 15, brand: "Hello", description: "nothing"),UtilityModel(utility_id: 1, name: "parking", quantity: 15, brand: "Hello", description: "nothing"),UtilityModel(utility_id: 1, name: "toilet", quantity: 15, brand: "Hello", description: "nothing"),
//                     UtilityModel(utility_id: 2, name: "aircondition", quantity: 15, brand: "Hello", description: "nothing"),
//                     UtilityModel(utility_id: 3, name: "cctv", quantity: 15, brand: "Hello", description: "nothing"),
//                     UtilityModel(utility_id: 4, name: "cooking", quantity: 15, brand: "Hello", description: "nothing"),
//                     UtilityModel(utility_id: 5, name: "fan", quantity: 15, brand: "Hello", description: "nothing")]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(util)
        _ = util.anchor(view.topAnchor, view.leftAnchor, nil, nil, .zero, CGSize(width: UIScreen.main.bounds.width, height: 400))
        util.utilities = utilities
        util.delegate = self
        
    }
    func utilitiesViewDelegate(utilitiesView view: UtilitiesView, didSelectUtilityAt indexPath: IndexPath) {
        
    }
}
