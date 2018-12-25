//
//  RoomDetailVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class RoomDetailVC:BaseAutoHideNavigationVC,OptionViewDelegate,MembersViewDelegate,UtilitiesViewDelegate,BaseInformationViewDelegate,RateViewDelegate,HorizontalImagesViewDelegate{
    
    var room: RoomMappableModel!{
        didSet{
            if room.members == nil{
                room.members = []
            }
        }
    }
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
        
        
    }()
    lazy var contentView:UIView={
        let cv = UIView()
        return cv
    }()
    
    lazy var horizontalImagesView:HorizontalImagesView = {
        let hv:HorizontalImagesView = .fromNib()
        return hv
    }()
    
    lazy var baseInformationView:BaseInformationView = {
        let bv:BaseInformationView = .fromNib()
        return bv
    }()
    //
    //    var genderView:GenderView = {
    //        let gv:GenderView = .fromNib()
    //        return gv
    //    }()
    
    lazy var membersView:MembersView = {
        let mv:MembersView = .fromNib()
        return mv
    }()
    
    lazy var utilitiesView:UtilitiesView = {
        let uv:UtilitiesView = .fromNib()
        return uv
    }()
    
    
    lazy var descriptionsView:DescriptionView = {
        let dv:DescriptionView = .fromNib()
        return dv
    }()
    
    lazy var optionView:OptionView = {
        let ov:OptionView = .fromNib()
        return ov
    }()
    
    lazy var rateView:RateView = {
        let rv:RateView = .fromNib()
        return rv
    }()
    
    
    lazy var viewType:ViewType = .detailForOwner
    var contentViewHeightConstraint:NSLayoutConstraint?
    var membersViewHeightConstraint:NSLayoutConstraint?
    var ulititiesViewHeightConstraint:NSLayoutConstraint?
    var descriptionViewHeightConstraint:NSLayoutConstraint?
    var rateViewHeightConstraint:NSLayoutConstraint?
    //MARK: RoomDetailVC
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.isNavigationBarHidden = true
        setBackButtonForNavigationBar()
        if viewType == .currentDetailForMember{
            
            requestCurrentRoom(inView: view) { (roomMappableModel) in
                DispatchQueue.main.async {
                    
                    self.room = roomMappableModel
                    self.setupUI()
                    self.setDelegateAndDataSource()
                    self.registerNotification()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
            }
        }else{
            setupUI()
            setDelegateAndDataSource()
            registerNotification()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func setupUI() {
        //Navigation bar
        //        title = "ROOM_INFOR_TITLE".localized
        
        transparentNavigationBarBottomBorder()
        if #available(iOS 11, *){
            scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        
        //Add View
        view.addSubview(scrollView)
        view.addSubview(optionView)
        scrollView.addSubview(contentView)
        contentView.addSubview(horizontalImagesView)
        contentView.addSubview(baseInformationView)
        contentView.addSubview(membersView)
        contentView.addSubview(utilitiesView)
        contentView.addSubview(descriptionsView)
        contentView.addSubview(rateView)
        
        //Caculator height
        let padding:UIEdgeInsets = UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10)
        let membersViewHeight:CGFloat
        let rateViewHeight:CGFloat = (room.roomRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(room.roomRateResponseModels!.count))
        
        if room.members?.count == 0{
            membersViewHeight = 100.0
            showNoDataView(inView: membersView.tableView, withTitle: "NO_MEMBER_ROOM".localized)
        }else if room.members!.count<5{
            hideNoDataView(inView: membersView.tableView)
            membersViewHeight = 60.0 + CGFloat(room.members!.count) * Constants.HEIGHT_CELL_MEMBERTVL
            
        }else{
            membersViewHeight =  Constants.HEIGHT_VIEW_MEMBERS
        }
        
        let baseInformationViewHeight:CGFloat = Constants.HEIGHT_VIEW_BASE_INFORMATION
        
        descriptionsView.text = room.roomDescription
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimateSize = descriptionsView.tvContent.sizeThatFits(size)
        let descriptionViewHeight:CGFloat  = estimateSize.height + 30.0
        let numberOfRow = room.utilities.count%2==0 ? room.utilities.count/2 : room.utilities.count/2+1
        let utilitiesViewHeight =  Constants.HEIGHT_CELL_UTILITYCV * CGFloat(numberOfRow) + 60.0
        let part1 = Constants.HEIGHT_HORIZONTAL_ROOM_VIEW + baseInformationViewHeight
        let part2 = membersViewHeight + utilitiesViewHeight
        let part3 = descriptionViewHeight+rateViewHeight+Constants.HEIGHT_LARGE_SPACE
        let totalContentViewHeight = part1 + part2 + part3
        
        
        
        //Add Constaints
        _ = scrollView.anchor(view.topAnchor, view.leftAnchor, view.bottomAnchor, view.rightAnchor)
        scrollView.delegate = self
        scrollView.contentSize.height = totalContentViewHeight
        
        _ = contentView.anchor(scrollView.topAnchor, scrollView.leftAnchor, scrollView.bottomAnchor, scrollView.rightAnchor)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        contentViewHeightConstraint = contentView.anchorHeight(equalToConstrant: CGFloat(totalContentViewHeight))
        
        _ = horizontalImagesView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero ,CGSize(width: 0, height: Constants.HEIGHT_CELL_IMAGECV))
        _ = baseInformationView.anchor(horizontalImagesView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: baseInformationViewHeight))
        membersViewHeightConstraint = membersView.anchor(baseInformationView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: membersViewHeight))[3]
        ulititiesViewHeightConstraint = utilitiesView.anchor(membersView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: utilitiesViewHeight))[3]
        
        descriptionViewHeightConstraint = descriptionsView.anchor(utilitiesView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: descriptionViewHeight))[3]
        rateViewHeightConstraint = rateView.anchor(descriptionsView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: rateViewHeight))[3]
        _ = optionView.anchor(nil, view.leftAnchor, view.bottomAnchor, view.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_VIEW_OPTION))
    }
    
    func updateUI(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        membersView.translatesAutoresizingMaskIntoConstraints = false
        utilitiesView.translatesAutoresizingMaskIntoConstraints = false
        descriptionsView.translatesAutoresizingMaskIntoConstraints = false
        rateView.translatesAutoresizingMaskIntoConstraints = false
        let rateViewHeight:CGFloat = (room.roomRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(room.roomRateResponseModels!.count))
        
        rateViewHeightConstraint?.constant = rateViewHeight
        let membersViewHeight:CGFloat
        if room.members?.count == 0{
            membersViewHeight = 100.0
            showNoDataView(inView: membersView.tableView, withTitle: "NO_MEMBER_ROOM".localized)
        }else if room.members!.count<5{
            hideNoDataView(inView: membersView.tableView)
            membersViewHeight = 60.0 + CGFloat(room.members!.count) * Constants.HEIGHT_CELL_MEMBERTVL
            
        }else{
            membersViewHeight =  Constants.HEIGHT_VIEW_MEMBERS
        }
        membersViewHeightConstraint?.constant = membersViewHeight
        let numberOfRow = room.utilities.count%2==0 ? room.utilities.count/2 : room.utilities.count/2+1
        let utilitiesViewHeight =  Constants.HEIGHT_CELL_UTILITYCV * CGFloat(numberOfRow) + 60.0
        
        descriptionsView.tvContent.text = room.roomDescription
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimateSize = descriptionsView.tvContent.sizeThatFits(size)
        let descriptionViewHeight:CGFloat  = estimateSize.height + 30.0
        descriptionViewHeightConstraint?.constant = descriptionViewHeight
        
        ulititiesViewHeightConstraint?.constant = utilitiesViewHeight
        let part1 = Constants.HEIGHT_HORIZONTAL_ROOM_VIEW + Constants.HEIGHT_VIEW_BASE_INFORMATION
        let part2 = membersViewHeight + utilitiesViewHeight
        let part3 = descriptionViewHeight+rateViewHeight+Constants.HEIGHT_LARGE_SPACE
        let totalContentViewHeight = part1 + part2 + part3
        
        contentViewHeightConstraint?.constant = totalContentViewHeight
        view.layoutIfNeeded()
        
    }
    func setDelegateAndDataSource() {
        //Data for baseInformationView
        horizontalImagesView.delegate = self
        horizontalImagesView.images = room.imageUrls
        baseInformationView.viewType = viewType
        baseInformationView.delegate = self
        baseInformationView.room = room
        if (viewType == .detailForMember || viewType == .currentDetailForMember){
            baseInformationView.btnTitle = "RATE_ROOM".localized
        }
        membersView.viewType = viewType
        membersView.members = room.members?.uniqueElements
        membersView.delegate = self
        membersView.lblTitle.text = "ROOM_DETAIL_MEMBER_TITLE".localized
        membersView.lblLeft.text = String(format: "ROOM_DETAIL_MAX_NUMBER_OF_MEMBER".localized,room.maxGuest)
        //        membersView.lblCenter.text = String(format: "ROOM_DETAIL_CURRENT_NUMBER_OF_MEMBER".localized,room.currentMember)
        membersView.lblCenter.text = String(format: "ROOM_DETAIL_ADDED_NUMBER_OF_MEMBER".localized,room.members?.count ?? 0)
        
        
        //Data for utilityView
        utilitiesView.lblTitle.text = "UTILITY_TITLE".localized
        utilitiesView.utilities = room.utilities.uniqueElements
        utilitiesView.delegate = self
        
        //Data for descriptionView
        descriptionsView.viewType = viewType
        descriptionsView.lblTitle.text = "DESCRIPTION".localized
        
        
        //Data for optionView
        optionView.viewType = viewType
        optionView.delegate = self
        optionView.tvPrice.attributedText = NSAttributedString(string: String(format: "PRICE_OF_ROOM".localized, room.price.formatString,"MONTH".localized), attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        optionView.tvDate.attributedText = NSAttributedString(string: String(format: "DATE_CREATED_OF_ROOM".localized, (room.date?.string(Constants.SHOW_DATE_FORMAT))!), attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        
        rateView.rateViewType = RateViewType.roomDetail
        rateView.roomMappableModel = room
        rateView.delegate = self
    }
    
    //MARK: Notification
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditRoomNotification(_:)), name: Constants.NOTIFICATION_EDIT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveAcceptRoomNotification(_:)), name: Constants.NOTIFICATION_ACCEPT_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveDeclineRoomNotification(_:)), name: Constants.NOTIFICATION_DECLINE_ROOM, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveCreateRateNotification(_:)), name: Constants.NOTIFICATION_CREATE_RATE, object: nil)
    }
    
    
    @objc func didReceiveEditRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomMappableModel {
                
                guard let room = notification.object as? RoomMappableModel else{
                    return
                }
                self.room = room
                self.updateUI()
                self.setDelegateAndDataSource()
            }
        }
    }
    @objc func didReceiveAcceptRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel else{
                    return
                }
                if notification.roomId == self.room.roomId{
                    self.room.statusId = Constants.AUTHORIZED
                    self.setDelegateAndDataSource()
                }
                
            }
        }
        
    }
    
    @objc func didReceiveDeclineRoomNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is NotificationMappableModel {
                guard let notification = notification.object as? NotificationMappableModel else{
                    return
                }
                if notification.roomId == self.room.roomId{
                    self.room.statusId = Constants.DECLINED
                    self.setDelegateAndDataSource()
                }
                
            }
        }
    }
    
    
    @objc func didReceiveCreateRateNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomRateResponseModel {
                guard let model = notification.object as? RoomRateResponseModel else{
                    return
                }
                if self.room.roomRateResponseModels == nil{
                    self.room.roomRateResponseModels = []
                }
                self.requestCurrentRoom(inView: self.view) { (roomMappableModel) in
                    DispatchQueue.main.async {
                        self.room = roomMappableModel
                        self.updateUI()
                        self.setDelegateAndDataSource()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
                }
            }
            
        }
    }
    //MARK: HorizontalImagesViewDelegate
    func horizontalImagesViewDelegate(horizontalImagesView view: HorizontalImagesView, didSelectImageAtIndextPath indexPath: IndexPath) {
        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_IMAGES, sbName: Constants.STORYBOARD_MAIN) as! ImagesVC
        vc.imageUrls = room.imageUrls
        vc.indexPath = indexPath
        vc.definesPresentationContext = true
        vc.modalTransitionStyle  = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    //MARK: BaseInformationViewDelegate
    func baseInformationViewDelegate(baseInformationView: BaseInformationView, onClickBtnViewAll button: UIButton) {
        let vc = RateVC()
        vc.rateVCType = .room
        vc.roomId = room.roomId
        vc.userId = DBManager.shared.getUser()!.userId
        presentInNewNavigationController(viewController: vc, flag: false)
    }
    
    //MARK: MembersViewDelegate
    func membersViewDelegate(membersView view: MembersView, onClickBtnEdit button:UIButton) {
        if room.statusId == Constants.AUTHORIZED{
            let vc = EditMemberVC()
            vc.room = room
            presentInNewNavigationController(viewController: vc,flag: false)
        }else{
            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "INVALID_ROOM_STATUS".localized, inViewController: self)
        }
        
    }
    func membersViewDelegate(membersView view: MembersView, onClickBtnRate button: UIButton, atIndexPath indexPath: IndexPath?) {
        guard let row = indexPath?.row ,let user =  room.members?[row] else {
            return
        }
        let vc = RateVC()
        vc.rateVCType = .user
        vc.ownerId = DBManager.shared.getUser()!.userId
        vc.userId = user.userId
        presentInNewNavigationController(viewController: vc, flag: false)
    }
    func membersViewDelegate(membersView view: MembersView, onSelectRowAtIndexPath indexPath: IndexPath?) {
        //Present user detail for rating
        guard let row = indexPath?.row, let member = room.members?[row]  else {
            return
        }
        let vc = ProfireVC()
        vc.profireVCType = .memberInfor
        vc.userId = member.userId
        presentInNewNavigationController(viewController: vc)
    }
    
    //MARK: UtilitiesViewDelegate
    func utilitiesViewDelegate(utilitiesView view: UtilitiesView, didSelectUtilityAt indexPath: IndexPath) {
        let utility = room.utilities[indexPath.row]
        utility.name = DBManager.shared.getRecord(id: utility.utilityId, ofType: UtilityModel.self)!.name
        let customTitle = NSAttributedString(string: utility.name, attributes: [NSAttributedStringKey.font:UIFont.boldMedium,NSAttributedStringKey.foregroundColor:UIColor.defaultBlue])
        let customMessage = NSMutableAttributedString(string: "Brand: \(utility.brand)\n", attributes: [NSAttributedStringKey.font:UIFont.small])
        customMessage.append(NSAttributedString(string: "Quantity: \(utility.quantity)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
        customMessage.append(NSAttributedString(string: "Description: \(utility.utilityDescription)", attributes: [NSAttributedStringKey.font:UIFont.small]))
        AlertController.showAlertInfoWithAttributeString(withTitle: customTitle, forMessage: customMessage, inViewController: self)
    }
    //MARK: RateViewDelegate
    func rateViewDelegate(rateView view: RateView, onClickButton button: UIButton) {
        let vc = ShowAllVC()
        vc.showAllVCType = .roomRateForRoomOwner
        vc.roomId = room.roomId
        vc.hasBackImageButtonInNavigationBar = true
        
        presentInNewNavigationController(viewController: vc)
    }
    //MARK: OptionViewDelegate
    func optionViewDelegate(view optionView: OptionView, onClickBtnLeft btnLeft: UIButton) {
        //Valid information at time input. So we dont need to valid here
        switch viewType {
        case .detailForOwner:
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_TITLE_EDIT_ROOM".localized, alertStyle: .alert, forViewController: self,  lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_EDIT_ROOM_OK".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                let vc = CERoomVC()
                vc.roomMappableModel = self.room
                vc.cERoomVCType = .edit
                self.presentInNewNavigationController(viewController: vc,flag: false)
            })
        case .detailForMember,.currentDetailForMember:
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_MESSAGE_SMS_ALERT".localized, alertStyle: .alert, forViewController: self,  lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_BUTTON_MESSAGE".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                
                Utilities.openSystemApp(type: .message, forController: self, withContent: self.room.phoneNumber, completionHander: nil)
            })
        default:
            break
        }
    }
    
    func optionViewDelegate(view optionView: OptionView, onClickBtnRight btnRight: UIButton) {
        switch viewType {
        case .detailForOwner:
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_TITLE_DELETE_ROOM".localized, alertStyle: .alert, forViewController: self, lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_DELETE_ROOM_OK".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                self.requestRemove()
            })
        case .detailForMember,.currentDetailForMember:
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_MESSAGE_CALL_ALERT".localized, alertStyle: .alert, forViewController: self, lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_BUTTON_CALL".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                
                Utilities.openSystemApp(type: .phone, forController: self, withContent: self.room.phoneNumber, completionHander: nil)
            })
        default:
            break
        }
        
    }
    
    //MARK: API Connection
    func  requestRemove(){
        //        roomFilter.searchRequestModel = nil
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        hub.label.text = "LOAD_REMOVE_ROOM".localized
        DispatchQueue.global(qos: .background).async {
            APIConnection.request(apiRouter: APIRouter.removeRoom(roomId: self.room.roomId),  errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                }
            }, completion: { (error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                if error != nil{
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                    }
                }else{
                    if statusCode == .OK{
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_ROOM, object: self.room)
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "REMOVE_SUCCESS".localized, inViewController:self,rhsButtonHandler:{
                                (action) in
                                self.dimissEntireNavigationController()
                            })
                            
                            
                            
                        }
                    }else{
                        DispatchQueue.main.async {
                            APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                        }
                    }
                }
            })
        }
    }
    override func requestCurrentRoom(inView view:UIView,_ completed:((_ roomMappableModel:RoomMappableModel)->Void)? = nil){
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            hub.label.text = "LOAD_CURRENT_ROOM".localized
        }
        
        APIConnection.requestObject(apiRouter: APIRouter.getCurrentRoom(userId: DBManager.shared.getUser()!.userId), returnType: RoomMappableModel.self){ (value, error, statusCode) -> (Void) in
            if error != nil{
                DispatchQueue.main.async {
                    self.showErrorView(inView: view, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                        self.requestCurrentRoom(inView: view, completed)
                    })
                }
            }else{
                //200
                if statusCode == .OK{
                    guard let value = value else{
                        DispatchQueue.main.async {
                            self.showErrorView(inView: view, withTitle:"ERROR_LOAD_CURRENT_ROOM".localized , onCompleted: { () -> (Void) in
                                self.requestCurrentRoom(inView: view, completed)
                            })
                        }
                        return
                    }
                    completed?(value)
                }else if statusCode == .NotFound{
                    DispatchQueue.main.async {
                        self.showNoDataView(inView: view, withTitle: "TITLE_MEMBER_NO_CURRENT_ROOM".localized)
                    }
                }
            }
        }
    }
    
}
