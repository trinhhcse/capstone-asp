//
//  AccountVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class AccountVC:BaseVC,VerticalCollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UserViewDelegate{
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    lazy var contentView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .red
        return v
    }()
    
    lazy var topContainerView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .blue
        return v
    }()
    lazy var bottomContainerView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .blue
        return v
    }()
    
    lazy var horizontalImagesView:HorizontalImagesView = {
        let hv:HorizontalImagesView = .fromNib()
        hv.removePageControl()
        return hv
    }()
    lazy var userView:UserView = {
        let uv:UserView = .fromNib()
        uv.user = user
        return uv
    }()
    
    lazy var roomForOwnerView:VerticalCollectionView = {
        let vv:VerticalCollectionView = .fromNib()
        vv.verticalCollectionViewType = .createdRoomOfOwner
        return vv
    }()
    lazy var accountActionTableView:UITableView = {
        let tv = UITableView()
        tv.alwaysBounceVertical = true
        return tv
    }()
    
    lazy var btnSetting:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "setting"), for: .normal)
        return btn
    }()
    var contentViewHeightConstraint:NSLayoutConstraint?
    var topContainerViewHeight:CGFloat?
    var bottomContainerViewHeightConstraint:NSLayoutConstraint?
    var verticalRoomViewHeightConstraint:NSLayoutConstraint?
    var rooms:[RoomMappableModel] = []
    var accountVCType:AccountVCType = .member
    var accountActions = [
        "TITLE_CURRENT_MEMBER_ROOM",
        "TITLE_HISTORY_MEMBER_ROOM",
        "TITLE_MEMBER_CREATED_ROOM_POST",
        "TITLE_MEMBER_CREATED_ROOMMATE_POST",
        "TITLE_USER_RATE"
    ]
    var user:UserModel? = DBManager.shared.getUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndLoadInitData(view: self.bottomContainerView){
            self.setupUI()
            self.setupDelegateAndDataSource()
            self.registerNotification()
        }
        
