//
//  ViewController.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class MainViewVC: BaseVC {
    private lazy var mainTabBarVC:MainTabBarVC =  {
        let vc = MainTabBarVC()
        return vc
    }()
//    private lazy var signInVC:SignInVC =  {
//        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_SIGN_IN, sbName: Constants.STORYBOARD_MAIN) as! SignInVC
//        return vc
//    }()
    private lazy var roomDetailVC:RoomDetailVC = {
        let vc = RoomDetailVC()
        return vc
    }()
    
    private lazy var ceRoomVC:CERoomVC = {
        let vc = CERoomVC()
        vc.modalPresentationStyle = .popover
        return vc
    }()
    
    private lazy var firstLanchVC:FirstLaunchVC = {
       let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_FIRST_LAUNCH, sbName: Constants.STORYBOARD_MAIN) as! FirstLaunchVC
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.present(ceRoomVC, animated: true, completion: nil)
//        Check Login
        
        registerNotification()
        checkLogin()
    }
    func checkLogin(){
        if let _ = DBManager.shared.getUser(){
            self.add(mainTabBarVC)
        }else{
            self.add(UINavigationController(rootViewController: firstLanchVC))
        }
    }
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onSignOut), name: Constants.NOTIFICATION_SIGNOUT, object: nil)
    }

    @objc func onSignOut(){
//        mainTabBarVC.remove()
//        checkLogin()
    }

}

