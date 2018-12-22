//
//  RateVC.swift
//  Roommate
//
//  Created by TrinhHC on 11/29/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class RateVC: BaseVC,DescriptionViewDelegate {

    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        
        return sv
    }()

    let contentView:UIView={
        let cv = UIView()
        return cv
    }()

    lazy var topSingleRateView:SingleRateView = {
        let sv:SingleRateView = .fromNib()
        return sv
    }()

    lazy var centerSingleRateView:SingleRateView = {
        let sv:SingleRateView = .fromNib()
        return sv
    }()

    lazy var bottomSingleRateView:SingleRateView = {
        let sv:SingleRateView = .fromNib()
        return sv
    }()

    lazy var descriptionsView:DescriptionView = {
        let dv:DescriptionView = .fromNib()
        dv.lblTitle.text = "RATE_COMMENT".localized
        return dv
    }()
    var userRateRequestModel:UserRateRequestModel!
    var roomRateRequestModel:RoomRateRequestModel!
    var roomId:Int!
    var userId:Int!
    var ownerId:Int!
    var rateVCType:RateVCType = .room{
        didSet {
            if rateVCType == .room{
                title = "RATE_ROOM".localized
                topSingleRateView.singleRateViewType = .security
                centerSingleRateView.singleRateViewType = .location
                bottomSingleRateView.singleRateViewType = .utility
            }else{
                
                title = "RATE_MEMBER".localized
                topSingleRateView.singleRateViewType = .behavior
                centerSingleRateView.singleRateViewType = .lifestyle
                bottomSingleRateView.singleRateViewType = .payment
            }
        }
    }
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegateAndDataSource()
        registerNotificationForKeyboard()
    }
    
    func setupUI(){
        setBackButtonForNavigationBar()
        print("RATE_ROOM_SECURITY".localized)
        //Add Navigation button
        let barButtonItem = UIBarButtonItem(title: "SAVE".localized, style: .done, target: self, action: #selector(onClickBtnSave))
        barButtonItem.tintColor  = .defaultBlue
        navigationItem.rightBarButtonItem = barButtonItem

        //Calculator constant
        let contentViewHeight = 3*Constants.HEIGHT_SINGLE_RATE_VIEW+Constants.HEIGHT_LARGE_SPACE+Constants.HEIGHT_VIEW_DESCRIPTION


        //Add View
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topSingleRateView)
        contentView.addSubview(centerSingleRateView)
        contentView.addSubview(bottomSingleRateView)
        contentView.addSubview(descriptionsView)

        //Add Constrant

        if #available(iOS 11.0, *) {
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))

        } else {
            // Fallback on earlier versions

            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))

        }

        _ = contentView.anchor(scrollView.topAnchor,scrollView.leftAnchor,scrollView.bottomAnchor,scrollView.rightAnchor,.zero,CGSize(width: 0, height: contentViewHeight))
        _ = contentView.anchorWidth(equalTo:scrollView.widthAnchor)

        _ = topSingleRateView.anchor(contentView.topAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_SINGLE_RATE_VIEW))
        _ = centerSingleRateView.anchor(topSingleRateView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_SINGLE_RATE_VIEW))
        _ = bottomSingleRateView.anchor(centerSingleRateView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_SINGLE_RATE_VIEW))
        
        _ = descriptionsView.anchor(bottomSingleRateView.bottomAnchor, contentView.leftAnchor, nil, contentView.rightAnchor,.zero,CGSize(width: 0, height: Constants.HEIGHT_VIEW_DESCRIPTION))
        
        topSingleRateView.starSize = 50.0
        centerSingleRateView.starSize = 50.0
        bottomSingleRateView.starSize = 50.0
        
    }
    func setupDelegateAndDataSource(){
//        top
        descriptionsView.viewType = .rate
        descriptionsView.delegate = self
        if rateVCType == .room{
            roomRateRequestModel = RoomRateRequestModel(userId: userId, roomId: roomId)
        }else{
            userRateRequestModel = UserRateRequestModel(userId: userId, ownerId: ownerId)
        }
        
        topSingleRateView.didFinishTouchingRateView = { [weak self] (rate) in
            if self?.rateVCType == .room{
                self?.roomRateRequestModel.securityRate = rate
            }else{
                self?.userRateRequestModel.behaviourRate = rate
            }
        }
        centerSingleRateView.didFinishTouchingRateView = { [weak self] (rate) in
            if self?.rateVCType == .room{
                self?.roomRateRequestModel.locationRate = rate
            }else{
                self?.userRateRequestModel.lifeStyleRate = rate
            }
            
        }
        bottomSingleRateView.didFinishTouchingRateView = { [weak self] (rate) in
            if self?.rateVCType == .room{
                self?.roomRateRequestModel.utilityRate = rate
            }else{
                self?.userRateRequestModel.paymentRate = rate
            }
        }
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
    //MARK: Navigation bar button delegate
    @objc func onClickBtnSave(){
        if checkValidInformation(){
            requestSaveRate()
        }
    }
    //MARK: DescriptionViewDelegate
    
    func descriptionViewDelegate(descriptionView view: DescriptionView, textViewDidEndEditing textView: UITextView) {
        if rateVCType == .room{
            roomRateRequestModel.comment = view.text ?? ""
        }else{
            userRateRequestModel.comment = view.text ?? ""
        }
    }
    //MARK: Check Valid data and remote request
    func requestSaveRate(){
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .background).async {
            APIConnection.request(apiRouter: self.rateVCType == .room ? APIRouter.saveRoomRate(model: self.roomRateRequestModel) : APIRouter.saveUserRate(model: self.userRateRequestModel),  errorNetworkConnectedHander: {
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
                            if self.rateVCType == .room{
                                NotificationCenter.default.post(name: Constants.NOTIFICATION_CREATE_RATE, object: RoomRateResponseModel(roomRateRequestModel: self.roomRateRequestModel) )
                            }
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "RATE_SAVE_SUCCESS".localized, inViewController: self,rhsButtonHandler:{
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
    func checkValidInformation()->Bool{
        let message = NSMutableAttributedString(string: "")
        if rateVCType == .room{
            if roomRateRequestModel.securityRate == 0{
                message.append(NSAttributedString(string: "\("RATE_ROOM_SECURITY".localized) :  \("RATE_REQUIRED".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
            
            if roomRateRequestModel.securityRate == 0{
                message.append(NSAttributedString(string: "\("RATE_ROOM_LOCATION".localized) :  \(String(format: "RATE_REQUIRED".localized, Int(Constants.MIN_PRICE).formatString,Int(Constants.MAX_PRICE).formatString))\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                
            }
            if roomRateRequestModel.securityRate == 0{
                message.append(NSAttributedString(string: "\("RATE_ROOM_UTILITY".localized) :  \("RATE_REQUIRED".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
            if !roomRateRequestModel.comment.isValidDescription(){
                message.append(NSAttributedString(string: "\("RATE_COMMENT".localized) :  \("ERROR_TYPE_COMMENT".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
        }else{
            if userRateRequestModel.behaviourRate == 0{
                message.append(NSAttributedString(string: "\("RATE_MEMBER_BEHAVIOR".localized) :  \("RATE_REQUIRED".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
            
            if userRateRequestModel.lifeStyleRate == 0{
                message.append(NSAttributedString(string: "\("RATE_MEMBER_LIFESTYLE".localized) :  \(String(format: "RATE_REQUIRED".localized, Int(Constants.MIN_PRICE).formatString,Int(Constants.MAX_PRICE).formatString))\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                
            }
            if userRateRequestModel.paymentRate == 0{
                message.append(NSAttributedString(string: "\("RATE_MEMBER_PAYMENT".localized) :  \("RATE_REQUIRED".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
            if !userRateRequestModel.comment.isValidDescription(){
                message.append(NSAttributedString(string: "\("RATE_COMMENT".localized) :  \("ERROR_TYPE_COMMENT".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            }
            
        }
        if message.string.isEmpty{
            return true
        }else{
            let title = NSAttributedString(string: "INFORMATION".localized, attributes: [NSAttributedStringKey.font:UIFont.boldMedium,NSAttributedStringKey.foregroundColor:UIColor.defaultBlue])
            AlertController.showAlertInfoWithAttributeString(withTitle: title, forMessage: message, inViewController: self)
        }
        return false
    }
    
    

}
