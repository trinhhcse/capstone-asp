//
//  ProfileVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
class ProfireVC:BaseVC,UITableViewDelegate,UITableViewDataSource,RateViewDelegate{
    
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
    lazy var accountActionTableView:UITableView = {
        let tv = UITableView()
        tv.alwaysBounceVertical = true
        return tv
    }()
    lazy var rateView:RateView = {
        let rv:RateView = .fromNib()
        return rv
    }()
//    lazy var btnEdit:UIButton = {
//        let btn = UIButton()
//        btn.setBackgroundImage(UIImage(named: "edit"), for: .normal)
//        return btn
//    }()
    var rateViewHeightConstraint:NSLayoutConstraint?
    var contentViewHeightConstraint:NSLayoutConstraint?
    var topContainerViewHeight:CGFloat?
    var bottomContainerViewHeightConstraint:NSLayoutConstraint?
    var accountInfors = [
        "PLACE_HOLDER_FULL_NAME_VALUE",
        "PLACE_HOLDER_USERNAME_VALUE",
        "PLACE_HOLDER_DOB_VALUE",
        "PLACE_HOLDER_EMAIL_VALUE",
        "PLACE_HOLDER_GENDER_VALUE",
        "PLACE_HOLDER_PHONE_NUMBER_VALUE"
    ]
    var userInfors = [
        "PLACE_HOLDER_FULL_NAME_VALUE",
        "PLACE_HOLDER_DOB_VALUE",
        "PLACE_HOLDER_EMAIL_VALUE",
        "PLACE_HOLDER_GENDER_VALUE",
        "PLACE_HOLDER_PHONE_NUMBER_VALUE"
    ]
    
    var user:UserModel?{
        return DBManager.shared.getUser()
    }
    var profireVCType:ProfireVCType = .normal
    var userId:Int!
    var userResponseModel:UserResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if profireVCType == .normal{
            title = "PROFILE_SETTING".localized
        }else{
            title = "PROFILE_USER".localized
        }
        setBackButtonForNavigationBar()
        
