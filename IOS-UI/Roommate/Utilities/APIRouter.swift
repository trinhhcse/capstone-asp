//
//  APIRouter.swift
//  Roommate
//
//  Created by TrinhHC on 10/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
enum ApiResponseErrorType{
    case HTTP_ERROR,API_ERROR,SERVER_NOT_RESPONSE,PARSE_RESPONSE_FAIL
    
}
enum APIRouter:URLRequestConvertible{
    case findById(id:Int)
    case login(username:String,password:String)
    case search(input:String)
    case placeDetail(id:String)
    case city()
    case district()
    case utility()
    case createRoom(model: RoomMappableModel)
    case postForAll(model:FilterArgumentModel)
    case postForBookmark(model:FilterArgumentModel)
    case createBookmark(model:BookmarkRequestModel)
    case removeBookmark(favoriteId:Int)
    case suggestBestMatch(model:FilterArgumentModel)
    case suggest(model:BaseSuggestRequestModel)
    case getRoomsByUserId(userId:Int,page:Int,size:Int)
    case getHistoryRoom(userId:Int,page:Int,size:Int)
    case getCurrentRoom(userId:Int)
    case getRoomOfPost(postId:Int)
    case getUserPost(model:FilterArgumentModel)
    case findExitedUserInRoom(username:String)
    case editMember(roomMemberRequestModel:RoomMemberRequestModel)
    case removeRoom(roomId:Int)
    case updateRoom(model: RoomMappableModel)
    case findByUsername(username:String)
    case createUser(model:UserMappableModel)
    case editUser(model:UserMappableModel)
    case searchPostByAddress(model:SearchRequestModel)
    case createRoommatePost(model: RoommatePostRequestModel)
    case createRoomPost(model: RoomPostRequestModel)
    case editRoomPost(model: RoomPostRequestModel)
    case editRoommatePost(model: RoommatePostRequestModel)
    case removePost(postId: Int)
    case saveSuggestSetting(model:SuggestSettingMappableModel)
    case saveRoomRate(model:RoomRateRequestModel)
    case saveUserRate(model:UserRateRequestModel)
    case getRoomRatesByPostId(postId:Int,page:Int,size:Int)
    case getRoomRatesByRoomId(roomId:Int,page:Int,size:Int)
    case getUserRates(userId:Int,page:Int,size:Int)
    case findUserByUserId(userId:Int)
    case resetPassword(email:String)
    case changePassowrd(model:ChangePasswordRequestModel)
    var httpHeaders:HTTPHeaders{
        switch self{
        case .search:
            return [:]
        default:
            return ["Accept":"application/json"]
        }
    }
    
    var httpMethod:HTTPMethod{
        switch self{ case .login,.createRoom,.postForAll,.postForBookmark,.createBookmark,.suggestBestMatch,.suggest,.getUserPost,.createUser,.searchPostByAddress,.createRoommatePost,.createRoomPost,.saveSuggestSetting,.saveRoomRate,.saveUserRate,.changePassowrd:
            return .post
        case .removeBookmark,.removeRoom,.removePost:
            return .delete
        case .updateRoom,.editRoomPost,.editMember,.editRoommatePost,.editUser:
            return .put
        default:
            return .get
            
        }
    }
    
    var path:String{
        switch self{
        case .findById(let id):
            return "findById/\(id)"
        case .login:
            return "user/login"
        case .search:
            return "maps/api/place/autocomplete/json"
        case .placeDetail:
            return "maps/api/place/details/json"
        case .city:
            return "city"
        case .district:
            return "district"
        case .createRoom:
            return "room/create"
        case .utility:
            return "utilities/getAll"
        case .postForAll:
            return "post/filter"
        case .postForBookmark:
            return "post/favouriteFilter"
        case .createBookmark:
            return "favourites/createFavourite"
        case .removeBookmark(let favoriteId):
            return "favourite/remove/\(favoriteId)"
        case .suggestBestMatch:
            return "post/suggestBestMatch"
        case .suggest:
            return "post/suggest"
        case .getRoomsByUserId(let userId,_,_):
            return "room/user/\(userId)"
        case .findExitedUserInRoom(let username):
            return "user/findExitedUserInRoom/\(username)"
        case .editMember:
            return "room/editMember"
        case .removeRoom(let roomId):
            return "room/deleteRoom/\(roomId)"
        case .updateRoom:
            return "room/update"
        case .getCurrentRoom(let userId):
            return "room/user/currentRoom/\(userId)"
        case .getHistoryRoom(let userId,_,_):
            return "room/user/history/\(userId)"
        case .getUserPost:
            return "post/userPost"
        case .findByUsername(let username):
            return "user/findByUsername/\(username)"
        case .createUser:
            return "user/createUser"
        case .searchPostByAddress:
            return "post/search"
        case .createRoommatePost:
            return "post/createRoommatePost"
        case .createRoomPost:
            return "post/createRoomPost"
        case .editRoomPost:
            return "post/updateRoomPost"
        case .editRoommatePost:
            return "post/updateRoommatePost"
        case .saveSuggestSetting:
            return "reference/save"
        case .removePost(let postId):
            return "post/delete/\(postId)"
        case .saveRoomRate:
            return "room/rate/save"
        case .saveUserRate:
            return "user/rate/save"
        case .getUserRates(let userId,_,_):
            return "user/findAllUserRate/\(userId)"
        case .getRoomRatesByPostId(let postId,_,_):
            return "room/getRoomRatesOfPost/\(postId)"
        case .getRoomRatesByRoomId(let roomId,_,_):
            return "room/getRoomRates/\(roomId)"
        case .findUserByUserId(let userId):
            return "user/findById/\(userId)"
        case .editUser:
            return "user/updateUser"
        case .getRoomOfPost(let postId):
            return "post/room/\(postId)"
        case .resetPassword(let email):
            return "user/resetPassword/\(email)"
        case .changePassowrd:
            return "user/changePassword"
            
        }
    }
    
