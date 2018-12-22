//
//  ShowAllVC.swift
//  Roommate
//
//  Created by TrinhHC on 11/6/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class ShowAllVC: BaseVC,UICollectionViewDataSource,
    UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
    UITableViewDataSource,UITableViewDelegate,
RoomCVCellDelegate,RoommateCVCellDelegate{
    
    
    
    
    
    //MARK: Components for  Orderby
    lazy var lblOrderBy:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize:.small)
        lbl.textAlignment = .right
        //        lbl.backgroundColor = .red
        lbl.text = "ORDER_TITLE".localized
        return lbl
    }()
    
    lazy var  lblSelectTitle:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightSubTitle
        lbl.font = .small
        lbl.textAlignment = .left
        lbl.text = orders[selectedOrder]?.localized
        lbl.textColor = .defaultBlue
        lbl.font = UIFont.boldSystemFont(ofSize: .verySmall)
        return lbl
    }()
    
    let imageView:UIImageView = {
        let imgv = UIImageView(image: UIImage(named: "down-arrow"))
        imgv.tintColor = .defaultBlue
        return imgv
    }()
    
    lazy var btnOrderBy:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        tv.layer.cornerRadius = 5
        tv.clipsToBounds = true
        return tv
    }()
    
    
    
    //MARK: Components for UICollectionView
    lazy var collectionView:BaseVerticalCollectionView = {
        let cv = BaseVerticalCollectionView()
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    lazy var bottomView:UIView = {
        let v = UIView()
        return v
    }()
    
    
    //MARK: Data for UICollectionView And UITableView
    
    var selectedOrder = OrderType.newest//default
    var tableHeightLayoutConstraint : NSLayoutConstraint?
    
    var roomRates:[RoomRateResponseModel] = []
    var userRates:[UserRateResponseModel] = []
    var roommates:[RoommatePostResponseModel] = []
    var rooms:[RoomPostResponseModel] = []
    var roomResponseModels:[RoomMappableModel] = []
    var baseSuggestRequestModel:BaseSuggestRequestModel = BaseSuggestRequestModel()
    var filterArgumentModel:FilterArgumentModel = {
        let filter = FilterArgumentModel()
        return filter
    }()
    var currentUserId:Int = DBManager.shared.getUser()!.userId
    var roomForOwnerAndMemberPage = 1
    var postId:Int = 0
    var roomId:Int = 0
    var userId:Int = 0
    var page:Int = 1
    let orders = [
        OrderType.newest:"NEWEST",
        OrderType.lowToHightPrice:"LOW_TO_HIGH_PRICE",
        OrderType.hightToLowPrice:"HIGH_TO_LOW_PRICE"
    ]
    var showAllVCType:ShowAllVCType = .roomPostForCreatedUser{
        didSet{
            switch showAllVCType{
            case .suggestRoom:
                baseSuggestRequestModel.offset = Constants.MAX_OFFSET
            case .roomPostForCreatedUser:
                filterArgumentModel.typeId = Constants.ROOM_POST
            case .roommatePostForCreatedUser:
                filterArgumentModel.typeId = Constants.ROOMMATE_POST
            case .roomForOwner,.roomForMember,.roomRateForRoomOwner:
                break
            default:
                break
            }
        }
    }
    var apiRouter:APIRouter!
    //MARK: Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataAndDelegate()
        registerNotification()
    }
    
    //MARK: Setup UI
    func setupUI(){
        switch showAllVCType{
        case .suggestRoom:
            title = "SUGGEST".localized
        case .roomPostForCreatedUser:
            title = "TITLE_MEMBER_CREATED_ROOM_POST".localized
        case .roommatePostForCreatedUser:
            title = "TITLE_MEMBER_CREATED_ROOMMATE_POST".localized
        case .roomForOwner:
            title = "TITLE_CREATED_ROOM".localized
        case .roomForMember:
            title = "TITLE_HISTORY_MEMBER_ROOM".localized
        case .userRate,.roomRate,.roomRateForRoomOwner:
            title = "RATE_ALL".localized
            
        }
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.backgroundColor = .white
        setBackButtonForNavigationBar()
        
        view.addSubview(bottomView)
        bottomView.addSubview(collectionView)
        switch showAllVCType{
        case .roomPostForCreatedUser,.roommatePostForCreatedUser:
            //Declare view
            let orderByView = UIView()
            
            //Add View for .suggestRoom,.roomPost,.roommatePost
            view.addSubview(orderByView)
            view.addSubview(tableView)
            orderByView.addSubview(btnOrderBy)
            orderByView.addSubview(lblOrderBy)
            btnOrderBy.addSubview(imageView)
            btnOrderBy.addSubview(lblSelectTitle)
            
            //Calculate constraint constant
            let orderByViewHeight = CGFloat(30.0)
            let orderByViewWidth = view.frame.width-Constants.MARGIN_5*4
            
            //Add Constraint
            _ = orderByView.anchor(view.topAnchor, view.leftAnchor, nil, nil, UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0), CGSize(width: orderByViewWidth, height: orderByViewHeight))
            if #available(iOS 11.0, *) {
                print(view.safeAreaLayoutGuide.topAnchor)
            } else {
                // Fallback on earlier versions
            }
            _ =  btnOrderBy.anchorTopRight(orderByView.topAnchor, orderByView.rightAnchor, 150.0, orderByViewHeight)
            _ = lblOrderBy.anchorTopRight(orderByView.topAnchor, btnOrderBy.leftAnchor, orderByViewWidth-150.0, orderByViewHeight)
            _ = imageView.anchor(btnOrderBy.topAnchor,nil,btnOrderBy.bottomAnchor,btnOrderBy.rightAnchor,UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
            _ = imageView.anchorWidth(equalTo: btnOrderBy.heightAnchor, constant: -10)
            _ = lblSelectTitle.anchor(btnOrderBy.topAnchor,btnOrderBy.leftAnchor,btnOrderBy.bottomAnchor,imageView.leftAnchor,UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
            
            //        bottomView.backgroundColor = .red
            //        collectionView.backgroundColor = .blue
            if #available(iOS 11.0, *) {
                _ = bottomView.anchor(orderByView.bottomAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
            } else {
                // Fallback on earlier versions
                _ = bottomView.anchor(orderByView.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
            }
            tableHeightLayoutConstraint = tableView.anchorTopRight(orderByView.bottomAnchor, btnOrderBy.rightAnchor, 150.0, 1)[3]
            view.bringSubview(toFront: tableView)
        case .suggestRoom,.roomForOwner,.roomForMember,.userRate,.roomRate,.roomRateForRoomOwner:
            if #available(iOS 11.0, *) {
                _ = bottomView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
            } else {
                // Fallback on earlier versions
                _ = bottomView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
            }
        }
        _ = collectionView.anchor(view: bottomView)
    }
    
    func setupDataAndDelegate(){
        //Event for BtnOrderBy
        btnOrderBy.addTarget(self, action: #selector(updateUIWhenClickBtnOrder), for: .touchUpInside)
        
        
        //Register delegate , datasource & cell collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.CELL_ROOMMATEPOSTCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMMATEPOSTCV)
        collectionView.register(UINib(nibName: Constants.CELL_ROOMPOSTCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMPOSTCV)
        collectionView.register(UINib(nibName: Constants.CELL_ROOMCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMCV)
        collectionView.register(UINib(nibName: Constants.CELL_RATECV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_RATECV)
        
        //Register delegate , datasource & cell tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderTVCell.self, forCellReuseIdentifier: Constants.CELL_ORDERTV)
        
        
        switch showAllVCType{
        case .suggestRoom:
            self.apiRouter = APIRouter.suggest(model: baseSuggestRequestModel)
            loadRoomData(withNewFilterArgModel: true)
        case .roomForMember:
            self.apiRouter = APIRouter.getHistoryRoom(userId: currentUserId, page: roomForOwnerAndMemberPage, size: Constants.MAX_OFFSET)
            loadRoomForOwnerOrMemberData(withNewFilterArgModel: true)
        case .roomForOwner:
            self.apiRouter = APIRouter.getRoomsByUserId(userId: currentUserId, page: roomForOwnerAndMemberPage, size: Constants.MAX_OFFSET)
            loadRoomForOwnerOrMemberData(withNewFilterArgModel: true)
        case .roomPostForCreatedUser:
            self.apiRouter = APIRouter.getUserPost(model: filterArgumentModel)
            loadRoomData(withNewFilterArgModel: true)
        case .roommatePostForCreatedUser:
            self.apiRouter = APIRouter.getUserPost(model: filterArgumentModel)
            loadRoommateData(withNewFilterArgModel: true)
        case .userRate:
            self.apiRouter = APIRouter.getUserRates(userId: userId, page: page, size: Constants.MAX_OFFSET)
            loadUserRateData(withNewFilterArgModel:  true)
        case .roomRate:
            self.apiRouter = APIRouter.getRoomRatesByPostId(postId: postId, page: page, size: Constants.MAX_OFFSET)
            loadRoomRateData(withNewFilterArgModel:  true)
        case .roomRateForRoomOwner:
            self.apiRouter = APIRouter.getRoomRatesByRoomId(roomId: roomId, page: page, size: Constants.MAX_OFFSET)
            loadRoomRateData(withNewFilterArgModel:  true)
        }
    }
    //MARK: Notification
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditPostNotification(_:)), name: Constants.NOTIFICATION_EDIT_POST, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveRemoveRoomNotification(_:)), name: Constants.NOTIFICATION_REMOVE_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditRoomNotification(_:)), name: Constants.NOTIFICATION_EDIT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAcceptRoomNotification(_:)), name: Constants.NOTIFICATION_ACCEPT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveDeclineRoomNotification(_:)), name: Constants.NOTIFICATION_DECLINE_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveRemovePostNotification(_:)), name: Constants.NOTIFICATION_REMOVE_POST, object: nil)
    }
    @objc func didReceiveEditPostNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomPostRequestModel {
                guard let model = notification.object as? RoomPostRequestModel, let index = self.rooms.index(of: RoomPostResponseModel(postId: model.postId)) else{
                    return
                }
                self.rooms[index].model = model
                
            }else{
                guard let model = notification.object as? RoommatePostRequestModel, let index = self.roommates.index(of: RoommatePostResponseModel(postId: model.postId)) else{
                    return
                }
                self.roommates[index].model = model
            }
            self.collectionView.reloadData()
        }
    }
    @objc func didReceiveRemoveRoomNotification(_ notification:Notification){
        
        DispatchQueue.main.async {
            switch self.showAllVCType{
            case .roomForOwner:
                self.rooms.removeAll()
                self.loadRoomForOwnerOrMemberData(withNewFilterArgModel: true)
            default:
                break
            }
        }
    }
    
    @objc func didReceiveEditRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            switch self.showAllVCType{
            case .roomForOwner:
                if notification.object is RoomMappableModel {
                    guard let room = notification.object as? RoomMappableModel, let index = self.roomResponseModels.index(of: room) else{
                        return
                    }
                    self.roomResponseModels[index] = room
                    self.collectionView.reloadData()
                }
            default:
                break
            }
        }
        
    }
    
    @objc func didReceiveAcceptRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel, let index = self.roomResponseModels.index(of: RoomMappableModel(roomId: notification.roomId!)) else{
                    return
                }
                self.roomResponseModels[index].statusId = Constants.AUTHORIZED
                self.collectionView.reloadData()
            }
        }
        
    }
    
    @objc func didReceiveRemovePostNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomPostResponseModel {
                guard let model = notification.object as? RoomPostResponseModel, let index = self.rooms.index(of: RoomPostResponseModel(postId: model.postId)) else{
                    return
                }
                self.rooms[index] = model
                self.collectionView.reloadData()
            }else if notification.object is RoommatePostResponseModel {
                guard let model = notification.object as? RoommatePostResponseModel, let index = self.roommates.index(of: RoommatePostResponseModel(postId: model.postId)) else{
                    return
                }
                self.roommates[index] = model
                self.collectionView.reloadData()
            }
        }
        
    }
    
    @objc func didReceiveDeclineRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel, let index = self.roomResponseModels.index(of: RoomMappableModel(roomId: notification.roomId!)) else{
                    return
                }
                
                self.roomResponseModels[index].statusId = Constants.DECLINED
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Remote Data
    
    func loadRoomData(withNewFilterArgModel:Bool){
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                //                self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
                
                self.requestRoomPost(apiRouter:self.apiRouter,withNewFilterArgModel: withNewFilterArgModel)
                //                }
            }
        }else{
            //            self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
            self.requestRoomPost(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
            //            }
        }
    }
    func loadRoommateData(withNewFilterArgModel:Bool){
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                //                self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
                self.requestRoommatePost(apiRouter: self.apiRouter,withNewFilterArgModel: withNewFilterArgModel)
                //                }
            }
        }else{
            //            self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
            self.requestRoommatePost(apiRouter:self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
            //            }
        }
    }
    
    func loadRoomForOwnerOrMemberData(withNewFilterArgModel:Bool){
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                //                self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
                self.requestRoom(apiRouter:self.apiRouter,withNewFilterArgModel: withNewFilterArgModel)
                //                }
            }
        }else{
            //            self.checkAndLoadInitData(inView: self.bottomView) { () -> (Void) in
            self.requestRoom(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
            //            }
        }
    }
    
    func loadUserRateData(withNewFilterArgModel:Bool){
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                self.requestUserRate(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
            }
        }else{
            self.requestUserRate(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
        }
    }
    func loadRoomRateData(withNewFilterArgModel:Bool){
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                self.requestRoomRate(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
            }
        }else{
            self.requestRoomRate(apiRouter: self.apiRouter, withNewFilterArgModel: withNewFilterArgModel)
        }
    }
    func  requestRoomPost(apiRouter:APIRouter,withNewFilterArgModel newFilterArgModel:Bool){
        DispatchQueue.main.async {
            if newFilterArgModel{
                self.rooms.removeAll()
                self.collectionView.reloadData()
            }
            let hub = MBProgressHUD.showAdded(to: self.bottomView, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            //            hub.label.text = "MB_LOAD_DATA_TITLE".localized
            //            MBProgressHUD.showAdded(to: self.bottomView, animated: true)
        }
        
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType: RoomPostResponseModel.self) { (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.bottomView, animated: true)
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorView(inView: self.bottomView, withTitle: error == .SERVER_NOT_RESPONSE ? "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoomPost(apiRouter: apiRouter, withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        if newFilterArgModel {
                            self.rooms.removeAll()
                        }
                        if values.count == 0, self.filterArgumentModel.page! > 1{
                            self.filterArgumentModel.page = self.filterArgumentModel.page!-1
                        }
                        self.rooms.append(contentsOf: values)
                        DispatchQueue.main.async {
                            if self.rooms.isEmpty{
                                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                            }
                            self.collectionView.reloadData()
                            //                            self.isLoadingData = false
                        }
                    }else if statusCode == .NotFound{
                        self.rooms.removeAll()
                        self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                    }
                }
            }
        }
    }
    
    func  requestRoommatePost(apiRouter:APIRouter,withNewFilterArgModel newFilterArgModel:Bool){
        DispatchQueue.main.async {
            if newFilterArgModel{
                self.roommates.removeAll()
                self.collectionView.reloadData()
            }
            let hub = MBProgressHUD.showAdded(to: self.bottomView, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            //            hub.label.text = "MB_LOAD_DATA_TITLE".localized
            //            MBProgressHUD.showAdded(to: self.bottomView, animated: true)
        }
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType: RoommatePostResponseModel.self) { (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.bottomView, animated: true)
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorView(inView: self.bottomView, withTitle: error == .SERVER_NOT_RESPONSE ? "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoommatePost(apiRouter: apiRouter, withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        if newFilterArgModel { self.roommates.removeAll()}
                        if values.count == 0, self.filterArgumentModel.page! > 1{
                            self.filterArgumentModel.page = self.filterArgumentModel.page!-1
                        }
                        self.roommates.append(contentsOf: values)
                        DispatchQueue.main.async {
                            if self.roommates.isEmpty{
                                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                            }
                            self.collectionView.reloadData()
                        }
                    }else if statusCode == .NotFound{
                        self.roommates.removeAll()
                        self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                    }
                }
            }
        }
    }
    func  requestRoom(apiRouter:APIRouter,withNewFilterArgModel newFilterArgModel:Bool){
        DispatchQueue.main.async {
            if newFilterArgModel{
                self.roomResponseModels.removeAll()
                self.collectionView.reloadData()
            }
            let hub = MBProgressHUD.showAdded(to: self.bottomView, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
        }
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType: RoomMappableModel.self){ (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.bottomView, animated: true)
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorView(inView: self.bottomView, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoom(apiRouter: apiRouter,withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        if newFilterArgModel { self.roomResponseModels.removeAll()}
                        if values.count == 0, self.roomForOwnerAndMemberPage > 1{
                            self.roomForOwnerAndMemberPage = self.roomForOwnerAndMemberPage-1
                        }
                        self.roomResponseModels.append(contentsOf: values)
                        DispatchQueue.main.async {
                            if self.roomResponseModels.isEmpty{
                                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                            }
                            self.collectionView.reloadData()
                            //                            self.isLoadingData = false
                        }
                    }else if statusCode == .NotFound{
                        self.roomResponseModels.removeAll()
                        self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                    }
                    
                }
            }
        }
    }
    
    
    func  requestUserRate(apiRouter:APIRouter,withNewFilterArgModel newFilterArgModel:Bool){
        DispatchQueue.main.async {
            if newFilterArgModel{
                if self.showAllVCType == .userRate{
                    self.userRates.removeAll()
                }else{
                    self.roomRates.removeAll()
                }
                
                self.collectionView.reloadData()
            }
            let hub = MBProgressHUD.showAdded(to: self.bottomView, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
        }
        
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType:UserRateResponseModel.self){ (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.bottomView, animated: true)
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorView(inView: self.bottomView, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestUserRate(apiRouter: apiRouter,withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        if values.count == 0, self.page > 1{
                            self.page = self.page-1
                        }
                        self.userRates.append(contentsOf: values)
                        
                        DispatchQueue.main.async {
                            if self.userRates.isEmpty{
                                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                            }
                            self.collectionView.reloadData()
                            //                            self.isLoadingData = false
                        }
                    }else if statusCode == .NotFound{
                        self.showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestUserRate(apiRouter: apiRouter,withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                    
                }
            }
        }
    }
    
    func  requestRoomRate(apiRouter:APIRouter,withNewFilterArgModel newFilterArgModel:Bool){
        DispatchQueue.main.async {
            if newFilterArgModel{
                if self.showAllVCType == .userRate{
                    self.userRates.removeAll()
                }else{
                    self.roomRates.removeAll()
                }
                
                self.collectionView.reloadData()
            }
            let hub = MBProgressHUD.showAdded(to: self.bottomView, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
        }
        
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType:RoomRateResponseModel.self){ (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.bottomView, animated: true)
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorView(inView: self.bottomView, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoomRate(apiRouter: apiRouter,withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        if values.count == 0, self.page > 1{
                            self.page = self.page-1
                        }
                        self.roomRates.append(contentsOf: values)
                        
                        DispatchQueue.main.async {
                            if self.roomRates.isEmpty{
                                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
                            }
                            self.collectionView.reloadData()
                            //                            self.isLoadingData = false
                        }
                    }else if statusCode == .NotFound{
                        self.showErrorView(inView: self.bottomView, withTitle: "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoomRate(apiRouter: apiRouter,withNewFilterArgModel: newFilterArgModel)
                        })
                    }
                    
                }
            }
        }
    }
    
    //MARK: UICollectionView DataSourse and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch showAllVCType{
        case .suggestRoom,.roomPostForCreatedUser:
            return rooms.count
        case .roommatePostForCreatedUser:
            return roommates.count
        case .roomForOwner,.roomForMember:
            return roomResponseModels.count
        case .roomRate,.roomRateForRoomOwner:
            return roomRates.count
        case .userRate:
            return userRates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch showAllVCType{
        case .suggestRoom,.roomPostForCreatedUser:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMPOSTCV, for: indexPath) as! RoomPostCVCell
            cell.delegate = self
            cell.room = rooms[indexPath.row]
            cell.indexPath = indexPath
            return cell
        case .roommatePostForCreatedUser:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMMATEPOSTCV, for: indexPath) as! RoommatePostCVCell
            cell.delegate = self
            cell.roommate = roommates[indexPath.row]
            cell.indexPath = indexPath
            return cell
        case .roomForOwner,.roomForMember:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMCV, for: indexPath) as! RoomCVCell
            cell.room = roomResponseModels[indexPath.row]
            return cell
        case .roomRate,.roomRateForRoomOwner,.userRate:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_RATECV, for: indexPath) as! RateCVCell
            if showAllVCType == .userRate{
                cell.userRateResponseModel = userRates[indexPath.row]
            }else{
                cell.roomRateResponseModel = roomRates[indexPath.row]
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch showAllVCType{
        case .suggestRoom,.roomPostForCreatedUser:
            let vc = PostDetailVC()
            
            vc.viewType = showAllVCType == .suggestRoom ? .roomPostDetailForFinder : .roomPostDetailForCreatedUser
            vc.room = rooms[indexPath.row]
            //            let mainVC = UIViewController()
            //            let nv = UINavigationController(rootViewController: mainVC)
            //            present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
            presentInNewNavigationController(viewController: vc)
        case .roommatePostForCreatedUser:
            let vc = PostDetailVC()
            vc.viewType = showAllVCType == .suggestRoom ? .roommatePostDetailForFinder : .roommatePostDetailForCreatedUser
            vc.roommate = roommates[indexPath.row]
            //            let mainVC = UIViewController()
            //            let nv = UINavigationController(rootViewController: mainVC)
            //            present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
            presentInNewNavigationController(viewController: vc)
        case .roomForOwner:
            let vc = RoomDetailVC()
            vc.viewType = .detailForOwner
            vc.room = roomResponseModels[indexPath.row]
            //            let mainVC = UIViewController()
            //            let nv = UINavigationController(rootViewController: mainVC)
            //            present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
            presentInNewNavigationController(viewController: vc)
        case .roomForMember:
            let vc = RoomDetailVC()
            vc.viewType = .detailForMember
            vc.room = roomResponseModels[indexPath.row]
            //            let mainVC = UIViewController()
            //            let nv = UINavigationController(rootViewController: mainVC)
            //            present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
            presentInNewNavigationController(viewController: vc)
        case .roomRate,.userRate,.roomRateForRoomOwner:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch showAllVCType{
        case .suggestRoom,.roomPostForCreatedUser:
            return CGSize(width: collectionView.frame.width/2-5, height: Constants.HEIGHT_CELL_ROOMPOSTCV)
        case .roommatePostForCreatedUser:
            return CGSize(width: collectionView.frame.width, height: Constants.HEIGHT_CELL_ROOMMATEPOSTCV)
        case .roomForOwner,.roomForMember:
            return CGSize(width: collectionView.frame.width, height: Constants.HEIGHT_CELL_ROOMFOROWNERCV)
        case .roomRate,.roomRateForRoomOwner,.userRate:
            return CGSize(width: collectionView.frame.width, height: Constants.HEIGHT_CELL_RATECV)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //dif row space
        return 2
    }
    
    //MARK: UIScrollviewDelegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        print("OFFSET:\(scrollView.contentOffset.y)")
        print("ContentframeHeight:\(scrollView.frame.height)")
        print("ContentContentHeight:\(scrollView.contentSize.height)")
        print("Refresh Data:\(offset < -Constants.MAX_Y_OFFSET)")
        print("Load more data:\((offset - contentHeight + scrollView.frame.height) > Constants.MAX_Y_OFFSET)")
        if offset < -Constants.MAX_Y_OFFSET {
            
            switch showAllVCType{
            case .suggestRoom:
                baseSuggestRequestModel.page = 1
                loadRoomData(withNewFilterArgModel: true)
            case .roomPostForCreatedUser:
                filterArgumentModel.page = 1
                loadRoomData(withNewFilterArgModel: true)
            case .roommatePostForCreatedUser:
                filterArgumentModel.page = 1
                loadRoommateData(withNewFilterArgModel: true)
            case .roomForOwner,.roomForMember:
                roomForOwnerAndMemberPage = 1
                loadRoomData(withNewFilterArgModel: true)
            case .roomRate,.roomRateForRoomOwner:
                page = 1
                loadRoomRateData(withNewFilterArgModel: true)
            case .userRate:
                page = 1
                loadUserRateData(withNewFilterArgModel: true)
            }
            //Load more data
            //because offset = 0 when view loading ==> need to plus scrollView.frame.height
            //to equal contentHeight
        }else if (offset - contentHeight + scrollView.frame.height) > Constants.MAX_Y_OFFSET{
            //            isLoadingData = true
            print("Loading more data")
            switch showAllVCType{
            case .suggestRoom:
                baseSuggestRequestModel.page = rooms.count/Constants.MAX_OFFSET+2
                loadRoomData(withNewFilterArgModel: false)
            case .roomPostForCreatedUser:
                filterArgumentModel.page = rooms.count/Constants.MAX_OFFSET+2
                loadRoomData(withNewFilterArgModel: false)
            case .roommatePostForCreatedUser:
                filterArgumentModel.page = roommates.count/Constants.MAX_OFFSET+2
                loadRoommateData(withNewFilterArgModel: false)
            case .roomForOwner,.roomForMember:
                roomForOwnerAndMemberPage = roomResponseModels.count/Constants.MAX_OFFSET+2
                loadRoommateData(withNewFilterArgModel: false)
            case .userRate:
                page = showAllVCType == .userRate ? userRates.count/Constants.MAX_OFFSET+2 : roomRates.count/Constants.MAX_OFFSET+2
                loadUserRateData(withNewFilterArgModel: true)
            case .roomRate,.roomRateForRoomOwner:
                page = showAllVCType == .userRate ? userRates.count/Constants.MAX_OFFSET+2 : roomRates.count/Constants.MAX_OFFSET+2
                loadRoomRateData(withNewFilterArgModel: true)
            }
        }
    }
    
    //MARK: UITableView DataSourse and Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ORDERTV, for: indexPath) as! OrderTVCell
        setCellValueBaseOnIndexPath(cell: cell,indexPath:indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.isTableVisible = true
        selectedOrder = OrderType(rawValue: indexPath.row)!
        lblSelectTitle.text = orders[selectedOrder]?.localized
        //Need to change method to updateUIWhenClickBtnOrder
        updateUIWhenClickBtnOrder()
        switch showAllVCType{
        case .suggestRoom,.roomPostForCreatedUser:
            filterArgumentModel.page = 1
            loadRoomData(withNewFilterArgModel: true)
        case .roommatePostForCreatedUser:
            filterArgumentModel.orderBy = indexPath.row + 1
            filterArgumentModel.page = 1
            loadRoommateData(withNewFilterArgModel: true)
        default:
            break
        }
        
        
    }
    
    //Order button item event
    @objc func updateUIWhenClickBtnOrder(){
        
        UIView.animate(withDuration: 0.1) {
            if self.tableHeightLayoutConstraint?.constant == 0 {
                self.tableHeightLayoutConstraint?.constant = 150
            }else{
                self.tableHeightLayoutConstraint?.constant = 0
            }
            //            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func roomCVCellDelegate(roomCVCell: RoomPostCVCell, onClickUIImageView imageView: UIImageView,atIndextPath indexPath:IndexPath?) {
        guard let row = indexPath?.row else{
            return
        }
        processBookmark(view: self.collectionView, model: rooms[row], row: row){model in
            if model.isFavourite!{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
            }else{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func roommateCVCellDelegate(roommateCVCell cell: RoommatePostCVCell, onClickUIImageView imgvBookmark: UIImageView, atIndextPath indexPath: IndexPath?) {
        guard let row = indexPath?.row else{
            return
        }
        processBookmark(view: self.collectionView, model: roommates[row], row: row){model in
            if model.isFavourite!{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
            }else{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    //MARK: Others custom method
    func setCellValueBaseOnIndexPath(cell:OrderTVCell,indexPath:IndexPath){
        if indexPath.row == OrderType.newest.rawValue{
            cell.setOrderTitle(title: orders[OrderType.newest]!, orderType: OrderType.newest)
        }else if indexPath.row == OrderType.lowToHightPrice.rawValue{
            cell.setOrderTitle(title: orders[OrderType.lowToHightPrice]!, orderType: OrderType.lowToHightPrice)
        }else if  indexPath.row == OrderType.hightToLowPrice.rawValue{
            cell.setOrderTitle(title: orders[OrderType.hightToLowPrice]!, orderType: OrderType.hightToLowPrice)
        }else{
            //for future order type
        }
    }
    
    
    
}
