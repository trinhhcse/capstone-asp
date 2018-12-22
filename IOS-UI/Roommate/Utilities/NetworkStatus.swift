//
//  NetworkStatus.swift
//  Roommate
//
//  Created by TrinhHC on 10/9/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Alamofire
class NetworkStatus {
    class func isConnected()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