//        if !APIConnection.isConnectedInternet(){
//            showErrorView(inView: self.bottomContainerView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
//                self.checkAndLoadInitData(inView: self.bottomContainerView) { () -> (Void) in
//                    DispatchQueue.main.async {
//                        
//                       
//                    }
//                }
//            }
//        }else{
//            self.checkAndLoadInitData(inView: self.bottomContainerView) { () -> (Void) in
//                DispatchQueue.main.async {
//                    
//                    self.setupDelegateAndDataSource()
//                    self.registerNotification()
//                    
//                }
//            }
//        }
    }
    
    
    func setupUI(){
        //        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(named: "filter"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickBtnSetting))
        //        navigationItem.rightBarButtonItem?.tintColor = .defaultBlue
        
        navigationController?.navigationBar.isHidden = true
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let verticalRoomViewHeight:CGFloat = Constants.HEIGHT_DEFAULT_BEFORE_LOAD_DATA
        topContainerViewHeight = Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES
        
        let bottomContainerViewHeight:CGFloat
        if accountVCType == .member{
            bottomContainerViewHeight = Constants.HEIGHT_VIEW_USER + CGFloat(accountActions.count)*Constants.HEIGHT_CELL_ACTIONTV + Constants.MARGIN_10
        }else{
            bottomContainerViewHeight = Constants.HEIGHT_VIEW_USER + verticalRoomViewHeight + Constants.MARGIN_10
        }
        let totalContentViewHeight:CGFloat = topContainerViewHeight! + bottomContainerViewHeight
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topContainerView)
        topContainerView.addSubview(horizontalImagesView)
        topContainerView.addSubview(btnSetting)
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubview(userView)
        
        if accountVCType == .member{
            bottomContainerView.addSubview(accountActionTableView)
        }else{
            bottomContainerView.addSubview(roomForOwnerView)
        }
        
        if #available(iOS 11.0, *) {
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        } else {
            // Fallback on earlier versions
            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        }
        
        _ = contentView.anchor(scrollView.topAnchor, scrollView.leftAnchor, scrollView.bottomAnchor, scrollView.rightAnchor)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        contentViewHeightConstraint = contentView.anchorHeight(equalToConstrant:totalContentViewHeight)
        
        _ = topContainerView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: topContainerViewHeight!))
        bottomContainerViewHeightConstraint = bottomContainerView.anchor(topContainerView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: bottomContainerViewHeight))[3]
        
        _ = horizontalImagesView.anchor(topContainerView.topAnchor, topContainerView.leftAnchor, topContainerView.bottomAnchor, topContainerView.rightAnchor)
        _ = btnSetting.anchor(topContainerView.topAnchor, nil, nil, topContainerView.rightAnchor,UIEdgeInsets(top: Constants.MARGIN_10, left: 0, bottom: 0, right: -Constants.MARGIN_10),CGSize(width: 24, height: 24))
        
        _ = userView.anchor(bottomContainerView.topAnchor, bottomContainerView.leftAnchor, nil, topContainerView.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_VIEW_USER))
        
        if accountVCType == .member{
            _ = accountActionTableView.anchor(userView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: CGFloat(accountActions.count)*Constants.HEIGHT_CELL_ACTIONTV))
        }else{
            verticalRoomViewHeightConstraint = roomForOwnerView.anchor(userView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,UIEdgeInsets(top: Constants.MARGIN_10, left: 0, bottom: 0, right: 0),CGSize(width: 0, height: verticalRoomViewHeight))[3]
        }
        
        
        roomForOwnerView.hidebtnViewAllButton()
        
    }
    func setupDelegateAndDataSource(){
        //        scrollView.delegate = self
        horizontalImagesView.images = [DBManager.shared.getUser()?.imageProfile ?? ""]
        btnSetting.addTarget(self, action: #selector(onClickBtnSetting), for: .touchUpInside)
        userView.delegage = self
        if accountVCType == .member{
            accountActionTableView.delegate = self
            accountActionTableView.dataSource = self
            accountActionTableView.register(UINib(nibName: Constants.CELL_ACTIONTV, bundle: Bundle.main), forCellReuseIdentifier: Constants.CELL_ACTIONTV)
            //            loadRemoteDataForRoomMember()
        }else{
            scrollView.delegate = self
            roomForOwnerView.delegate = self
            loadRemoteDataForRoomOwner()
        }
        userView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTabUserView)))
        
        
    }
    
    @objc func onTabUserView(){
        print("Touch userview")
    }
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveRemoveRoomNotification(_:)), name: Constants.NOTIFICATION_REMOVE_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditRoomNotification(_:)), name: Constants.NOTIFICATION_EDIT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAddRoomNotification(_:)), name: Constants.NOTIFICATION_CREATE_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAcceptRoomNotification(_:)), name: Constants.NOTIFICATION_ACCEPT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveDeclineRoomNotification(_:)), name: Constants.NOTIFICATION_DECLINE_ROOM, object: nil)
    }
    //MARK: Notification
    @objc func didReceiveRemoveRoomNotification(_ notification:Notification){
        loadRemoteDataForRoomOwner()
    }
    
    @objc func didReceiveEditRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomMappableModel {
                guard let room = notification.object as? RoomMappableModel, let index = self.rooms.index(of: room) else{
                    return
                }
                self.rooms[index] = room
                self.roomForOwnerView.roomsOwner  = self.rooms
            }
        }
    }
    @objc func didReceiveAddRoomNotification(_ notification:Notification){
        loadRemoteDataForRoomOwner()
    }
    
    @objc func didReceiveAcceptRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel, let index = self.rooms.index(of: RoomMappableModel(roomId: notification.roomId!)) else{
                    return
                }
                self.rooms[index].statusId = Constants.AUTHORIZED
                self.roomForOwnerView.roomsOwner  = self.rooms
            }
        }
    }
    
    @objc func didReceiveDeclineRoomNotification(_ notification:Notification){
       DispatchQueue.global(qos: .userInteractive).async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel, let index = self.rooms.index(of: RoomMappableModel(roomId: notification.roomId!)) else{
                    return
                }
                
                self.rooms[index].statusId = Constants.DECLINED
                DispatchQueue.main.async{
                    self.roomForOwnerView.roomsOwner  = self.rooms
                }
            }
        }
    }
    
