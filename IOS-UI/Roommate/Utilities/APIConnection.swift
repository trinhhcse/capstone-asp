//
//  APIConnection.swift
//  Roommate
//
//  Created by TrinhHC on 10/9/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
class APIConnection: NSObject {
    static func isConnectedInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    static func requestArray<T:Mappable>(apiRouter:APIRouter,errorNetworkConnectedHander:(()->Void)? = nil,returnType:T.Type,completion:@escaping (_ result:[T]?,_ error:ApiResponseErrorType?,_ statusCode:HTTPStatusCode?)->(Void)){
        //Network handler
        if !isConnectedInternet(){
            if let errorNetworkConnectedHander = errorNetworkConnectedHander{
                errorNetworkConnectedHander()
                return
            }
        }
        print(apiRouter)
        Alamofire.request(apiRouter).responseArray { (response:DataResponse<[T]>) in
            //Fail to connect to server
            if let _ = response.error{
//                //Http response nil: Timeout or cannot connect
//                if response.response == nil {
//                    completion(nil,ApiResponseErrorType.SERVER_NOT_RESPONSE,nil)
//                    //Error to convert json to object
//                }else{
//                    //Default code 404 when return from server
//                    completion(nil, .PARSE_RESPONSE_FAIL, .NotFound)
//                }
                //Fail to connect to server
                //Http response nil: Timeout or cannot connect
                if response.response == nil {
                    completion(nil,ApiResponseErrorType.SERVER_NOT_RESPONSE,nil)

                }else{
                    //Error to convert json to object
                    //Default code 404,403 cause error parse response to json
                    if let statusCode = response.response?.statusCode{
                        completion(nil,nil,HTTPStatusCode(rawValue: statusCode))
                    }else{
                        //PARSE_RESPONSE_FAIL
                        completion(nil,ApiResponseErrorType.PARSE_RESPONSE_FAIL,nil)
                    }

                }

                //Success
            }else{
                guard let code = response.response?.statusCode,let httpStatusCode = HTTPStatusCode(rawValue: code) else{
                    return
                }
                //Default success code 200
                if httpStatusCode == .OK{
                    completion(response.result.value,nil,.OK)
                }else{
                    completion(nil,nil,httpStatusCode)
                }
            }
        }
    }
    static func requestObject<T:Mappable>(apiRouter:APIRouter,errorNetworkConnectedHander handler:(()->Void)? = nil,returnType:T.Type,completion:@escaping (_ result:T?,_ error:ApiResponseErrorType?,_ statusCode:HTTPStatusCode?)->(Void)){
        //Network handler
        if !isConnectedInternet(){
            if let handler = handler{
                handler()
                return
            }
        }
        Alamofire.request(apiRouter).responseObject { (response:DataResponse<T>) in
            //Parse response to object fail
            if let _ = response.error{
                //Fail to connect to server
                //Http response nil: Timeout or cannot connect
                if response.response == nil {
                    completion(nil,ApiResponseErrorType.SERVER_NOT_RESPONSE,nil)

                }else{
                    //Error to convert json to object
                    //Default code 404,403 cause error parse response to json
                    if let statusCode = response.response?.statusCode ,statusCode != 500{
                        completion(nil,nil,HTTPStatusCode(rawValue: statusCode))
                    }else{
                        //PARSE_RESPONSE_FAIL
                        completion(nil,ApiResponseErrorType.PARSE_RESPONSE_FAIL,nil)
                    }
                    
                }

            }else{
                //Parse response to object success
                guard let code = response.response?.statusCode,let httpStatusCode = HTTPStatusCode(rawValue: code) else{
                    return
                }
                completion(response.result.value,nil,httpStatusCode)
//                //Default success code 200 or 201
//                if httpStatusCode == .OK || httpStatusCode == .Created{
//                    completion(response.result.value,nil,httpStatusCode)
//                }else{
//                    completion(nil,nil,httpStatusCode)
//                }
            }
            
        }
        
    }
    static func request(apiRouter:APIRouter,errorNetworkConnectedHander handler:(()->Void)?=nil,completion:@escaping (_ error:ApiResponseErrorType?,_ statusCode:HTTPStatusCode?)->(Void)){
        //Network handler
        if !isConnectedInternet(){
            if let handler = handler{
                handler()
                return
            }
        }
        
        Alamofire.request(apiRouter).response { (response) in
            //Fail to connect to server
            if let _ = response.error{
                //Http response nil: Timeout or cannot connect
                if response.response == nil {
                    completion(ApiResponseErrorType.SERVER_NOT_RESPONSE,nil)
                    //Error to convert json to object
                }
                //Success
            }else{
                guard let code = response.response?.statusCode,let httpStatusCode = HTTPStatusCode(rawValue: code) else{
                    return
                }
                completion(nil,httpStatusCode)
            }
            
        }
        
    }
}
