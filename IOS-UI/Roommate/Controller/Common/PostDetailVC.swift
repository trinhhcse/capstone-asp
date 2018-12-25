//
//  RoomDetailVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class PostDetailVC:BaseAutoHideNavigationVC,OptionViewDelegate,UtilitiesViewDelegate, RateViewDelegate,HorizontalImagesViewDelegate{
    var room:RoomPostResponseModel!
    var roommate:RoommatePostResponseModel!
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
    
//    lazy var genderView:GenderView = {
//        let gv:GenderView = .fromNib()
//        return gv
//    }()
    
    //    var membersView:MembersView = {
    //        let mv:MembersView = .fromNib()
    //        return mv
    //    }()
    //
    lazy var utilitiesView:UtilitiesView = {
        let uv:UtilitiesView = .fromNib()
        return uv
    }()
    
    
    lazy var descriptionsView:DescriptionView = {
        let dv:DescriptionView = .fromNib()
        return dv
    }()
    
    lazy var rateView:RateView = {
        let rv:RateView = .fromNib()
        return rv
    }()
    
    lazy var optionView:OptionView = {
        let ov:OptionView = .fromNib()
        return ov
    }()
    
    var viewType:ViewType = .roomPostDetailForFinder
    var contentViewHeightConstraint:NSLayoutConstraint?
    var utilitiesViewHeightConstraint:NSLayoutConstraint?
    var descriptionViewHeightConstraint:NSLayoutConstraint?
    var rateViewHeightConstraint:NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        registerNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(scrollView.contentSize)
        print(scrollView.frame)
        print(scrollView.bounds)
    }
    
    
    func setupUI() {
        setBackButtonForNavigationBar()
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
        contentView.addSubview(utilitiesView)
        contentView.addSubview(rateView)
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser {
//            contentView.addSubview(genderView)
            contentView.addSubview(descriptionsView)
        }
        
        //Caculator height
        let padding:UIEdgeInsets = UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10)
        let numberOfRow:Int
        var descriptionViewHeight:CGFloat = 0.0
        var rateViewHeight:CGFloat = 0.0
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser{
            descriptionsView.text = room.postDesription
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimateSize = descriptionsView.tvContent.sizeThatFits(size)
            descriptionViewHeight  = estimateSize.height + 30.0
            numberOfRow = (room.utilities.count%2==0 ? room.utilities.count/2 : room.utilities.count/2+1)
            
            rateViewHeight = (room.roomRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(room.roomRateResponseModels!.count))
        }else{
            numberOfRow = (roommate.utilityIds.count%2==0 ? roommate.utilityIds.count/2 : roommate.utilityIds.count/2+1)
            rateViewHeight = (roommate.userResponseModel?.userRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(roommate.userResponseModel!.userRateResponseModels!.count))
        }
        
        
        let heightBaseInformationView:CGFloat  = ((viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser) ? Constants.HEIGHT_VIEW_BASE_INFORMATION : Constants.HEIGHT_VIEW_BASE_INFORMATION-30.0 )
        
        
        let utilitiesViewHeight =  Constants.HEIGHT_CELL_UTILITYCV * CGFloat(numberOfRow) + 60.0
        let totalContentViewHeight = (viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser) ? CGFloat(Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES+heightBaseInformationView + descriptionViewHeight  + utilitiesViewHeight+Constants.HEIGHT_LARGE_SPACE)+rateViewHeight : CGFloat(Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES+Constants.HEIGHT_VIEW_BASE_INFORMATION + utilitiesViewHeight - 30)+rateViewHeight
        
        
        
        //Add Constaints
        _ = optionView.anchor(nil, view.leftAnchor, view.bottomAnchor, view.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_VIEW_OPTION))
        
        _ = scrollView.anchor(view.topAnchor, view.leftAnchor, optionView.topAnchor,view.rightAnchor)
        
        scrollView.delegate = self
        scrollView.contentSize.height = totalContentViewHeight
        
        _ = contentView.anchor(scrollView.topAnchor, scrollView.leftAnchor, scrollView.bottomAnchor, scrollView.rightAnchor)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        contentViewHeightConstraint = contentView.anchorHeight(equalToConstrant: CGFloat(totalContentViewHeight))
        
        _ = horizontalImagesView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, .zero ,CGSize(width: 0, height: Constants.HEIGHT_CELL_IMAGECV))
        _ = baseInformationView.anchor(horizontalImagesView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height:heightBaseInformationView ))[3]
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser {
            utilitiesViewHeightConstraint = utilitiesView.anchor(baseInformationView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: utilitiesViewHeight))[3]
            descriptionViewHeightConstraint = descriptionsView.anchor(utilitiesView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: descriptionViewHeight))[3]
            rateViewHeightConstraint = rateView.anchor(descriptionsView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: rateViewHeight))[3]
        }else{
            utilitiesViewHeightConstraint = utilitiesView.anchor(baseInformationView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: utilitiesViewHeight))[3]
            rateViewHeightConstraint = rateView.anchor(utilitiesView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor, padding,CGSize(width: 0, height: rateViewHeight))[3]
        }
    }
    func updateUI(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        baseInformationView.translatesAutoresizingMaskIntoConstraints = false
        utilitiesView.translatesAutoresizingMaskIntoConstraints = false
        descriptionsView.translatesAutoresizingMaskIntoConstraints = false
        rateView.translatesAutoresizingMaskIntoConstraints = false
        
        let numberOfRow:Int
        var descriptionViewHeight:CGFloat = 0.0
        var rateViewHeight:CGFloat = 0.0
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser{
            descriptionsView.text = room.postDesription
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimateSize = descriptionsView.tvContent.sizeThatFits(size)
            descriptionViewHeight  = estimateSize.height + 30.0
            numberOfRow = (room.utilities.count%2==0 ? room.utilities.count/2 : room.utilities.count/2+1)
            
            rateViewHeight = (room.roomRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(room.roomRateResponseModels!.count))
        }else{
            numberOfRow = (roommate.utilityIds.count%2==0 ? roommate.utilityIds.count/2 : roommate.utilityIds.count/2+1)
            rateViewHeight = (roommate.userResponseModel?.userRateResponseModels?.count ?? 0) == 0 ? 80.0 : (110+Constants.HEIGHT_CELL_RATECV*CGFloat(roommate.userResponseModel!.userRateResponseModels!.count))
        }
        
        
        let heightBaseInformationView:CGFloat  = ((viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser) ? Constants.HEIGHT_VIEW_BASE_INFORMATION : Constants.HEIGHT_VIEW_BASE_INFORMATION-30.0 )
        let utilitiesViewHeight =  Constants.HEIGHT_CELL_UTILITYCV * CGFloat(numberOfRow) + 60.0
    
        let totalContentViewHeight = (viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser) ? CGFloat(Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES+heightBaseInformationView + descriptionViewHeight + utilitiesViewHeight+Constants.HEIGHT_LARGE_SPACE)+rateViewHeight : CGFloat(Constants.HEIGHT_VIEW_HORIZONTAL_IMAGES+Constants.HEIGHT_VIEW_BASE_INFORMATION + utilitiesViewHeight - 30)+rateViewHeight
        
        
        
        utilitiesViewHeightConstraint?.constant = utilitiesViewHeight
        contentViewHeightConstraint?.constant = totalContentViewHeight
        descriptionViewHeightConstraint?.constant = descriptionViewHeight
        rateViewHeightConstraint?.constant = rateViewHeight
        view.layoutIfNeeded()
    }
    func setData() {
        rateView.delegate = self
        baseInformationView.viewType = viewType
        horizontalImagesView.delegate = self
//        genderView.viewType = viewType
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser {
            //Data for horizontalImagesView
            
            horizontalImagesView.images = room.imageUrls
            
            baseInformationView.roomPost = room
            
            //Data for genderview
            
            //Data for descriptionView
            descriptionsView.viewType = viewType
            descriptionsView.lblTitle.text = "DESCRIPTION".localized
            descriptionsView.tvContent.text = room.postDesription
            
            //Data for utilityView
            utilitiesView.utilities = room.utilities
            
            //Data for rateView
            rateView.rateViewType = .roomPost
            rateView.roomPostResponseModel = room
            
            //Data for optionView
            optionView.tvPrice.text =  String(format: "PRICE_OF_ROOM".localized, room.minPrice!.formatString,"MONTH".localized)
            optionView.tvDate.attributedText = NSAttributedString(string: String(format: "DATE_CREATED_OF_ROOM".localized, (room.date?.string(Constants.SHOW_DATE_FORMAT))!), attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        }else{
            //Data for horizontalImagesView
            horizontalImagesView.images = [(roommate.userResponseModel?.imageProfile ?? "")]
            
            //Data for baseInformationView
            baseInformationView.roommatePost = roommate
            
            //Data for utilityView
            var utilities:[UtilityMappableModel] = []
            roommate.utilityIds.forEach { (utilityId) in
                utilities.append(UtilityMappableModel(utilityModel: DBManager.shared.getRecord(id: utilityId, ofType: UtilityModel.self)!))
            }
            utilitiesView.utilities = utilities.uniqueElements
            
            //Data for rateView
            rateView.rateViewType = RateViewType.roommatePost
            rateView.roommatePostResponseModel = roommate
            
            //Data for optionView
            optionView.tvPrice.text =  String(format: "PRICE_OF_ROOMMATE".localized, roommate.minPrice.formatString,roommate.maxPrice.formatString,"MONTH".localized)
            optionView.tvDate.attributedText = NSAttributedString(string: String(format: "DATE_CREATED_OF_ROOM".localized, (roommate.date?.string(Constants.SHOW_DATE_FORMAT))!), attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        }
        
        
        
        
        //Data for utilityView
        utilitiesView.lblTitle.text = "UTILITY_TITLE".localized
        utilitiesView.delegate = self
        
        //Data for optionView
        optionView.viewType = viewType
        optionView.delegate = self
        
        view.layoutIfNeeded()
    }
    
    //MARK: Notification
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(didReceiveEditPostNotification(_:)), name: Constants.NOTIFICATION_EDIT_POST, object: nil)
        
    }
    
    
    @objc func didReceiveEditPostNotification(_ notification:Notification){
        DispatchQueue.main.async {
            if notification.object is RoomPostRequestModel {
                guard let model = notification.object as? RoomPostRequestModel else{
                    return
                }
                self.room.model = model
                
            }else{
                guard let model = notification.object as? RoommatePostRequestModel else{
                    return
                }
                self.roommate.model = model
            }
            self.updateUI()
            self.setData()
        }
    }
    
    //MARK: HorizontalImagesViewDelegate
    func horizontalImagesViewDelegate(horizontalImagesView view: HorizontalImagesView, didSelectImageAtIndextPath indexPath: IndexPath) {
        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_IMAGES, sbName: Constants.STORYBOARD_MAIN) as! ImagesVC
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser {
            vc.imageUrls = room.imageUrls
        }else{
            vc.imageUrls = [(roommate.userResponseModel?.imageProfile ?? "")]
        }
        vc.indexPath = indexPath
        vc.view.frame.size = self.view.frame.size
        vc.definesPresentationContext = true
        vc.modalTransitionStyle  = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    //MARK: RateViewDelegate
    func rateViewDelegate(rateView view: RateView, onClickButton button: UIButton) {
        let vc = ShowAllVC()
         if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser {
            vc.showAllVCType = .roomRate
            vc.postId = room.postId
         }else{
            vc.showAllVCType = .userRate
            vc.userId = roommate.userResponseModel!.userId
        }
        
        presentInNewNavigationController(viewController: vc)
    }
    //MARK: OptionViewDelegate
    func optionViewDelegate(view optionView: OptionView, onClickBtnLeft btnLeft: UIButton) {
        //Valid information at time input. So we dont need to valid here
        if viewType == .roomPostDetailForCreatedUser || viewType == .roommatePostDetailForCreatedUser{
            if viewType == .roomPostDetailForCreatedUser{
                let vc = CERoomPostVC()
                vc.cERoomPostVCType = .edit
                vc.roomPostRequestModel = RoomPostRequestModel(model: room)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = CERoommatePostVC()
                vc.cERoommateVCType = .edit
                vc.roommatePostRequestModel = RoommatePostRequestModel(model: roommate)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if viewType == .roomPostDetailForFinder || viewType == .roommatePostDetailForFinder{
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_MESSAGE_POST_SMS_ALERT".localized, alertStyle: .alert, forViewController: self,  lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_BUTTON_MESSAGE".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                
                Utilities.openSystemApp(type: .message, forController: self, withContent:self.viewType == .roomPostDetailForFinder ?  self.room.phoneContact : self.roommate.phoneContact, completionHander: nil)
            })
        }
        
    }
    
    func optionViewDelegate(view optionView: OptionView, onClickBtnRight btnRight: UIButton) {
        if viewType == .roomPostDetailForCreatedUser || viewType == .roommatePostDetailForCreatedUser{
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_TITLE_DELETE_ROOM".localized, alertStyle: .alert, forViewController: self, lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_DELETE_ROOM_OK".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                self.requestRemovePost()
            })
        }else if viewType == .roomPostDetailForFinder || viewType == .roommatePostDetailForFinder{
            AlertController.showAlertConfirm(withTitle: "CONFIRM_TITLE".localized, andMessage: "CONFIRM_MESSAGE_POST_CALL_ALERT".localized, alertStyle: .alert, forViewController: self, lhsButtonTitle: "CANCEL".localized, rhsButtonTitle: "CONFIRM_TITLE_BUTTON_CALL".localized, lhsButtonHandler: nil, rhsButtonHandler: { (action) in
                
                Utilities.openSystemApp(type: .phone, forController: self, withContent:self.viewType == .roomPostDetailForFinder ?  self.room.phoneContact : self.roommate.phoneContact, completionHander: nil)
            })
        }
    }
    
    //MARK: UtilitiesViewDelegate
    func utilitiesViewDelegate(utilitiesView view: UtilitiesView, didSelectUtilityAt indexPath: IndexPath) {
        if viewType == .roomPostDetailForFinder || viewType == .roomPostDetailForCreatedUser{
            let utility = room.utilities[indexPath.row]
            utility.name = DBManager.shared.getRecord(id: utility.utilityId, ofType: UtilityModel.self)!.name
            let customTitle = NSAttributedString(string: utility.name.localized, attributes: [NSAttributedStringKey.font:UIFont.boldMedium,NSAttributedStringKey.foregroundColor:UIColor.defaultBlue])
            let customMessage = NSMutableAttributedString(string: "\(String(key: "BRAND_TITLE", args:utility.brand))\n", attributes: [NSAttributedStringKey.font:UIFont.small])
            customMessage.append(NSAttributedString(string:"\(String(key: "QUANTITY_TITLE", args:utility.quantity))\n" , attributes: [NSAttributedStringKey.font:UIFont.small]))
            customMessage.append(NSAttributedString(string:"\(String(key: "DESCRIPTION_PLACE_HOLDER", args:utility.utilityDescription))\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            AlertController.showAlertInfoWithAttributeString(withTitle: customTitle, forMessage: customMessage, inViewController: self)
        }
    }
    //MARK: API Connection
    func requestRemovePost(){
        //        roomFilter.searchRequestModel = nil
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .background).async {
            APIConnection.request(apiRouter: APIRouter.removePost(postId: self.viewType == .roomPostDetailForCreatedUser ? self.room.postId! : self.roommate.postId!),  errorNetworkConnectedHander: {
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
                            NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_POST, object: self.room)
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "POST_REMOVE_SUCCESS".localized, inViewController:self,rhsButtonHandler:{
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
}