        checkAndLoadInitData(view: self.view){
            if self.profireVCType == .memberInfor{
                self.requestUserData(inView: self.view, userId: self.userId, { (userResponseModel) in
                    DispatchQueue.main.async {
                        self.userResponseModel = userResponseModel
                        self.setupUI()
                        self.setupDelegateAndDataSource()
                        self.registerNotification()
                    }
                })
            }else{
                DispatchQueue.main.async {
                    self.setupUI()
                    self.setupDelegateAndDataSource()
                    self.registerNotification()
                }
            }
            
        }
        
    }
    
    
    func setupUI(){
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        var bottomContainerViewHeight:CGFloat = 0.0
        var rateViewHeight:CGFloat = 0.0
        topContainerViewHeight  = Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES
        if profireVCType == .normal{
            let barButtonItem = UIBarButtonItem(title: "EDIT".localized, style: .done, target: self, action: #selector(onClickBtnEdit))
            barButtonItem.tintColor  = .defaultBlue
            navigationItem.rightBarButtonItem = barButtonItem
            bottomContainerViewHeight =  CGFloat(accountInfors.count)*Constants.HEIGHT_CELL_ACTIONTV + Constants.MARGIN_10
        }else{
            
             rateViewHeight = (userResponseModel?.userRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(userResponseModel!.userRateResponseModels!.count))
            bottomContainerViewHeight =  CGFloat(accountInfors.count)*Constants.HEIGHT_CELL_ACTIONTV+Constants.MARGIN_10+rateViewHeight
        }
        let totalContentViewHeight:CGFloat = topContainerViewHeight! + bottomContainerViewHeight
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topContainerView)
        topContainerView.addSubview(horizontalImagesView)
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubview(accountActionTableView)
        if profireVCType == .memberInfor{
            bottomContainerView.addSubview(rateView)
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
        
        _ = accountActionTableView.anchor(horizontalImagesView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: CGFloat(accountInfors.count)*Constants.HEIGHT_CELL_ACTIONTV))
        if profireVCType == .memberInfor {
            _ = rateView.anchor(accountActionTableView.bottomAnchor, bottomContainerView.leftAnchor, nil, bottomContainerView.rightAnchor,.zero,CGSize(width: 0, height: rateViewHeight))
        }
        
    }
    func setupDelegateAndDataSource(){
        //        scrollView.delegate = self
        horizontalImagesView.images = [user?.imageProfile ?? ""]
        if profireVCType == .memberInfor {
            rateView.rateViewType = .userDetail
            rateView.userResponseModel = userResponseModel
            rateView.delegate = self
        }
        
        accountActionTableView.delegate = self
        accountActionTableView.dataSource = self
        accountActionTableView.register(UINib(nibName: Constants.CELL_ACTIONTV, bundle: Bundle.main), forCellReuseIdentifier: Constants.CELL_ACTIONTV)
        
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditUserNotification(_:)), name: Constants.NOTIFICATION_EDIT_USER, object: nil)
    }
    @objc func didReceiveEditUserNotification(_ notification:Notification){
        DispatchQueue.main.async {
            self.accountActionTableView.reloadData()
        }
    }
    //MARK: RateViewDelegate
    func rateViewDelegate(rateView view: RateView, onClickButton button: UIButton) {
        let vc = ShowAllVC()
        vc.showAllVCType = .userRate
        if profireVCType == .memberInfor{
            vc.userId = userResponseModel!.userId
        }else{
            vc.userId = user!.userId
        }
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
        return profireVCType == .memberInfor ? userInfors.count : accountInfors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ACTIONTV, for: indexPath) as! ActionTVCell
        var text:String = ""
        var value:String?
        if profireVCType == .memberInfor{
            text = userInfors[indexPath.row].localized
        }else{
            text = accountInfors[indexPath.row].localized
        }
        if indexPath.row == 0{
            if profireVCType == .memberInfor{
                value = userResponseModel?.fullname
            }else{
                value =  user?.fullname
            }
            
            
        }else if indexPath.row == 1{
            if profireVCType == .memberInfor{
                value =  userResponseModel?.dob?.string(Constants.USER_DATE_FORMAT)
                
            }else{
                value =  user?.username
            }
            
        }else if indexPath.row == 2{
            if profireVCType == .memberInfor{
                value = userResponseModel?.email
            }else{
                value = user?.dob?.string(Constants.USER_DATE_FORMAT)
            }
            
        }else if indexPath.row == 3{
            if profireVCType == .memberInfor{
                value = userResponseModel?.gender == 1 ? "MALE".localized : "FEMALE".localized
            }else{
                value = user?.email
            }
            
        }else if indexPath.row == 4{
            if profireVCType == .memberInfor{
                   value = userResponseModel?.phone
            }else{
                value = user?.gender == 1 ? "MALE".localized : "FEMALE".localized
            }
            
        }else if indexPath.row == 5{
           value = user?.phone
        }
        
        cell.title = String(format: text, value ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: Remote
    func requestUserData(inView view:UIView,userId:Int,_ completed:((_ userResponseModel:UserResponseModel)->Void)? = nil){
        DispatchQueue.main.async {
            let hub = MBProgressHUD.showAdded(to: view, animated: true)
            hub.mode = .indeterminate
            hub.bezelView.backgroundColor = .white
            hub.contentColor = .defaultBlue
            hub.label.text = "LOAD_USER_INFO".localized
        }
        
        APIConnection.requestObject(apiRouter: APIRouter.findUserByUserId(userId: userId), returnType: UserResponseModel.self){ (value, error, statusCode) -> (Void) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: view, animated: true)
            }
            if error != nil{
                DispatchQueue.main.async {
                    self.showErrorView(inView: view, withTitle:error == .SERVER_NOT_RESPONSE ?  "NETWORK_STATUS_CONNECTED_SERVER_MESSAGE".localized : "NETWORK_STATUS_PARSE_RESPONSE_FAIL_MESSAGE".localized, onCompleted: { () -> (Void) in
                        self.requestUserData(inView: view,userId:userId, completed)
                    })
                }
            }else{
                //200
                if statusCode == .OK{
                    guard let value = value else{
                        DispatchQueue.main.async {
                            self.showErrorView(inView: view, withTitle:"ERROR_LOAD_CURRENT_ROOM".localized , onCompleted: { () -> (Void) in
                                self.requestUserData(inView: view,userId:userId, completed)
                            })
                        }
                        return
                        
                    }
                    completed?(value)
                }else if statusCode == .NotFound{
                    DispatchQueue.main.async {
                        self.showErrorView(inView: view, withTitle:"ERROR_LOAD_USER".localized , onCompleted: { () -> (Void) in
                            self.requestUserData(inView: view,userId:userId, completed)
                        })
                    }
                }
            }
            
        }
        
    }
    
    //MARK: Button Event
    @objc func onClickBtnEdit(){
        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_SIGN_UP, sbName: Constants.STORYBOARD_MAIN) as! SignUpVC
        vc.user = UserMappableModel(userModel: self.user!)
        vc.signUpVCType = .edit
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
