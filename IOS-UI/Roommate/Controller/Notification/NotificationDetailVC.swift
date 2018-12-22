//
//  NotificationDetailVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class NotificationDetailVC:BaseVC{
    lazy var tvContent:UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    var notification:NotificationMappableModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDataAndDelegate()
    }
    
    func setupUI(){
        self.navigationController?.navigationBar.isHidden = false
        title = "NOTIFICATION_DETAIL".localized
        setBackButtonForNavigationBar()
        view.addSubview(tvContent)
        _ = tvContent.anchor(view: self.view)
        tvContent.layer.borderWidth = 0
        tvContent.isEditable = false
        tvContent.isUserInteractionEnabled = false
    }
    func setDataAndDelegate(){
        let dic =  [NSAttributedStringKey.font:UIFont.boldMedium]
        var text:String = ""
        switch notification?.type {
        case Constants.ROOM_ACCEPT_NOTIFICATION:
            text = String(format: "ROOM_ACCEPT_NOTIFICATION".localized, notification.roomName)
        case Constants.ROOM_DENIED_NOTIFICATION:
            text = String(format: "ROOM_DENIED_NOTIFICATION".localized,notification.roomName )
        case Constants.ADD_MEMBER_NOTIFICATION:
            text = String(format: "ADD_MEMBER_NOTIFICATION".localized, notification.roomName)
        case Constants.REMOVE_MEMBER_NOTIFICATION:
            text = String(format: "REMOVE_MEMBER_NOTIFICATION".localized,notification.roomName )
        case Constants.UPDATE_MEMBER_NOTIFICATION:
            text = String(format: "UPDATE_MEMBER_NOTIFICATION".localized,notification.roomName )
        default:
            break
        }
        tvContent.attributedText = NSAttributedString(string:text, attributes:dic)
    }
    
}
