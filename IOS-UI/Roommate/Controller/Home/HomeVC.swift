//
//  HomeVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import CoreLocation
import FirebaseDatabase
class HomeVC:BaseAutoHideNavigationVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalRoomViewDelegate,VerticalCollectionViewDelegate,LocationSearchViewDelegate,CLLocationManagerDelegate,UISearchControllerDelegate,UISearchBarDelegate{
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate =  self
        return sv
    }()
    
    
    
    lazy var contentView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .red
        return v
    }()
    lazy var searchController:UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate  = self
        //        sc.searchResultsUpdater = searchResultVC //Show this vc for result
        //        sc.dimsBackgroundDuringPresentation = true //Làm mờ khi show result vc
        //        definesPresentationContext = true //Modal type - show result vc over parent vc
        //
        sc.searchBar.delegate = self
        // searchBar represent for searchcontroller in parent vc
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .prominent
        sc.searchBar.placeholder = "Search Place"
        sc.searchBar.sizeToFit()
        sc.searchBar.barTintColor = .red
        sc.searchBar.tintColor = .defaultBlue
        return sc
    }()
    
    lazy var searchResultVC = SearchVC()
    
    lazy  var topContainerView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .blue
        return v
    }()
    
    lazy var bottomContainerView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .blue
        return v
    }()
    
    lazy var locationSearchView:LocationSearchView = {
        let lv:LocationSearchView = .fromNib()
        return lv
    }()
    
    lazy var topNavigation:BaseHorizontalCollectionView = {
        let bv = BaseHorizontalCollectionView()
        return bv
    }()
    
    lazy var suggestRoomPostView:HorizontalRoomView = {
        let hv:HorizontalRoomView  = .fromNib()
        return hv
    }()
    
    lazy var newRoomPostView:VerticalCollectionView = {
        let vv:VerticalCollectionView = .fromNib()
        vv.verticalCollectionViewType = .newRoomPost
        return vv
    }()
    lazy var newRoommatePostView:VerticalCollectionView = {
        let vv:VerticalCollectionView = .fromNib()
        vv.verticalCollectionViewType = .newRoommatePost
        return vv
    }()
    var cities:[CityModel]?
    var suggestRooms:[RoomPostResponseModel] = []
    var newRooms:[RoomPostResponseModel] = []
    var newRoommates:[RoommatePostResponseModel] = []
    var city:CityModel?
    var filterForRoomPost = FilterArgumentModel()
    var filterForRoommatePost = FilterArgumentModel()
    var baseSuggestRequestModel = BaseSuggestRequestModel()
    var setting:SettingMappableModel?{
        get{
            return SettingMappableModel(settingModel: DBManager.shared.getSingletonModel(ofType: SettingModel.self) ?? SettingModel())
        }
    }
    var actionsForRoomMaster:[[String]] = [
        ["Tìm phòng","find-room"],
        ["Tìm bạn","find-roommate"],
        ["Đăng tìm phòng","add-roommate"],
        ["Đăng tìm bạn","add-room"]
    ]
    var actionsForMember:[[String]] = [
        ["Tìm phòng","find-room"],
        ["Tìm bạn","find-roommate"],
        ["Đăng tìm phòng","add-roommate"]
    ]
    var actionsForOnwer:[[String]] = [
        ["Đăng phòng","add-room"],
        ["Quản lý phòng","account"]
    ]
    lazy var user = UserMappableModel(userModel: DBManager.shared.getUser()!)
    lazy var ref = Database.database().reference().child("notifications/users").child("\(self.user.userId)")
    var suggestRoomViewHeightConstraint:NSLayoutConstraint?
    var newRoomViewHeightConstraint:NSLayoutConstraint?
    var newRoommateViewHeightConstraint:NSLayoutConstraint?
    var contentViewHeightConstraint:NSLayoutConstraint?
    
    
    //MARK:ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndLoadInitData(view: self.view){
            self.setupUI()
            self.setupDelegateAndDataSource()
            self.enableLocationServices()
            self.loadRemoteData()
            self.registerNotification()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    //MARK: Setup UI and Delegate
    func setupUI(){
        transparentNavigationBarBottomBorder()
        //        extendedLayoutIncludesOpaqueBars = true
        let suggestRoomViewHeight:CGFloat = Constants.HEIGHT_DEFAULT_BEFORE_LOAD_DATA
        let newRoomViewHeight:CGFloat = Constants.HEIGHT_DEFAULT_BEFORE_LOAD_DATA
        let newRoommmateViewHeight:CGFloat = Constants.HEIGHT_DEFAULT_BEFORE_LOAD_DATA
        let totalContentViewHeight:CGFloat
        navigationItem.titleView = searchController.searchBar
        let leftItem = UIBarButtonItem(customView: locationSearchView)
        _ = leftItem.customView?.anchorHeight(equalToConstrant: navigationItem.titleView!.frame.height)
        _ = leftItem.customView?.anchorWidth(equalToConstrant: Constants.WIDTH_LOCATION_VIEW)
        navigationItem.leftBarButtonItem = leftItem
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topContainerView)
        contentView.addSubview(bottomContainerView)
        topContainerView.addSubview(topNavigation)
        bottomContainerView.addSubview(newRoomPostView)
        bottomContainerView.addSubview(newRoommatePostView)
        
        
        if user.roleId != 2{
            totalContentViewHeight = newRoomViewHeight + newRoommmateViewHeight + Constants.HEIGHT_TOP_CONTAINER_VIEW + suggestRoomViewHeight
            bottomContainerView.addSubview(suggestRoomPostView)
        }else{
            totalContentViewHeight = newRoomViewHeight + newRoommmateViewHeight + Constants.HEIGHT_TOP_CONTAINER_VIEW
        }
        
        
        if #available(iOS 11.0, *) {
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        } else {
            // Fallback on earlier versions
            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        }
        _ = contentView.anchor(view: scrollView)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        contentViewHeightConstraint = contentView.anchorHeight(equalToConstrant: totalContentViewHeight)
        
        _ = topContainerView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero, CGSize(width: 0, height: Constants.HEIGHT_TOP_CONTAINER_VIEW))
        //        _ = locationSearchView.anchor(topContainerView.topAnchor, topContainerView.leftAnchor, nil, topContainerView.rightAnchor, UIEdgeInsets(top: Constants.MARGIN_10, left: Constants.MARGIN_20, bottom: 0, right: -Constants.MARGIN_20), CGSize(width: 0, height: Constants.HEIGHT_LOCATION_SEARCH_VIEW))
        
        
        _ = topNavigation.anchor(topContainerView.topAnchor, topContainerView.leftAnchor, topContainerView.bottomAnchor, topContainerView.rightAnchor)
        
        topNavigation.backgroundColor = UIColor(hexString: "f7f7f7")
        topContainerView.layer.borderWidth  = 1
        topContainerView.layer.borderColor  = UIColor.lightGray.cgColor
        topContainerView.layer.cornerRadius = 15
        topContainerView.clipsToBounds = true
        
        _ = bottomContainerView.anchor(topContainerView.bottomAnchor, contentView.leftAnchor, contentView.bottomAnchor, contentView.rightAnchor)
        
        if user.roleId != 2{
            suggestRoomViewHeightConstraint = suggestRoomPostView.anchor(bottomContainerView.topAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height:
                suggestRoomViewHeight))[3]
            newRoomViewHeightConstraint = newRoomPostView.anchor(suggestRoomPostView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: newRoomViewHeight))[3]
        }else{
            newRoomViewHeightConstraint = newRoomPostView.anchor(bottomContainerView.topAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: newRoomViewHeight))[3]
        }
        newRoommateViewHeightConstraint = newRoommatePostView.anchor(newRoomPostView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: newRoommmateViewHeight))[3]
        
        
        //hide bottom button
        newRoomPostView.hidebtnViewAllButton()
        newRoommatePostView.hidebtnViewAllButton()
    }
    func setupDelegateAndDataSource(){
        //        horizontalRoomView.collectionView
        topNavigation.dataSource = self
        topNavigation.delegate = self
        topNavigation.register(UINib(nibName: Constants.CELL_NAVIGATIONCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_NAVIGATIONCV)
        locationSearchView.delegate = self
        newRoommatePostView.delegate = self
        newRoomPostView.delegate = self
        if user.roleId != 2{suggestRoomPostView.delegate = self}
        
        
        filterForRoomPost.filterRequestModel = nil
        filterForRoommatePost.typeId = Constants.ROOM_POST
        filterForRoomPost.cityId = setting?.cityId
        
        filterForRoommatePost.filterRequestModel = nil
        filterForRoommatePost.cityId = setting?.cityId
        filterForRoommatePost.typeId = Constants.ROOMMATE_POST
    }
    
    //MARK: Notification
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAddBookmarkNotification(_:)), name: Constants.NOTIFICATION_ADD_BOOKMARK, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveRemoveBookmarkNotification(_:)), name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAddMemberToRoomNotification(_:)), name: Constants.NOTIFICATION_ADD_MEMBER_TO_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveUpdateMemberInRoomNotification(_:)), name: Constants.NOTIFICATION_UPDATE_MEMBER_IN_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveRemoveMemberFromRoomNotification(_:)), name: Constants.NOTIFICATION_REMOVE_MEMBER_IN_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveSaveReferenceNotification(_:)), name: Constants.NOTIFICATION_SAVE_REFERENCE, object: nil)
        
    }
    @objc func didReceiveRemoveBookmarkNotification(_ notification:Notification) {
        DispatchQueue.global(qos: .userInteractive).async   {
            if notification.object is RoomPostResponseModel{
                if let room = notification.object as? RoomPostResponseModel{
                    if let index = self.newRooms.index(of: room){
                        self.newRooms[index].isFavourite = room.isFavourite
                        DispatchQueue.main.async{
                        self.newRoomPostView.collectionView.reloadData()
                    }
                    }
                    if self.user.roleId != 2{
                        if let index = self.suggestRooms.index(of: room){
                            self.suggestRooms[index].isFavourite = room.isFavourite
                            DispatchQueue.main.async{
                            self.suggestRoomPostView.collectionView.reloadData()
                            }
                        }
                    }
                }
            }else{
                if let roommate = notification.object as? RoommatePostResponseModel{
                    if let index = self.newRoommates.index(of: roommate){
                        self.newRoommates[index].isFavourite = roommate.isFavourite
                        DispatchQueue.main.async{
                        self.newRoommatePostView.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    @objc func didReceiveAddBookmarkNotification(_ notification:Notification) {
        DispatchQueue.global(qos: .userInteractive).async  {
            if notification.object is RoomPostResponseModel{
                if let room = notification.object as? RoomPostResponseModel{
                    if let index = self.newRooms.index(of: room){
                        self.newRooms[index].isFavourite = room.isFavourite
                        self.newRooms[index].favouriteId = room.favouriteId
                        DispatchQueue.main.async{
                            self.newRoomPostView.collectionView.reloadData()
                        }
                    }
                    if self.user.roleId != 2{
                        if let index = self.suggestRooms.index(of: room){
                            self.suggestRooms[index].isFavourite = room.isFavourite
                            self.suggestRooms[index].favouriteId = room.favouriteId
                            DispatchQueue.main.async{
                            self.suggestRoomPostView.collectionView.reloadData()
                            }
                        }
                    }
                }
            }else{
                if let roommate = notification.object as? RoommatePostResponseModel{
                    if let index = self.newRoommates.index(of: roommate){
                        self.newRoommates[index].isFavourite = roommate.isFavourite
                        self.newRoommates[index].favouriteId = roommate.favouriteId
                        DispatchQueue.main.async{
                            self.newRoommatePostView.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    @objc func didReceiveAddMemberToRoomNotification(_ notification:Notification){
        updateUIForRoleInRoomNotification(notification)
    }
    @objc func didReceiveRemoveMemberFromRoomNotification(_ notification:Notification){
        updateUIForRoleInRoomNotification(notification)
        
    }
    
    @objc func didReceiveUpdateMemberInRoomNotification(_ notification:Notification){
        updateUIForRoleInRoomNotification(notification)
    }
    
    @objc func didReceiveSaveReferenceNotification(_ notification:Notification){
        self.baseSuggestRequestModel = BaseSuggestRequestModel()
        self.requestRoom(view: self.suggestRoomPostView.collectionView, apiRouter:
            APIRouter.suggest(model: self.baseSuggestRequestModel), offset:Constants.MAX_POST)
    }
    func updateUIForRoleInRoomNotification(_ notification:Notification){
        DispatchQueue.global(qos: .userInteractive).async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel else{
                    return
                }
                
                
//                if isRequestCurrentRoom{
//                    self.requestCurrentRoom()
//                }
                self.user.roleId = notification.roleId!
                _ = DBManager.shared.addSingletonModel(ofType: UserModel.self, object: UserModel(userMappedModel: self.user))
                DispatchQueue.main.async {
                    self.topNavigation.reloadData()
                }
                
                self.ref.child(notification.notificationId).child("status").setValue("\(Constants.NEW_LOADED)")
//                if r
////                DispatchQueue.main.async {
////                    let hub = MBProgressHUD.showAdded(to: self.topNavigation, animated: true)
////                    hub.mode = .indeterminate
////                    hub.bezelView.backgroundColor = .white
////                    hub.contentColor = .defaultBlue
////                }
//                DispatchQueue.global(qos: .background).async {
//                    self.requestCurrentRoom()
////                    DispatchQueue.main.async {
////                        MBProgressHUD.hide(for: self.topNavigation, animated: true)
////                    }
//                }
                
                
                
            }
        }
    }
    //MARK: Setup UI and Delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let vc = SearchResultsVC()
        presentInNewNavigationController(viewController: vc)
        return false
    }
    //MARK: Remote Data
    func loadRemoteData(){
        
//        if !APIConnection.isConnectedInternet(){
//            showErrorView(inView: self.view, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
//                self.loadRemoteData()
//            }
//        }else{
//            self.checkAndLoadInitData(inView: self.view) { () -> (Void) in
                self.locationSearchView.location = DBManager.shared.getRecord(id: (self.setting?.cityId)!, ofType: CityModel.self)?.name ?? "LIST_CITY_TITLE".localized
                self.cities = DBManager.shared.getRecords(ofType: CityModel.self)?.toArray(type: CityModel.self)
                if self.user.roleId != Constants.ROOMOWNER{
                    self.requestRoom(view: self.suggestRoomPostView.collectionView, apiRouter:
                        APIRouter.suggest(model: self.baseSuggestRequestModel), offset:Constants.MAX_POST)
                }
                self.requestRoom(view: self.newRoomPostView.collectionView,  apiRouter: APIRouter.postForAll(model: self.filterForRoomPost), offset:Constants.MAX_POST)
                self.requestRoommate(view: self.newRoommatePostView.collectionView, apiRouter: APIRouter.postForAll(model: self.filterForRoommatePost), offset:Constants.MAX_POST)
        
        
        
        
        
    }
    
    
    func  requestRoom(view:UICollectionView,apiRouter:APIRouter,offset:Int){
        //        roomFilter.searchRequestModel = nil
        if view == self.suggestRoomPostView.collectionView{
            let setting = DBManager.shared.getSingletonModel(ofType: SettingModel.self)
            baseSuggestRequestModel.offset = offset
//            baseSuggestRequestModel.latitude = setting?.latitude.value
//            baseSuggestRequestModel.longitude = setting?.longitude.value
        }else if view == self.newRoomPostView.collectionView{
            filterForRoomPost.offset = offset
        }
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            //            hub.label.text = "MB_LOAD_DATA_TITLE".localized
            //            MBProgressHUD.showAdded(to: self.bottomView, animated: true)
        }
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType:RoomPostResponseModel.self){ (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    print("Hide hub for \(view)")
                    MBProgressHUD.hide(for: view, animated: true)
                }
                //404, cant parse
                if error != nil{
                    DispatchQueue.main.async {
                        self.showErrorView(inView: view, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoom(view: view, apiRouter: apiRouter, offset:offset)
                        })
                    }
                }else{
                    //200
                    print("Load Data completed for \(apiRouter)")
                    if statusCode == .OK{
                        guard let values = values else{
                            //                        APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.PARSE_RESPONSE_FAIL)
                            //                        self.group.leave()
                            return
                        }
                        
                        if values.count != 0{
                            
                            if view == self.suggestRoomPostView.collectionView{
                                self.suggestRooms.removeAll()
                                self.suggestRooms.append(contentsOf: values)
                                self.suggestRoomPostView.rooms = self.suggestRooms
                                DispatchQueue.main.async { self.suggestRoomPostView.translatesAutoresizingMaskIntoConstraints = false
                                    self.suggestRoomViewHeightConstraint?.constant = Constants.HEIGHT_HORIZONTAL_ROOM_VIEW
                                    self.updateContentViewHeight()
                                }
                                
                            }else if view == self.newRoomPostView.collectionView{
                                self.newRooms.removeAll()
                                self.newRooms.append(contentsOf: values)
                                self.newRoomPostView.rooms = self.newRooms
                                
                                DispatchQueue.main.async {
                                    self.newRoomPostView.translatesAutoresizingMaskIntoConstraints = false
                                    self.newRoomViewHeightConstraint?.constant = 80 + Constants.HEIGHT_CELL_ROOMPOSTCV * CGFloat(Constants.MAX_ROOM_ROW)
                                    self.newRoomPostView.showbtnViewAllButton()
                                    
                                    self.newRoomViewHeightConstraint?.constant = (CGFloat(self.newRooms.count)*Constants.HEIGHT_CELL_ROOMPOSTCV)/2+80.0
                                    self.updateContentViewHeight()
                                }
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                self.showNoDataView(inView: view, withTitle: "NO_DATA".localized)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showErrorView(inView: view, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                                self.requestRoom(view: view, apiRouter: apiRouter, offset:offset)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func  requestRoommate(view:UICollectionView,apiRouter:APIRouter,offset:Int){
        //        roomFilter.searchRequestModel = nil
        filterForRoommatePost.offset = offset
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            //            hub.label.text = "MB_LOAD_DATA_TITLE".localized
            //            MBProgressHUD.showAdded(to: self.bottomView, animated: true)
        }
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter, returnType:RoommatePostResponseModel.self){ (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                }
                //404, cant parse
                if error != nil{
                    DispatchQueue.main.async {
                        self.showErrorView(inView: view, withTitle: "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoommate(view: view, apiRouter: apiRouter, offset:offset)
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
                        print("Load Data completed for \(apiRouter)")
                        if view == self.newRoommatePostView.collectionView{
                            if values.count != 0{
                                self.newRoommates.removeAll()
                                self.newRoommates.append(contentsOf: values)
                                self.newRoommatePostView.roommates = self.newRoommates
                                DispatchQueue.main.async { self.newRoommatePostView.translatesAutoresizingMaskIntoConstraints = false
                                    self.newRoommateViewHeightConstraint?.constant = 80 + Constants.HEIGHT_CELL_ROOMMATEPOSTCV * CGFloat(Constants.MAX_POST)
                                    self.newRoommatePostView.showbtnViewAllButton()
                                    self.newRoommateViewHeightConstraint!.constant = CGFloat(self.newRoommates.count)*Constants.HEIGHT_CELL_ROOMMATEPOSTCV+80.0
                                    self.updateContentViewHeight()
                                }
                                
                            }
                            
                            
                        }
                        //                        DispatchQueue.main.async {
                        ////                            self.view.layoutIfNeeded()
                        //                            view.reloadData()
                        //                        }
                    }
                }
            }
        }
    }
    //MARK: UICollectionView Delegate and DataSource for TopNavigation
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.roleId == Constants.MEMBER ? actionsForMember.count : user.roleId == Constants.ROOMMASTER ? actionsForRoomMaster.count : actionsForOnwer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        if collectionView ==  topNavigation{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_NAVIGATIONCV, for: indexPath) as! NavigationCVCell
        
        cell.data = user.roleId == Constants.MEMBER ? actionsForMember[indexPath.row] : user.roleId == Constants.ROOMMASTER ? actionsForRoomMaster[indexPath.row] : actionsForOnwer[indexPath.row]
        cell.indexPath = indexPath
        return cell
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if user.roleId == Constants.ROOMOWNER{
                let vc = CERoomVC()
                presentInNewNavigationController(viewController: vc)
            }else{
                let vc = (self.tabBarController?.viewControllers![1] as! UINavigationController)
                self.tabBarController?.selectedViewController = vc
                let allVC = vc.viewControllers.first as! AllVC
                allVC.segmentControl.selectedSegmentIndex = 0
                allVC.resetFilter(filterType: .room)
                allVC.rooms = []
                allVC.loadRoomData(withNewFilterArgModel: true)
            }
        case 1:
            if  user.roleId == Constants.ROOMOWNER{
                let vc = self.tabBarController?.viewControllers![4]
                self.tabBarController?.selectedViewController = vc
                
            }else{
                let vc = (self.tabBarController?.viewControllers![1] as! UINavigationController)
                self.tabBarController?.selectedViewController = vc
                let allVC = vc.viewControllers.first as! AllVC
                allVC.segmentControl.selectedSegmentIndex = 1
                allVC.resetFilter(filterType: .roommmate)
                allVC.roommates = []
                allVC.loadRoommateData(withNewFilterArgModel: true)
            }
        case 2:
            let vc = CERoommatePostVC()
            vc.cERoommateVCType = .create
            presentInNewNavigationController(viewController: vc)
        case 3:
            //            if user.roleId == Constants.ROOMMASTER{
            ////
            ////            }
            ////
            let vc = CERoomPostVC()
            presentInNewNavigationController(viewController: vc)
            break
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if collectionView ==  topNavigation{
        return user.roleId != 2  ? CGSize(width: topNavigation.frame.width/4, height: Constants.HEIGHT_CELL_NAVIGATIONCV) : CGSize(width: topNavigation.frame.width/4, height: Constants.HEIGHT_CELL_NAVIGATIONCV)
        //        }
    }
    //MARK: LocationSearchViewDelegate
    func locationSearchViewDelegate(locationSearchView view: LocationSearchView, onClickButtonLocation btnLocation: UIButton) {
        if NetworkStatus.isConnected(){
            let alert = AlertController.showAlertList(withTitle: "LIST_CITY_TITLE".localized, andMessage: nil, alertStyle: .alert,alertType: .city, forViewController: self, data: cities?.map({ (city) -> String     in
                city.name!
            }), rhsButtonTitle: "DONE".localized)
            alert.delegate = self
        }
    }
    //MARK: UIAlertControllerDelegate
    override func alertControllerDelegate(alertController: AlertController,withAlertType type:AlertType, onCompleted indexs: [IndexPath]?) {
        guard let indexs = indexs else {
            return
        }
        if type == AlertType.city{
            guard let city = cities?[(indexs.first?.row)!]  else{
                return
            }
            
            guard let setting = setting else{
                return
            }
            
            locationSearchView.location = city.name
            setting.cityId = city.cityId
            _ = DBManager.shared.addSingletonModel(ofType: SettingModel.self, object: SettingModel(settingMappableModel: setting))
        }
    }
//    //MARK: UIScrollviewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.y
//        //        let contentHeight = scrollView.contentSize.height
//        //        print("OFFSET:\(scrollView.contentOffset.y)")
//        //        print("ContentframeHeight:\(scrollView.frame.height)")
//        //        print("ContentContentHeight:\(scrollView.contentSize.height)")
//        //
//        if offset  > 50.0{
//            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                print("Hide")
//            }, completion: nil)
//        }else{
//
//            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                print("Unhide")
//            }, completion: nil)
//        }
//    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //
    //        let contentHeight = scrollView.contentSize.height
    //        print("OFFSET:\(scrollView.contentOffset.y)")
    //        print("ContentframeHeight:\(scrollView.frame.height)")
    //        print("ContentContentHeight:\(scrollView.contentSize.height)")
    //        print("show Data:\(offset)")
    //        print("hide more data:\(offset - contentHeight + scrollView.frame.height)")
    //
    //    }
    //MARK: HorizontalRoomViewDelegate
    func horizontalRoomViewDelegate(horizontalRoomView view:HorizontalRoomView,collectionCell cell: RoomPostCVCell, onClickUIImageView imgvBookmark: UIImageView, atIndexPath indexPath: IndexPath?) {
        guard let row = indexPath?.row else{
            return
        }
        processBookmark(view: view.collectionView, model: suggestRooms[row], row: row){model in
            if model.isFavourite!{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
            }else{
                NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
            }
            DispatchQueue.main.async {
                view.collectionView.reloadData()
            }
        }
    }
    
    
    func horizontalRoomViewDelegate(horizontalRoomView view:HorizontalRoomView,collectionCell cell: RoomPostCVCell, didSelectCellAt indexPath: IndexPath?) {
        let vc = PostDetailVC()
        vc.viewType = ViewType.roomPostDetailForFinder
        vc.room = suggestRooms[indexPath!.row]
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
    }
    
    func horizontalRoomViewDelegate(horizontalRoomView view:HorizontalRoomView,onClickButton button: UIButton) {
        let vc = ShowAllVC()
        vc.showAllVCType = .suggestRoom
        presentInNewNavigationController(viewController: vc)
    }
    //MARK: VerticalPostViewDelegate
    
    func verticalCollectionViewDelegate(verticalPostView view: VerticalCollectionView, collectionCell cell: UICollectionViewCell, didSelectCellAt indexPath: IndexPath?) {
        
        let vc = PostDetailVC()
        
        if view == newRoomPostView{
            vc.viewType = ViewType.roomPostDetailForFinder
            vc.room = newRooms[indexPath!.row]
        }else{
            vc.viewType = ViewType.roommatePostDetailForFinder
            vc.roommate = newRoommates[indexPath!.row]
        }
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
        
    }
    func verticalCollectionViewDelegate(verticalPostView view: VerticalCollectionView, collectionCell cell: UICollectionViewCell, onClickUIImageView: UIImageView, atIndexPath indexPath: IndexPath?) {
        guard let row = indexPath?.row else{
            return
        }
        if view == newRoomPostView{
            processBookmark(view: view.collectionView, model: newRooms[row], row: row){model in
                if model.isFavourite!{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
                }else{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
                }
                DispatchQueue.main.async {
                    view.collectionView.reloadData()
                }
            }
        }else{
            processBookmark(view: view.collectionView, model: newRoommates[row], row: row){model in
                if model.isFavourite!{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
                }else{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
                }
                DispatchQueue.main.async {
                    view.collectionView.reloadData()
                }
            }
        }
    }
    
    func verticalCollectionViewDelegate(verticalPostView view: VerticalCollectionView, onClickButton button: UIButton) {
        
        if view == newRoomPostView{
            let vc = (self.tabBarController?.viewControllers![1] as! UINavigationController)
            self.tabBarController?.selectedViewController = vc
            let allVC = vc.viewControllers.first as! AllVC
            allVC.segmentControl.selectedSegmentIndex = 0
            allVC.resetFilter(filterType: .room)
            allVC.rooms = []
            allVC.loadRoomData(withNewFilterArgModel: true)
        }else{
            let vc = (self.tabBarController?.viewControllers![1] as! UINavigationController)
            self.tabBarController?.selectedViewController = vc
            let allVC = vc.viewControllers.first as! AllVC
            allVC.segmentControl.selectedSegmentIndex = 1
            allVC.resetFilter(filterType: .roommmate)
            allVC.roommates = []
            allVC.loadRoommateData(withNewFilterArgModel: true)
        }
        
    }
    
    //MARK: Location
    func enableLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            print("App get notDetermined location service")
        case .restricted, .denied:
            // Disable location features
            print("App get restricted,denied location service")
            //            disableMyLocationBasedFeatures()
            
        case .authorizedWhenInUse:
            // Enable basic location features
            print("App get authorizedWhenInUse location service")
            locationManager.startUpdatingLocation()
        //            enableMyWhenInUseFeatures()
        case .authorizedAlways:
            // Enable any of your app's location features
            print("App get authorizedAlways location service")
            //            enableMyAlwaysFeatures()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let setting = setting else{
            return
        }
        guard let location = locations.last else {
            return
        }
        
        setting.latitude = location.coordinate.latitude
        setting.longitude = location.coordinate.longitude
        _ = DBManager.shared.addSingletonModel(ofType: SettingModel.self, object:SettingModel(settingMappableModel: setting))
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            // Disable your app's location features
            //                disableMyLocationBasedFeatures()
            print("App get restricted,denied location service")
            break
            
        case .authorizedWhenInUse:
            // Enable only your app's when-in-use features.
            //                enableMyWhenInUseFeatures()
            locationManager.startUpdatingLocation()
            break
            
        case .authorizedAlways:
            // Enable any of your app's location services.
            //                enableMyAlwaysFeatures()
            break
            
        case .notDetermined:
            break
        }
    }
    
    //MARK: update constraint
    func updateContentViewHeight(){
        //        DispatchQueue.main.async {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        if self.user.roleId == Constants.ROOMOWNER{
            self.contentViewHeightConstraint?.constant = self.newRoomViewHeightConstraint!.constant + self.newRoommateViewHeightConstraint!.constant + Constants.HEIGHT_TOP_CONTAINER_VIEW +  Constants.HEIGHT_MEDIUM_SPACE
        }else{
            
            
            self.contentViewHeightConstraint?.constant = self.suggestRoomViewHeightConstraint!.constant + self.newRoomViewHeightConstraint!.constant + self.newRoommateViewHeightConstraint!.constant + Constants.HEIGHT_TOP_CONTAINER_VIEW + Constants.HEIGHT_MEDIUM_SPACE
        }
        self.view.layoutIfNeeded()
        //        }
        
    }
    
}
