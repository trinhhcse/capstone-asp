//
//  Constants.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class Constants{
    //MARK: Base URL
//    static let BASE_URL_API = "http://172.20.10.6:8080/"
    static let BASE_URL_API = "http://192.168.1.182:8080/"
    static let BASE_URL_GOOGLE_PLACE_API = "https://maps.googleapis.com/"
    //MARK: Google API Key
    static let GOOGLE_PLACE_API_KEY = "AIzaSyCOgT-ZG2h-mTHElFEiv_3EJXFTppNgIAk"
    static let DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    static let SHOW_DATE_FORMAT = "dd-MM-yyyy HH:mm:ss"
    static let USER_DATE_FORMAT = "yyyy-MM-dd"
    //MARK: Constant for Storyboard name
    static let STORYBOARD_MAIN = "Main"
    static let STORYBOARD_HOME = "Home"
    static let STORYBOARD_ALL = "All"
    static let STORYBOARD_NOTIFICATION = "Notification"
    static let STORYBOARD_BOOKMARK = "Bookmark"
    static let STORYBOARD_ACCOUNT = "Account"
    
    //MARK: Constant for VC name
    static let VC_MAIN = "MainVC"
    static let VC_HOME = "HomeVC"
    static let VC_ALL = "AllVC"
    static let VC_NOTIFICATION = "NotificationVC"
    static let VC_BOOKMARK = "BookmarkVC"
    static let VC_ACCOUNT = "AccountVC"
    static let VC_SIGN_IN = "SignInVC"
    static let VC_SIGN_UP = "SignUpVC"
    static let VC_RESET_PASSWORD = "ResetPasswordVC"
    static let VC_FIRST_LAUNCH = "FirstLaunchVC"
    static let VC_UTILITY_INPUT = "UtilityInputVC"
    static let VC_IMAGES = "ImagesVC"
    
    //MARK: Constant for status
    static let NEW = 1
    static let NEW_LOADED = 2
    static let SEEN = 3
    //MARK: Constant for Notification Type
    static let ROOM_ACCEPT_NOTIFICATION = 1
    static let ROOM_DENIED_NOTIFICATION = 2
    static let ADD_MEMBER_NOTIFICATION = 3
    static let REMOVE_MEMBER_NOTIFICATION = 4
    static let UPDATE_MEMBER_NOTIFICATION = 5
    
    //MARK: Constant for Locale
    static let LOCALE_EN = "EN"
    static let LOCALE_VI = "VI"
    
    
    //MARK: Constant for UICollectionViewCell
    static let CELL_NOTIFICATIONCV = "NotificationCVCell"
    static let CELL_ROOMMATEPOSTCV = "RoommatePostCVCell"
    static let CELL_ROOMCV = "RoomCVCell"
    static let CELL_ROOMPOSTCV = "RoomPostCVCell"
    static let CELL_ORDERTV = "OrderTVCell"
    static let CELL_UTILITYCV = "UtilityCVCell"
    static let CELL_NAVIGATIONCV = "NavigationCVCell"
    static let CELL_IMAGECV = "ImageCVCell"
    static let CELL_ICONTITLETV = "IconTitleTVCell"
    static let CELL_ICONTITLECV = "IconTitleCVCell"
    static let CELL_DEFAULT = "DefaultCell"
    static let CELL_RATECV = "RateCVCell"
    
    //MARK: Constant for UITableViewCell
    static let CELL_POPUP_SELECT_LISTTV = "PopupSelectListTVCell"
    static let CELL_MEMBERTV = "MemberTVCell"
    static let CELL_ACTIONTV = "ActionTVCell"
    
    //MARK: Constant for DateFormatter
    static let DD_MM_YY_HH_MM_A = "dd-MM-yyyy HH:mm a"
    
    
    
    //MARK: Constant for Font color
    static let COLOR_SUB_TITLE = "555"
    static let COLOR_MAIN_TITLE = "000"
    static let COLOR_SUB_TITLE_DEFAULT = "00A8B5"
    
    static let MARGIN_5:CGFloat = 5
    static let MARGIN_6:CGFloat = 6
    static let MARGIN_12:CGFloat = 12
    static let MARGIN_10:CGFloat = 10
    static let MARGIN_20:CGFloat = 20
    
    
    
    //MARK: Constant for customView and cell
    static let HEIGHT_VIEW_MAX_MEMBER_SELECT:CGFloat = 50.0
    static let HEIGHT_VIEW_GENDER:CGFloat = 50.0
    static let HEIGHT_CELL_MEMBERTV:CGFloat = 50.0
    static let HEIGHT_VIEW_MEMBERS:CGFloat = 260.0
    static let HEIGHT_VIEW_DESCRIPTION:CGFloat = 180.0
    static let HEIGHT_VIEW_BASE_INFORMATION:CGFloat = 200.0
    static let HEIGHT_CELL_IMAGECV:CGFloat = 200.0
    static let HEIGHT_VIEW_HORIZONTAL_IMAGES:CGFloat = 200.0
    static let HEIGHT_VIEW_OPTION:CGFloat = 70.0
    static let HEIGHT_VIEW_DROPDOWN_LIST:CGFloat = 81.0
    static let HEIGHT_VIEW_SLIDER:CGFloat = 90.0
    static let HEIGHT_LARGE_SPACE:CGFloat = 20.0
    static let HEIGHT_TITLE:CGFloat = 50.0
    static let HEIGHT_MEDIUM_SPACE:CGFloat = 10.0
    static let HEIGHT_CELL_ROOMPOSTCV:CGFloat = 240
    static let HEIGHT_CELL_ROOMMATEPOSTCV:CGFloat = 175
    static let HEIGHT_CELL_ROOMFOROWNERCV:CGFloat = 140
    static let HEIGHT_VIEW_UPLOAD_IMAGE_BASE:CGFloat = 140.0
    static let HEIGHT_CELL_MEMBERTVL:CGFloat = 40.0
    static let HEIGHT_CELL_ACTIONTV:CGFloat = 50.0
    static let HEIGHT_VIEW_USER:CGFloat = 70.0
    static let HEIGHT_CELL_RATECV:CGFloat = 170.0
    
    
    //MARK: HomeVC
    static let HEIGHT_LOCATION_SEARCH_VIEW:CGFloat = 40
    static let HEIGHT_TOP_CONTAINER_VIEW:CGFloat = 80.0
    static let HEIGHT_HORIZONTAL_ROOM_VIEW:CGFloat = 280
    static let MAX_ROOM_ROW:Int = 3//Two room in a line
    static let MAX_POST:Int = 6
    static let HEIGHT_DEFAULT_BEFORE_LOAD_DATA:CGFloat = 120
    
    
    //MARK: AlertViewVC
    static let POPUP_SELECT_TABLE_MAX_HEIGHT:Double = 400
    static let POPUP_SELECT_TABLE_DEFATUL_WIDTH:Double = 272.0
    
    //MARK: Common height
    static let HEIGHT_UTILITY_INPUT_VIEW:CGFloat = 160.0
    static let HEIGHT_UTILITY_DETAIL_VIEW:CGFloat = 160.0
    static let HEIGHT_INPUT_VIEW:CGFloat = 70.0
    static let HEIGHT_CELL_UTILITYCV:CGFloat = 50.0
    static let HEIGHT_CELL_NAVIGATIONCV:CGFloat = 80.0
    static let HEIGHT_ROOM_INFOR_TITLE:CGFloat = 30.0
    static let HEIGHT_CELL_ADD_MEMBER_VIEW:CGFloat = 100.0
    static let HEIGHT_SUGGEST_ADDRESS:CGFloat = 150.0
    static let HEIGHT_SINGLE_RATE_VIEW:CGFloat = 100.0

    //MARK: Common Lenght
    static let MAX_MEMBER:Int = 10
    static let MIN_MEMBER:Int = 1
    static let MAX_PRICE:Double = 50_000_000.0
    static let MIN_PRICE:Double = 300_000.0
    static let MAX_QUANTITY:Int = 20
    static let MIN_QUANTITY:Int = 1
    static let MAX_AREA:Int = 1_000
    static let MIN_AREA:Int = 10
    static let MAX_LENGHT_ADDRESS:Int = 250
    static let MAX_LENGHT_DESCRIPTION:Int = 250
    static let MAX_LENGHT_NORMAL_TEXT:Int = 50

    //MARK: Common width
    static let WIDTH_LOCATION_VIEW:CGFloat = 100.0

    //MARK: Common
    static let MAX_Y_OFFSET:CGFloat = 50.0
    static let MAX_IMAGE:Int = 12
    static let MAX_OFFSET:Int = 12
    static let AUTHORIZED:Int = 1
    static let DECLINED:Int = 2
    static let PENDING:Int = 3
    static let ADMIN:Int = 1
    static let ROOMOWNER:Int = 2
    static let ROOMMASTER:Int = 3
    static let MEMBER:Int = 4
    static let ROOM_POST:Int = 1
    static let ROOMMATE_POST:Int = 2
    

    //MARK: NSNotification name
    static let NOTIFICATION_ACCEPT_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_ACCEPT_ROOM")
    static let NOTIFICATION_DECLINE_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_DECLINE_ROOM")
    static let NOTIFICATION_ADD_MEMBER_TO_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_ADD_MEMBER_TO_ROOM")
    static let NOTIFICATION_REMOVE_MEMBER_IN_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_REMOVE_MEMBER_IN_ROOM")
    static let NOTIFICATION_UPDATE_MEMBER_IN_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_UPDATE_MEMBER_IN_ROOM")
    
    static let NOTIFICATION_ADD_BOOKMARK:NSNotification.Name = NSNotification.Name("NOTIFICATION_ADD_BOOKMARK")
    static let NOTIFICATION_REMOVE_BOOKMARK:NSNotification.Name = NSNotification.Name("NOTIFICATION_REMOVE_BOOKMARK")
    static let NOTIFICATION_REMOVE_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_REMOVE_ROOM")
    static let NOTIFICATION_EDIT_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_EDIT_ROOM")
    static let NOTIFICATION_EDIT_ROOM_MEMBER:NSNotification.Name = NSNotification.Name("NOTIFICATION_EDIT_ROOM_MEMBER")
    static let NOTIFICATION_CREATE_ROOM:NSNotification.Name = NSNotification.Name("NOTIFICATION_CREATE_ROOM")
    
    static let NOTIFICATION_REMOVE_POST:NSNotification.Name = NSNotification.Name("NOTIFICATION_REMOVE_ROOM_POST")
    static let NOTIFICATION_REMOVE_ROOMMATE_POST:NSNotification.Name = NSNotification.Name("NOTIFICATION_REMOVE_ROOMMATE_POST")
    static let NOTIFICATION_EDIT_POST:NSNotification.Name = NSNotification.Name("NOTIFICATION_EDIT_POST")
    static let NOTIFICATION_SAVE_REFERENCE:NSNotification.Name = NSNotification.Name("NOTIFICATION_SAVE_REFERENCE")
    
    static let NOTIFICATION_CREATE_RATE:NSNotification.Name = NSNotification.Name("NOTIFICATION_CREATE_RATE")
    
    static let NOTIFICATION_EDIT_USER:NSNotification.Name = NSNotification.Name("NOTIFICATION_EDIT_USER")
    
    
    static let NOTIFICATION_SIGNOUT:NSNotification.Name = NSNotification.Name("NOTIFICATION_SIGNOUT")
    
    
}
