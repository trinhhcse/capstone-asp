//
//  MainTabBarVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class MainTabBarVC: BaseTabBarVC,UITabBarControllerDelegate{
    var group = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//        setupUI();
        self.tabBar.isHidden = true
        view.backgroundColor = .white
        if APIConnection.isConnectedInternet(){
            checkAndLoadInitData(view: self.view)
        }else{
            setupUI()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        self.tabBar.isHidden = false
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        var vcs = [UIViewController]()
        
        let home = HomeVC()
        home.tabBarItem = UITabBarItem(title: "HOME_VC".localized , image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home"))
        
        let all = AllVC()
        all.allVCType = .all
        all.tabBarItem = UITabBarItem(title: "ALL_VC".localized , image: UIImage(named: "all")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "all"))
        
        let bookmark = AllVC()
        bookmark.allVCType = .bookmark
        bookmark.tabBarItem = UITabBarItem(title: "BOOKMARK_VC".localized , image: UIImage(named: "bookmark-blue")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bookmark-blue"))
        
        let notification = NotificationVC()
        notification.tabBarItem = UITabBarItem(title: "NOTIFICATION_VC".localized, image: UIImage(named: "notification")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "notification"))
        
        let account = AccountVC()
        account.accountVCType =  DBManager.shared.getUser()?.roleId == Constants.ROOMOWNER ? AccountVCType.roomOwner : AccountVCType.member
        account.tabBarItem = UITabBarItem(title: "ACCOUNT_VC".localized, image: UIImage(named: "account")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "account"))
        vcs.append(home)
        vcs.append(all)
        vcs.append(bookmark)
        vcs.append(notification)
        vcs.append(account)
        viewControllers = vcs.map({
//            let _ = $0.view
            if $0 is AccountVC {
                return $0
            }else{
                return UINavigationController(rootViewController: $0)
            }
            
        })
        viewControllers?.forEach({ (vc) in
            if vc is UINavigationController{
                let _ = (vc as! UINavigationController).topViewController?.view
            }else{
                let _ = vc.view
            }
        })
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        view.layoutIfNeeded()
        return true
    }
    func checkAndLoadInitData(view:UIView){
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 5, execute: {
            if !DBManager.shared.isExisted(ofType: UtilityModel.self){self.requestUtilitiesArray()}
            if !DBManager.shared.isExisted(ofType:CityModel.self){self.requestArray(apiRouter: APIRouter.city(), returnType:CityModel.self)}
            if !DBManager.shared.isExisted(ofType:DistrictModel.self){self.requestArray(apiRouter: APIRouter.district(), returnType:DistrictModel.self)}
            let loaded =  self.fetchUserData()
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: view, animated: true)
                if !DBManager.shared.isExisted(ofType: UtilityModel.self) || !DBManager.shared.isExisted(ofType: CityModel.self) || !DBManager.shared.isExisted(ofType: DistrictModel.self){
                    BaseVC.successLoaded = false
                }else{
                    if loaded{
                        BaseVC.successLoaded = true
                    }else{
                        BaseVC.successLoaded = false
                    }
                    
                }
                print("Loaded \(loaded)")
                print("successLoaded \(BaseVC.successLoaded)")
                self.setupUI()
                
            }
            
        })
        
    }
    
    //For Objectmapper and realm
    func requestArray<T:BaseModel>(apiRouter:APIRouter,returnType:T.Type){
        self.group.enter()
        APIConnection.requestArray(apiRouter: apiRouter, errorNetworkConnectedHander: nil, returnType: T.self) { (values, error, statusCode) -> (Void) in
            
            if error == nil{
                //200
                if statusCode == .OK{
                    guard let values = values else{
                        //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                        self.group.leave()
                        return
                    }
                    DispatchQueue.main.async {
                        if !DBManager.shared.isExisted(ofType: T.self){
                            _ = DBManager.shared.addRecords(ofType: T.self, objects: values)
                        }
                        
                        
                    }
                    
                }
            }
            self.group.leave()
        }
        self.group.wait()
    }
    func fetchUserData() -> Bool{
        var success = false
        guard let currentUser = DBManager.shared.getUser() else {
            
            return success
        }
        let user = UserMappableModel(userModel: currentUser)
        self.group.enter()
        APIConnection.requestObject(apiRouter: APIRouter.login(username: user.username ?? "", password: user.password ?? ""), errorNetworkConnectedHander: nil, returnType: UserMappableModel.self) { (userMappableModel, error, statusCode) -> (Void) in
            if error == nil{
                //200
                if statusCode == .OK{
                    guard let userMappableModel = userMappableModel else{
                        success = false
                        self.group.leave()
                        return
                    }
                    userMappableModel.password = user.password
                    let userModel = UserModel(userMappedModel: userMappableModel)
                    _ = DBManager.shared.addSingletonModel(ofType: UserModel.self, object: userModel)
                    success = true
                    
                }else{
                    success = false
                }
                
            }
            self.group.leave()
        }
        self.group.wait()
        return success
    }
    func requestUtilitiesArray(){
        self.group.enter()
        APIConnection.requestArray(apiRouter: APIRouter.utility(), errorNetworkConnectedHander: nil, returnType: UtilityMappableModel.self) { (values, error, statusCode) -> (Void) in
            
            if error == nil{
                //200
                if statusCode == .OK{
                    guard let values = values else{
                        //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                        self.group.leave()
                        return
                    }
                    DispatchQueue.main.async {
                        if !DBManager.shared.isExisted(ofType: UtilityModel.self){
                            _ = DBManager.shared.addRecords(ofType: UtilityModel.self, objects: values.compactMap({ (utility) -> UtilityModel? in
                                UtilityModel(utilityMappableModel: utility)
                            }))
                        }
                        
                    }
                    
                }
            }
            self.group.leave()
        }
        self.group.wait()
    }
    func requestCurrentRoom(){
        self.group.enter()
        APIConnection.requestObject(apiRouter: APIRouter.getCurrentRoom(userId: DBManager.shared.getUser()!.userId), returnType: RoomMappableModel.self){ (value, error, statusCode) -> (Void) in
            
            if error == nil{
                //200
                if statusCode == .OK{
                    guard let value = value else{
                        //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                        self.group.leave()
                        return
                    }
                     _ = DBManager.shared.addSingletonModel(ofType: RoomModel.self, object: RoomModel(roomId:value.roomId,userId:DBManager.shared.getUser()?.userId))
                }else if statusCode == .NotFound{
                    DBManager.shared.deleteAllRecords(ofType: RoomModel.self)
                }
            }
            self.group.leave()
        }
        self.group.wait()
    }
    
    
}
//