//    func updateUIForRoleInRoomNotification(_ notification:Notification){
//            DispatchQueue.main.async {
//                let hub = MBProgressHUD.showAdded(to: self.bottomContainerView, animated: true)
//                hub.mode = .indeterminate
//                hub.bezelView.backgroundColor = .white
//                hub.contentColor = .defaultBlue
//            }
//             DispatchQueue.global(qos: .background).async {
//                self.requestCurrentRoom()
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.bottomContainerView, animated: true)
//                }
//            }
//
//        }
//
    //MARK: Load Remote Data for room owner
    
    func loadRemoteDataForRoomOwner(){
        rooms.removeAll()
        if !APIConnection.isConnectedInternet(){
            showErrorView(inView: self.bottomContainerView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
                //                self.checkAndLoadInitData(inView: self.contentView) { () -> (Void) in
                self.requestRoom(view: self.roomForOwnerView.collectionView, apiRouter: APIRouter.getRoomsByUserId(userId: self.user!.userId, page: 1, size: Constants.MAX_OFFSET))
                //                }
            }
        }else{
            //            self.checkAndLoadInitData(inView: self.contentView) { () -> (Void) in
            self.requestRoom(view: self.roomForOwnerView.collectionView, apiRouter: APIRouter.getRoomsByUserId(userId: self.user!.userId, page: 1, size: Constants.MAX_OFFSET))
            //            }
        }
    }
    func  requestRoom(view:UICollectionView,apiRouter:APIRouter){
        //        roomFilter.searchRequestModel = nil
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
        }
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestArray(apiRouter:apiRouter,
                                       errorNetworkConnectedHander: {
                                        DispatchQueue.main.async {
                                            MBProgressHUD.hide(for: view, animated: true)
                                            self.updateUIForNoData()
                                            self.showErrorView(inView: view, withTitle: "NETWORK_STATUS_CONNECTED_ERROR_MESSAGE".localized, onCompleted: { () -> (Void) in
                                                self.requestRoom(view:view, apiRouter: apiRouter)
                                            })
                                        }
                                        
            }, returnType: RoomMappableModel.self, completion: { (values, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                }
                //404, cant parse
                if error != nil{
                    DispatchQueue.main.async {
                        self.updateUIForNoData()
                        self.showErrorView(inView: view, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                            self.requestRoom(view:view, apiRouter: apiRouter)
                        })
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let values = values else{
                            return
                        }
                        if values.count == 0{
                            DispatchQueue.main.async {
                                self.updateUI()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.rooms = values
                                self.roomForOwnerView.roomsOwner = self.rooms
                                self.updateUI()
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            view.reloadData()
                        }
                    }
                }
            })
        }
    }
    
    //MARK: UIScrollviewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        //        let contentHeight = scrollView.contentSize.height
        if offset < -Constants.MAX_Y_OFFSET {
            if accountVCType == .member{
                //                loadRemoteDataForRoomMember()
            }else{
                loadRemoteDataForRoomOwner()
            }
        }
    }
    //MARK: UserViewDelegate
    func userViewDelegate(onSelectedUserView view: UserView) {
        let vc = ProfireVC()
        vc.profireVCType = .normal
        presentInNewNavigationController(viewController: vc, flag: false, animated: true)
    }
    
    //MARK: VerticalPostViewDelegate
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,collectionCell cell: UICollectionViewCell, didSelectCellAt indexPath: IndexPath?){
        let vc = RoomDetailVC()
        vc.viewType = .detailForOwner
        vc.room = rooms[indexPath!.row]
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
    }
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,onClickButton button:UIButton){
        let vc = ShowAllVC()
        vc.showAllVCType = .roomForOwner
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
    }
    
    //MARK: UITableView DataSourse and Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HEIGHT_CELL_ACTIONTV
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ACTIONTV, for: indexPath) as! ActionTVCell
        cell.title = accountActions[indexPath.row].localized
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowAllVC()
        switch indexPath.row {
        case 0:
            let vc = RoomDetailVC()
            vc.viewType = .currentDetailForMember
            presentInNewNavigationController(viewController: vc)
            return
        case 1:
            vc.showAllVCType = .roomForMember
        case 2:
            vc.showAllVCType = .roomPostForCreatedUser
        case 3:
            vc.showAllVCType = .roommatePostForCreatedUser
        case 4:
            vc.showAllVCType = .userRate
            vc.userId = user?.userId ?? 0
        default:
            break
            
        }
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
    }
    
    //MARK: Button Event
    @objc func onClickBtnSetting(){
        let vc = SettingVC()
        //        let mainVC = UIViewController()
        //        let nv = UINavigationController(rootViewController: mainVC)
        //        present(nv, animated: false) {nv.pushViewController(vc, animated: false)}
        presentInNewNavigationController(viewController: vc)
    }
    //MARK: Other
    func updateUI(){
        if rooms.count != 0{
            self.hideNoDataView(inView: self.roomForOwnerView.collectionView)
            self.updateUIForExistedData()
        }else{
            self.showNoDataView(inView:self.roomForOwnerView.collectionView, withTitle: "NO_OWNER_ROOM".localized)
            self.updateUIForNoData()
        }
    }
    func updateUIForExistedData(){
        self.verticalRoomViewHeightConstraint?.constant = Constants.HEIGHT_CELL_ROOMFOROWNERCV*CGFloat(rooms.count) + 80.0
        self.bottomContainerViewHeightConstraint?.constant = self.verticalRoomViewHeightConstraint!.constant + Constants.HEIGHT_VIEW_USER + Constants.MARGIN_10
        self.contentViewHeightConstraint?.constant = self.bottomContainerViewHeightConstraint!.constant + self.topContainerViewHeight!
        self.roomForOwnerView.showbtnViewAllButton()
        self.view.layoutIfNeeded()
    }
    func updateUIForNoData(){
        self.verticalRoomViewHeightConstraint?.constant = Constants.HEIGHT_DEFAULT_BEFORE_LOAD_DATA
        self.bottomContainerViewHeightConstraint?.constant = self.verticalRoomViewHeightConstraint!.constant + Constants.HEIGHT_VIEW_USER+Constants.MARGIN_10
        self.contentViewHeightConstraint?.constant = self.bottomContainerViewHeightConstraint!.constant + self.topContainerViewHeight! 
        self.roomForOwnerView.hidebtnViewAllButton()
        self.view.layoutIfNeeded()
    }
}
