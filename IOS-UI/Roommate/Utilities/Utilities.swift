//
//  Utilities.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class Utilities{
    static func vcFromStoryBoard(vcName:String,sbName:String) -> UIViewController {
        return UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: vcName)
    }
    static func embedVCInNavigationVC(vc:UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: vc)
    }
    static func openSystemApp(type:SystemAppType,forController controller:UIViewController,withContent content:String,completionHander hander:((Bool)->Void)?){
        var url:URL?
        switch type {
        case .phone:
            url = URL(string: "tel://\(content)")
        case .message:
            url = URL(string: "sms://\(content)")
        case .email:
            url = URL(string: "mailto://\(content)")
        }
        
        if let url = url ,UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: hander)
        }
    }
}