    var parameters:Parameters{
        switch self{
        case .login(let username,let password):
            let dic = [
                "username":username,
                "password":password
            ]
            return dic
        case .search(let input):
            return ["language":"vi",
                    "input":input,
                    "components":"country:VN",
                    "types":"address",
                    "key":Constants.GOOGLE_PLACE_API_KEY]
        case .placeDetail(let id):
            return ["language":"vi",
                    "placeid":id,
                    "fields":"formatted_address,geometry",
                    "key":Constants.GOOGLE_PLACE_API_KEY]
        case .createRoom(let model):
            return Mapper().toJSON(model)
        case .postForAll(let model):
            return Mapper().toJSON(model)
        case .postForBookmark(let model):
            return Mapper().toJSON(model)
        case .createBookmark(let model):
            return Mapper().toJSON(model)
        case .suggestBestMatch(let model):
            return Mapper().toJSON(model)
        case .suggest(let model):
            return Mapper().toJSON(model)
        case .getRoomsByUserId(_,let page,let size):
            return ["page":page,
                    "size":size]
        case .editMember(let model):
            return Mapper().toJSON(model)
        case .updateRoom(let model):
            return Mapper().toJSON(model)
        case .getUserPost(let model):
            return Mapper().toJSON(model)
        case .getHistoryRoom(_,let page,let size):
            return ["page":page,
                    "size":size]
        case .createUser(let model):
            return Mapper().toJSON(model)
        case .searchPostByAddress(let model):
            return Mapper().toJSON(model)
        case .createRoommatePost(let model):
            return Mapper().toJSON(model)
        case .createRoomPost(let model):
            return Mapper().toJSON(model)
        case .editRoomPost(let model):
            return Mapper().toJSON(model)
        case .editRoommatePost(let model):
            return Mapper().toJSON(model)
        case .saveSuggestSetting(let model):
            return Mapper().toJSON(model)
        case .saveRoomRate(let model):
            return Mapper().toJSON(model)
        case .saveUserRate(let model):
            return Mapper().toJSON(model)
        case .editUser(let model):
            return Mapper().toJSON(model)
        case .changePassowrd(let model):
            return Mapper().toJSON(model)
        case .getUserRates(_,let page,let size):
            return ["page":page,
                    "size":size]
        case .getRoomRatesByPostId(_,let page,let size):
            return ["page":page,
                    "size":size]
        case .getRoomRatesByRoomId(_,let page,let size):
            return ["page":page,
                    "size":size]
        default:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url:URL
        switch self{
        case .search,.placeDetail:
            url = try! Constants.BASE_URL_GOOGLE_PLACE_API.asURL()
        default:
            url = try!  Constants.BASE_URL_API.asURL()
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.allHTTPHeaderFields = httpHeaders
        urlRequest.httpMethod = httpMethod.rawValue
        
        switch self{
        case .getCurrentRoom,.utility(),.district(),.city():
            urlRequest.timeoutInterval  = 5
        case .login:
            urlRequest.timeoutInterval  = 7
        default:
            urlRequest.timeoutInterval  = 45
            
        }
        
        do{
            switch self.httpMethod {
            case .post,.put:
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            default:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
        }catch {
            print("Create Request error In APIRouter:\(error)")
        }
        
        return urlRequest
    }
}
