//
//  APIResponseAlert.swift
//  Roommate
//
//  Created by TrinhHC on 10/10/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class APIResponseAlert {
    static func defaultAPIResponseError(controller:UIViewController,error:ApiResponseErrorType){
        var message:String?
        switch error {
        case .HTTP_ERROR:
            message = "NETWORK_STATUS_CONNECTED_ERROR_MESSAGE"
        case .API_ERROR:
            message = "NETWORK_STATUS_ERROR_MESSAGE"
        case .SERVER_NOT_RESPONSE:
            message = "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE"
        case .PARSE_RESPONSE_FAIL:
            message = "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE"
        }
        AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: message?.localized, inViewController: controller)
    }
    static func apiResponseError(controller:UIViewController,type:APIResponseAlertType){
        var message:String?
        switch type {
        case .invalidUsername:
            message = "ALERT_INVALID_USERNAME_MESSAGE"
        case .invalidPassword:
             message = "ALERT_INVALID_PASSWORD_MESSAGE"
        case .invalidUsernameOrPassword:
            message = "ALERT_INVALID_USERNAME_PASSWORD_MESSAGE"
        case .internalServerError:
             message = "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE"
        case .invalidMember:
            message = "ALERT_INVALID_MEMBER"
        case .nonExistedUsername:
            message = "ALERT_NON_EXIST_USERNAME"
        case .exitedUser:
            message = "EXISTED_USER"
        case .existedRoomMember:
            message = "ALERT_EXISTED_ROOM_MEMBER"
        case .addMemberSuccess:
            message = "ALERT_ADD_MEMBER_SUCCESS"
        case .requiredRoomMaster:
            message = "EDIT_ROOM_MASTER_REQUIRED"
        case .invalidMaxGuest:
            message = "EDIT_ROOM_INVALID_MAXGUEST"
            
            
        }
        AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: message?.localized, inViewController: controller)
    }
}
