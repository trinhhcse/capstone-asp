//
//  Enums.swift
//  Roommate
//
//  Created by TrinhHC on 9/22/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
enum CellSide :Int{
    case left,right
}
enum ProfireVCType{
    case normal,memberInfor
}
enum HorizontalImagesViewType{
    case small,full
}
enum SignUpVCType{
    case normal,edit
}
enum SingleRateViewType{
    case security,location,utility,behavior,lifestyle,payment
}
enum RateViewType{
    case roomPost,roommatePost,roomDetail,userDetail
}
enum RateVCType{
    case user,room
}
enum CollectionDisplayDataType :Int{
    case Room,Roommate
}
//
//enum RoomDetailForType{
//    case owner,member
//}

enum OrderType:Int{
    case newest=0,lowToHightPrice,hightToLowPrice
}

enum UtilityForSC{
    case showDetail,filter,edit,create
}

enum GenderSelect:Int{
    case none=0,male,female,both
}

enum SliderViewType{
    case price,area
}

enum BorderSide {
    case Top, Bottom, Left, Right
}

enum SystemAppType {
    case phone, message, email
}
enum ViewType{
    case detailForOwner,detailForMember,createForOwner,roomPostDetailForFinder,roomPostDetailForCreatedUser,roommatePostDetailForCreatedUser,roommatePostDetailForFinder,editForOwner,ceRoomPostForMaster,rate,currentDetailForMember
}
enum DropdownListViewType{
    case city,district,roomMaster
}
enum UtilitiesViewType{
    case normal,required
}
enum UtilityCVCellType{
    case detail,interact
}
enum CEVCType{
    case create,edit
}

enum AllVCType{
    case all,bookmark,search
}

enum ShowAllVCType{
    case suggestRoom,roomForOwner,roomForMember,roomPostForCreatedUser,roommatePostForCreatedUser,userRate,roomRate,roomRateForRoomOwner
}

enum AccountVCType{
    case member,roomOwner
}

enum FilterVCType{
    case room,roommate
}
enum InputViewType{
    case roomName,price,area,address,phone,roomPostName,password,oldPassword,newPassword,repeatPassword
}

enum HTTPStatusCode: Int {
    // 100 Informational
    case Continue = 100
    case SwitchingProtocols
    case Processing
    // 200 Success
    case OK = 200
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultiStatus
    case AlreadyReported
    case IMUsed = 226
    // 300 Redirection
    case MultipleChoices = 300
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case SwitchProxy
    case TemporaryRedirect
    case PermanentRedirect
    // 400 Client Error
    case BadRequest = 400
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case PayloadTooLarge
    case URITooLong
    case UnsupportedMediaType
    case RangeNotSatisfiable
    case ExpectationFailed
    case ImATeapot
    case MisdirectedRequest = 421
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests
    case RequestHeaderFieldsTooLarge = 431
    case UnavailableForLegalReasons = 451
    // 500 Server Error
    case InternalServerError = 500
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case NotExtended = 510
    case NetworkAuthenticationRequired
}
enum APIResponseAlertType{
    case invalidPassword,invalidUsernameOrPassword,invalidUsername,internalServerError,invalidMember,nonExistedUsername,addMemberSuccess,existedRoomMember,requiredRoomMaster,invalidMaxGuest,exitedUser
}
enum AlertType{
    case normal,city,district,roomMaster
}

enum VerticalCollectionViewType{
    case newRoomPost,newRoommatePost,createdRoomOfOwner
    //,currentRoomOfMember,historyRoomOfMember,createdRoomPostOfMember,createdRoommatePostOfMember
}
enum FilterType{
    case room,roommmate
}
enum ImageCVCellType{
    case normal,upload,full
}
enum RequestType{
    case room,suggest
}

