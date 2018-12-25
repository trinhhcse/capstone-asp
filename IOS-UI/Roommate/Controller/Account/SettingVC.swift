//
//  FilterForRoom.swift
//  Roommate
//
//  Created by TrinhHC on 10/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import FirebaseDatabase
class SettingVC: BaseVC ,UITableViewDataSource,UITableViewDelegate{
    
    
    var accountSettingsForMemberAndMaster = [
        "PROFILE_SETTING",
        "TITLE_CHANGE_PASSWORD",
        "SUGGEST_SETTING"
    ]
    var accountSettingsForRoomOwner = [
        "PROFILE_SETTING",
        "TITLE_CHANGE_PASSWORD"
    ]
    var languageSettings = [
        "LANGUGE_SETTING"
    ]
    var otherSettings = [
        "ABOUT_US_SETTING",
        "PRIVACY_SETTING",
        "FEEDBACK_SETTING",
        "TITLE_SIGN_OUT"
    ]
    
    var headers = [
        "HEADER_ACCOUNT",
        "HEADER_LANGUAGE",
        "HEADER_OTHER"
    ]
    lazy var settingActionTableView:UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let user = DBManager.shared.getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegateAndDataSource()
    }
    
    func setupUI(){
        title = "SETTING".localized
        setBackButtonForNavigationBar()
        
        view.addSubview(settingActionTableView)
        _ = settingActionTableView.anchor(view.topAnchor, view.leftAnchor, view.bottomAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        
    }
    
    func setupDelegateAndDataSource(){
        settingActionTableView.delegate = self
        settingActionTableView.dataSource = self
        settingActionTableView.register(UINib(nibName: Constants.CELL_ACTIONTV, bundle: Bundle.main), forCellReuseIdentifier: Constants.CELL_ACTIONTV)
        
    }
    //MARK: UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if user?.roleId == Constants.ROOMOWNER{
                return accountSettingsForRoomOwner.count
            }else{
                return accountSettingsForMemberAndMaster.count
            }
        }else if section == 1{
            return languageSettings.count
        }else{
            return otherSettings.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ACTIONTV, for: indexPath) as! ActionTVCell
        if indexPath.section == 0{
            if user?.roleId == Constants.ROOMOWNER{
                cell.title =  accountSettingsForRoomOwner[indexPath.row].localized
            }else{
                cell.title =  accountSettingsForMemberAndMaster[indexPath.row].localized
            }
        }else if indexPath.section == 1{
            cell.title =  languageSettings[indexPath.row].localized
        }else{
            cell.title =  otherSettings[indexPath.row].localized
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        v.addSubview(lbl)
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.backgroundColor = .lightGray
        lbl.text = headers[section].localized
        
        return v
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let vc = ProfireVC()
                vc.profireVCType = .normal
                presentInNewNavigationController(viewController: vc, flag: false, animated: true)
            }else if indexPath.row == 1{
                let vc = ChangePasswordVC()
                presentInNewNavigationController(viewController: vc, flag: false, animated: true)
            }else{
                let vc = SuggestSettingVC()
                presentInNewNavigationController(viewController: vc, flag: false, animated: true)
            }
            
        }else if indexPath.section == 1{
            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "LANGUAGE_SETTING_VIETNAME".localized, inViewController: self)
        }else{
            if indexPath.row == 0{
                AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "ABOUT_US_SETTING_MESSAGE".localized, inViewController: self)
            }else if indexPath.row == 1{
                AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "PRIVACY_SETTING_MESSAGE".localized, inViewController: self)
            }else if indexPath.row == 2{
                AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "FEEDBACK_SETTING_MESSAGE".localized, inViewController: self)
            }else{
//                Database.database().reference().child("notifications/users").child("\(self.user!.userId)").removeAllObservers()
                if let ref = BaseVC.refToObserveNotification{
                    ref.removeAllObservers()
                }
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.window!.rootViewController?.dismiss(animated: true, completion: {
                    DBManager.shared.deleteAllRealmDB()
                    BaseVC.successLoaded = false
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.window!.rootViewController = UINavigationController(rootViewController: Utilities.vcFromStoryBoard(vcName: Constants.VC_FIRST_LAUNCH, sbName: Constants.STORYBOARD_MAIN) )
                })
                
            }
        }
    }
    //    //MARK: UITableView DataSourse and Delegate
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return Constants.HEIGHT_CELL_ACTIONTV
    //    }
    //
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return user?.roleId == Constants.ROOMOWNER ? settingActionsForRoomOwner.count : settingActionsForRoommeberAndMember.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ACTIONTV, for: indexPath) as! ActionTVCell
    //        cell.title = user?.roleId == Constants.ROOMOWNER ?   settingActionsForRoomOwner[indexPath.row].localized : settingActionsForRoommeberAndMember[indexPath.row].localized
    //        cell.selectionStyle = .none
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if user?.roleId == Constants.ROOMOWNER{
    //            switch indexPath.row{
    //            case 0:
    //                let appdelegate = UIApplication.shared.delegate as! AppDelegate
    //                appdelegate.window!.rootViewController = UINavigationController(rootViewController: Utilities.vcFromStoryBoard(vcName: Constants.VC_FIRST_LAUNCH, sbName: Constants.STORYBOARD_MAIN) )
    //                NotificationCenter.default.post(name: Constants.NOTIFICATION_SIGNOUT, object: nil)
    //                self.navigationController?.dismiss(animated: true, completion: {
    //                    DBManager.shared.deleteAllUsers()
    //                })
    //            default:
    //                break
    //            }
    //        }else{
    //            switch indexPath.row{
    //            case 0:
    //                break
    //            case 1:
    //
    //                let appdelegate = UIApplication.shared.delegate as! AppDelegate
    //                appdelegate.window!.rootViewController = UINavigationController(rootViewController: Utilities.vcFromStoryBoard(vcName: Constants.VC_FIRST_LAUNCH, sbName: Constants.STORYBOARD_MAIN) )
    //                NotificationCenter.default.post(name: Constants.NOTIFICATION_SIGNOUT, object: nil)
    //                self.navigationController?.dismiss(animated: true, completion: {
    //                    DBManager.shared.deleteAllUsers()
    //                })
    //            default:
    //                break
    //            }
    //        }
    //
    //
    //
    //
    //    }
}
