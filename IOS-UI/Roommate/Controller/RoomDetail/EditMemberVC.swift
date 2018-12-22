//
//  EditMemberVC.swift
//  Roommate
//
//  Created by TrinhHC on 11/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class EditMemberVC: BaseVC,MembersViewDelegate,AddMemberViewDelegate,DropdownListViewDelegate {
    
    var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    var contentView:UIView = {
        let v = UIView()
        //        v.backgroundColor = .red
        return v
    }()
    lazy var membersView:MembersView = {
        let mv:MembersView = .fromNib()
        mv.viewType = .editForOwner
        return mv
    }()
    lazy var addMemberView:AddMemberView = {
        let av:AddMemberView = .fromNib()
        return av
    }()
    lazy var roomMasterDropdownListView:DropdownListView = {
        let lv:DropdownListView = .fromNib()
        lv.dropdownListViewType = .roomMaster
        return lv
    }()
    var contentViewHeightConstraint:NSLayoutConstraint?
    var membersViewHeightConstraint:NSLayoutConstraint?
    
    var room: RoomMappableModel!{
        didSet{
            copyRoom = room.copy() as! RoomMappableModel
        }
    }
    
    var copyRoom: RoomMappableModel!{
        didSet{
            if copyRoom.members == nil{
                copyRoom.members = []
            }else{
                copyRoom.members?.forEach({ (member) in
                    if member.roleId == Constants.ROOMMASTER{
                        self.roomMaster = member
                    }
                })
            }
            self.originMember = copyRoom.members
        }
    }
    var originMember:[MemberResponseModel]!
    var username:String = ""
    var roomMaster:MemberResponseModel?{
        didSet{
            if roomMaster != nil{
                self.roomMasterDropdownListView.text = roomMaster?.username
            }else{
                self.roomMasterDropdownListView.dropdownListViewType = .roomMaster
            }
            
        }
    }
    
    //MARK:EditMemberVC
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelagateAndDataSource()
        registerNotificationForKeyboard()
    }
    
    
    func setupUI(){
        
        //Title
        navigationItem.title = "EDIT_MEMBER_VC".localized
        setBackButtonForNavigationBar()
        
        //Back button on navigation bar
//        let backImage = UIImage(named: "back")
//        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickBtnBack))
//        navigationItem.leftBarButtonItem?.tintColor = .defaultBlue
        
        //Right button on navigation bar
        let barButtonItem = UIBarButtonItem(title: "SAVE".localized, style: .done, target: self, action: #selector(onClickBtnSave))
        barButtonItem.tintColor  = .defaultBlue
        navigationItem.rightBarButtonItem = barButtonItem
        
        let totalViewContentHeight:CGFloat
        let membersViewHeight:CGFloat
        if copyRoom?.members?.count != 0{
            membersViewHeight = Constants.HEIGHT_VIEW_MEMBERS
        }else{
            membersViewHeight = 100.0
            showNoDataView(inView: membersView.tableView, withTitle: "NO_MEMBER_ROOM".localized)
        }
        
        
        totalViewContentHeight = membersViewHeight + Constants.HEIGHT_CELL_ADD_MEMBER_VIEW + Constants.HEIGHT_VIEW_DROPDOWN_LIST + Constants.HEIGHT_LARGE_SPACE
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(membersView)
        contentView.addSubview(addMemberView)
        contentView.addSubview(roomMasterDropdownListView)
        
        if #available(iOS 11.0, *) {
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        } else {
            // Fallback on earlier versions
            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        }
        _ = contentView.anchor(view: scrollView)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        contentViewHeightConstraint = contentView.anchorHeight(equalToConstrant: totalViewContentHeight)
        membersViewHeightConstraint = membersView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero, CGSize(width: 0, height: membersViewHeight))[3]
        
        _ = addMemberView.anchor(membersView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero, CGSize(width: 0, height: Constants.HEIGHT_CELL_ADD_MEMBER_VIEW))
        
        _ = roomMasterDropdownListView.anchor(addMemberView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero, CGSize(width: 0, height: Constants.HEIGHT_VIEW_DROPDOWN_LIST))
        
    }
    
    func setupDelagateAndDataSource(){
        membersView.delegate = self
        membersView.members = copyRoom?.members
        addMemberView.delegate = self
        roomMasterDropdownListView.delegate = self
        //        roomMaster = copyRoom.members?.filter{$0.roleId == Constants.ROOMMASTER}.first
    }
    
    //MARK: Keyboard Notification handler
    override func keyBoard(notification: Notification) {
        super.keyBoard(notification: notification)
        if notification.name == NSNotification.Name.UIKeyboardWillShow{
            let userInfor = notification.userInfo!
            let keyboardFrame:CGRect = (userInfor[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            print(scrollView.contentInset)
            print(scrollView.contentOffset)
            scrollView.contentInset.bottom = keyboardFrame.size.height
            scrollView.scrollIndicatorInsets = scrollView.contentInset
            print(scrollView.contentInset)
            print(scrollView.contentOffset)
        }else if notification.name == NSNotification.Name.UIKeyboardWillHide{
            scrollView.contentInset = .zero
        }
    }
    //MARK: MembersViewDelegate
    func membersViewDelegate(membersView view:MembersView,onDeleteRecordAtIndexPath indexPath:IndexPath?){
        guard let indexPath = indexPath else {
            return
        }
        let member = copyRoom?.members?.remove(at: indexPath.row)
        if member?.roleId == Constants.ROOMMASTER{
            roomMaster = nil
        }
        if copyRoom.members?.count == 0{
            showNoDataView(inView: membersView.tableView, withTitle: "NO_MEMBER_ROOM".localized)
            membersView.translatesAutoresizingMaskIntoConstraints = false
            membersViewHeightConstraint?.constant = 100.0
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentViewHeightConstraint?.constant = self.membersViewHeightConstraint!.constant + Constants.HEIGHT_CELL_ADD_MEMBER_VIEW + Constants.HEIGHT_VIEW_DROPDOWN_LIST + Constants.HEIGHT_LARGE_SPACE
            self.view.layoutIfNeeded()
        }
        membersView.members = copyRoom?.members
    }
    func membersViewDelegate(membersView view: MembersView, onSelectRowAtIndexPath indexPath: IndexPath?) {
        guard let row = indexPath?.row, let member = copyRoom.members?[row]  else {
            return
        }
        let vc = ProfireVC()
        vc.hasBackImageButtonInNavigationBar = false
        vc.profireVCType = .memberInfor
        vc.userId = member.userId
        presentInNewNavigationController(viewController: vc, flag: false, animated: true)
    }
    //MARK: AddMemberViewDelegate
    func addMemberViewDelegate(addMemberView view: AddMemberView, shouldChangeCharactersTo string: String) -> Bool {
        username = string
        return true
    }
    func addMemberViewDelegate(addMemberView view: AddMemberView, onClickBtnAdd btnAdd: UIButton) {
        if copyRoom.members!.count < copyRoom.maxGuest{
            if username.isValidUsername(){
                if !username.isEmpty{
                    let tempMember = MemberResponseModel(username: self.username)
                    if originMember.contains(tempMember){
                        if copyRoom!.members!.contains(tempMember){
                            APIResponseAlert.apiResponseError(controller: self, type: .existedRoomMember)
                        }else{
                            addMember(member: originMember[originMember.index(of: tempMember)!])
                            membersView.members = copyRoom.members
                        }
                    }else if copyRoom.members!.count <= copyRoom.maxGuest{
                        if copyRoom!.members!.contains(tempMember){
                            APIResponseAlert.apiResponseError(controller: self, type: .existedRoomMember)
                        }else{
                            requestUserData(text: username)
                        }
                    }
                }
            }else{
                AlertController.showAlertInfor(withTitle:  "INFORMATION".localized, forMessage: "ERROR_TYPE_USERNAME".localized, inViewController:self)
            }
        }else{
            APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.invalidMaxGuest)
        }
        
        
    }
    
    //MARK: DropdownListViewDelegate
    func dropdownListViewDelegate(view dropdownListView: DropdownListView, onClickBtnChangeSelect btnSelect: UIButton) {
        if copyRoom.members?.count != 0 {
            let data = copyRoom.members?.compactMap{$0.username}
            var selectDataIndexs:[Int]
            if let roomMaster = roomMaster, let index = data?.index(of: roomMaster.username){
                selectDataIndexs = [index]
            }else{
                selectDataIndexs = []
            }
            let alert = AlertController.showAlertList(withTitle: "EDIT_SELECT_ROOM_MASTER".localized, andMessage: nil, alertStyle: .alert,alertType: .roomMaster,forViewController: self, data: data,selectedItemIndex: selectDataIndexs, rhsButtonTitle: "DONE".localized)
            alert.delegate = self
        }
        
    }
    //MARK: AlertControllerDelegate
    override func alertControllerDelegate(alertController: AlertController,withAlertType type:AlertType, onCompleted indexs: [IndexPath]?) {
        guard let indexs = indexs, let row = indexs.first?.row else {
            return
        }
        roomMaster?.roleId = Constants.MEMBER
        roomMaster = copyRoom.members?[row]
        roomMaster?.roleId = Constants.ROOMMASTER
        membersView.members = copyRoom.members
        roomMasterDropdownListView.text = roomMaster?.username
    }
    
    @objc func onClickBtnSave(){
        if copyRoom.members?.isEmpty ?? true{
            requestEdit()
        }else{
            if roomMaster != nil {
                requestEdit()
            }else{
                APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.requiredRoomMaster)
            }
        }
        
    }
    //MARK: Others
    
    func  requestUserData(text:String){
        //        roomFilter.searchRequestModel = nil
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestObject(apiRouter: APIRouter.findExitedUserInRoom(username: text), errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                }
            }, returnType: MemberResponseModel.self) { (member, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                if error == .SERVER_NOT_RESPONSE {
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                    }
                }else if error == .PARSE_RESPONSE_FAIL {
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let member = member else{
                            return
                        }
                        self.addMember(member: member)
                        DispatchQueue.main.async {
                            self.addMemberView.clearText()
                            self.username = ""
                            self.membersView.members = self.copyRoom?.members
                            
//                            APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.addMemberSuccess)
                        }
                        //403
                    }else if statusCode == .Conflict {
                        DispatchQueue.main.async {
                            APIResponseAlert.apiResponseError(controller: self, type: .invalidMember)
                        }
                    }else if statusCode == .NotFound{
                        APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.nonExistedUsername)
                    }
                }
            }
        }
    }
    func  requestEdit(){
        //        roomFilter.searchRequestModel = nil
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .background).async {
            APIConnection.request(apiRouter: APIRouter.editMember(roomMemberRequestModel: RoomMemberRequestModel(roomId: self.copyRoom.roomId, memberRequestModels: self.copyRoom.members?.compactMap{MemberRequestModel(userId: $0.userId, roleId: $0.roleId)})),  errorNetworkConnectedHander: {
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
                            self.room.members = self.copyRoom.members
                            NotificationCenter.default.post(name: Constants.NOTIFICATION_EDIT_ROOM, object: self.room)
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "EDIT_MEMBER_SUCCESS".localized, inViewController: self,rhsButtonHandler:{
                                (action) in
                                self.popSelfInNavigationController()
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
    func addMember(member:MemberResponseModel){
        if copyRoom?.members?.count == 0{
            member.roleId = Constants.ROOMMASTER
            copyRoom?.members?.append(member)
            roomMaster = member
            hideNoDataView(inView: membersView.tableView)
            membersView.translatesAutoresizingMaskIntoConstraints = false
            membersViewHeightConstraint?.constant = Constants.HEIGHT_VIEW_MEMBERS
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentViewHeightConstraint?.constant = self.membersViewHeightConstraint!.constant + Constants.HEIGHT_CELL_ADD_MEMBER_VIEW + Constants.HEIGHT_VIEW_DROPDOWN_LIST + Constants.HEIGHT_LARGE_SPACE
            self.view.layoutIfNeeded()
        }else{
            member.roleId = Constants.MEMBER
            copyRoom?.members?.append(member)
        }
    }
}
