//
//  NotificationTVCell.swift
//  Roommate
//
//  Created by TrinhHC on 9/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class NotificationCVCell: UICollectionViewCell {
    
    lazy var imgLeft:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        return image
    }()
    lazy var lblTopRight:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: .medium)
        lbl.textColor = UIColor(hexString: Constants.COLOR_MAIN_TITLE)
        return lbl
    }()
    lazy var lblBottomRight:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: .small)
        lbl.textColor = UIColor(hexString:Constants.COLOR_SUB_TITLE)
        lbl.font.withSize(10)
        return lbl
    }()
    var notification:NotificationMappableModel!{
        didSet{
            let dic = (notification?.status == Constants.NEW || notification?.status == Constants.NEW_LOADED) ? [NSAttributedStringKey.font:UIFont.boldSmall] : [NSAttributedStringKey.font:UIFont.small]
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
            lblTopRight.attributedText = NSAttributedString(string:text, attributes:dic)
            lblBottomRight.attributedText = NSAttributedString(string: notification.date.string(Constants.SHOW_DATE_FORMAT), attributes:dic)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        
        //Setup for right image icon
        addSubview(imgLeft)
        _ = imgLeft.anchorTopLeft( topAnchor,  leftAnchor,  self.frame.height*0.1,  self.frame.height*0.1, self.frame.height*0.8, self.frame.height*0.8)
        imgLeft.image = UIImage(named: "app_icon_small")
        
        //Setup for top right image icon
        addSubview(lblTopRight)
        _ =  lblTopRight.anchorTopLeft( topAnchor, imgLeft.rightAnchor,  0,  self.frame.height*0.1, self.frame.width-self.frame.height*1.1, self.frame.height*0.5)
        //Setup for bottom right image icon
        addSubview(lblBottomRight)
        _ =  lblBottomRight.anchorTopLeft( lblTopRight.bottomAnchor, imgLeft.rightAnchor,  0,  self.frame.height*0.1, self.frame.width-self.frame.height*1.1, self.frame.height*0.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
