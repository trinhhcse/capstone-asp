//
//  CreateRoommateVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
import SkyFloatingLabelTextField

class CERoomPostVC: BaseVC,GenderViewDelegate,InputViewDelegate,MaxMemberSelectViewDelegate,DescriptionViewDelegate,BaseInformationViewDelegate{
    
    

    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        return sv
    }()
    let contentView:UIView={
        let cv = UIView()
        return cv
    }()
    var baseInformationView:BaseInformationView = {
        let bv:BaseInformationView = .fromNib()
        return bv
    }()
    lazy var optionView:OptionView = {
        let ov:OptionView = .fromNib()
        return ov
    }()
    lazy var lblPostDetail:UILabel = {
        let lbl = UILabel()
        lbl.text = "ROOM_POST_INFOR_TITLE".localized
        lbl.font = .smallTitle
        lbl.textColor = .red
        return lbl
    }()
    lazy var nameInputView:InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .roomPostName
        iv.delegate = self
        return iv
    }()

    lazy var tfPhoneNumber: InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .phone
        iv.delegate = self
        return iv
    }()

    lazy var priceInputView:InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .price
        iv.delegate = self
        return iv
    }()

    lazy var genderView:GenderView = {
        let gv:GenderView = .fromNib()
        gv.delegate = self
        return gv
    }()

    lazy var maxMemberSelectView:MaxMemberSelectView = {
        let mv:MaxMemberSelectView = .fromNib()
        mv.delegate = self
        return mv
    }()

    
    lazy var descriptionsView:DescriptionView = {
        let dv:DescriptionView = .fromNib()
        dv.delegate = self
        return dv
    }()

    
    lazy var btnSubmit:UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .defaultBlue
        bt.tintColor = .white
        return bt
    }()
    
    var cERoomPostVCType:CEVCType = .create
    var roomPostRequestModel: RoomPostRequestModel = RoomPostRequestModel()
//    var roomPostResponseModel:RoomPostResponseModel?
    var roomOfPost:RoomMappableModel!
    //MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButtonForNavigationBar()
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if cERoomPostVCType == .create{
            requestCurrentRoom(inView: self.view) { (roomMappableModel) in
                DispatchQueue.main.async {
                    self.roomOfPost = roomMappableModel
                    self.setupUI()
                    self.setData()
                    self.registerNotificationForKeyboard()
                }
            }
        }else{
            if roomOfPost != nil{
                self.setupUI()
                self.setData()
                self.registerNotificationForKeyboard()
            }else{
                self.requestRoomOfPost(postId: self.roomPostRequestModel.postId, inView: self.view) { (roomMappableModel) in
                    self.roomOfPost = roomMappableModel
                    self.setupUI()
                    self.setData()
                    self.registerNotificationForKeyboard()
                }
                
            }
            
        }
       
        
    }
    
    
    func setupUI(){
        title = cERoomPostVCType == .create ? "CREATE_ROOM_POST".localized : "EDIT_POST".localized
        
        //Create tempview for bottom button
        let bottomView = UIView()
        let defaultBottomViewHeight:CGFloat = 60.0
        let baseInformationViewHeight:CGFloat = Constants.HEIGHT_VIEW_BASE_INFORMATION-80
        //Caculate height
        let contentViewHeight:CGFloat = baseInformationViewHeight+Constants.HEIGHT_ROOM_INFOR_TITLE+3*Constants.HEIGHT_INPUT_VIEW+Constants.HEIGHT_VIEW_GENDER+Constants.HEIGHT_VIEW_MAX_MEMBER_SELECT+Constants.HEIGHT_VIEW_DESCRIPTION+Constants.HEIGHT_LARGE_SPACE
        //Add View
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        
        
        scrollView.addSubview(contentView)
        bottomView.addSubview(btnSubmit)
        contentView.addSubview(baseInformationView)
        contentView.addSubview(lblPostDetail)
        contentView.addSubview(nameInputView)
        contentView.addSubview(priceInputView)
        contentView.addSubview(tfPhoneNumber)
        contentView.addSubview(genderView)
        contentView.addSubview(maxMemberSelectView)
        contentView.addSubview(descriptionsView)
        
        //Add Constrant
        
        if #available(iOS 11.0, *) {
            _ = bottomView.anchor(nil, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10),.init(width: 0, height: defaultBottomViewHeight))
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, bottomView.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
            
        } else {
            // Fallback on earlier versions
            _ = bottomView.anchor(nil, view.leftAnchor,bottomLayoutGuide.topAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10),.init(width: 0, height: defaultBottomViewHeight))
            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomView.topAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
            
        }
        
        
        _ = contentView.anchor(scrollView.topAnchor,scrollView.leftAnchor,scrollView.bottomAnchor,scrollView.rightAnchor,.zero,CGSize(width: 0, height: contentViewHeight))
        _ = contentView.anchorWidth(equalTo:scrollView.widthAnchor)

        _ = baseInformationView.anchor(contentView.topAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: baseInformationViewHeight))
        _ = lblPostDetail.anchor(baseInformationView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_ROOM_INFOR_TITLE))
        _ = nameInputView.anchor(lblPostDetail.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        _ = tfPhoneNumber.anchor(nameInputView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        _ = priceInputView.anchor(tfPhoneNumber.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        _ = genderView.anchor(priceInputView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_GENDER))
        _ = maxMemberSelectView.anchor(genderView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_MAX_MEMBER_SELECT))
        _ = descriptionsView.anchor(maxMemberSelectView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_DESCRIPTION))

        _ = btnSubmit.anchor(view: bottomView,UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0))
        btnSubmit.layer.cornerRadius = CGFloat(10)
        btnSubmit.clipsToBounds = true
//        btnSubmit.isEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        
    }
    //MARK:Delegate and data
    func setData(){
        btnSubmit.setTitle(cERoomPostVCType == .create ? "CREATE".localized : "SAVE".localized, for: .normal)
        
        //Delegate
        btnSubmit.addTarget(self, action: #selector(onClickBtnSubmit(btnSubmit:)), for: .touchUpInside)
        
        //Data
        baseInformationView.viewType = .ceRoomPostForMaster
        baseInformationView.btnTitle = "VIEW_DETAIL".localized
        baseInformationView.room = roomOfPost
        baseInformationView.delegate = self
        maxMemberSelectView.maxMember = roomOfPost.maxGuest
        priceInputView.maxPrice = Double(roomOfPost.price)
        if cERoomPostVCType == CEVCType.edit{
            nameInputView.text = roomPostRequestModel.name
            priceInputView.text = Int(roomPostRequestModel.minPrice).toString
            tfPhoneNumber.text = roomPostRequestModel.phoneContact
            genderView.genderSelect = GenderSelect(rawValue: roomPostRequestModel.genderPartner)
            maxMemberSelectView.text = roomPostRequestModel.numberPartner.toString
            
            descriptionsView.text = roomPostRequestModel.postDescription ?? ""
            descriptionsView.viewType = .editForOwner
        }else{
            descriptionsView.viewType = .ceRoomPostForMaster
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
    
    
    
    //MARK: Delegate for subview
    func descriptionViewDelegate(descriptionView view: DescriptionView, textViewDidEndEditing textView: UITextView) {
        roomPostRequestModel.postDescription = descriptionsView.text!
        descriptionsView.tvContent.resignFirstResponder()
        descriptionsView.tvContent.endEditing(true)
    }
    func descriptionViewDelegate(descriptionView view: DescriptionView, textViewShouldBeginEditing textView: UITextView) {
        scrollView.contentOffset.y = descriptionsView.frame.origin.y
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func maxMemberSelectViewDelegate(view maxMemberSelectView: MaxMemberSelectView, onClickBtnSub btnSub: UIButton) {
        guard let text = maxMemberSelectView.text,let maxMember = Int(text) else {
            return
        }
        roomPostRequestModel.numberPartner = maxMember
    }
    
    func maxMemberSelectViewDelegate(view maxMemberSelectView: MaxMemberSelectView, onClickBtnPlus btnPlus: UIButton) {
        guard let text = maxMemberSelectView.text,let maxMember = Int(text) else {
            return
        }
        roomPostRequestModel.numberPartner = maxMember
    }
    func inputViewDelegate(inputView view: InputView, shouldChangeCharactersTo string: String) -> Bool{
        switch view {
        case nameInputView:
            roomPostRequestModel.name = string
        case priceInputView:
            if string.isEmpty{return true}
            guard let price = Float(string) else{
                return false
            }
            roomPostRequestModel.minPrice = price
        case tfPhoneNumber:
            if string.isEmpty{return true}
            guard let _ = Int(string) else{
                return false
            }
            roomPostRequestModel.phoneContact = string
        default:
            break
            
        }
//        checkDataAndUpdateUI()
        return true
    }
    func genderViewDelegate(genderView view: GenderView, onChangeGenderSelect genderSelect: GenderSelect?) {
        roomPostRequestModel.genderPartner = (genderSelect?.rawValue)!
    }
    func baseInformationViewDelegate(baseInformationView: BaseInformationView, onClickBtnViewAll button: UIButton) {
        let vc = RoomDetailVC()
        vc.hasBackImageButtonInNavigationBar = true
        vc.viewType = .detailForMember
        vc.room = roomOfPost
        presentInNewNavigationController(viewController: vc, flag: false)
    }
    //MARK: Handler for save button
    @objc  func onClickBtnSubmit(btnSubmit:UIButton){
        if isValidData(){
            saveRoomPost()
        }else{
            AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: "ERROR_TYPE_INPUT".localized, inViewController: self)
        }
    }
    func checkDataAndUpdateUI(){
        if isValidData(){
            btnSubmit.isEnabled = true
        }else{
            btnSubmit.isEnabled = false
        }
    }

    func isValidData()->Bool{
//        let message = NSMutableAttributedString(string: "")
        var isValid = true
        if !(roomPostRequestModel.name?.isValidName() ?? false){
            isValid = false
//            message.append(NSAttributedString(string: "\("ROOM_NAME_TITLE".localized) :  \("ERROR_TYPE_NAME_MAX_CHAR_50".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
        }

        if !(roomPostRequestModel.phoneContact.isValidPhoneNumber() ){
            tfPhoneNumber.showErrorView()
            isValid = false
//            message.append(NSAttributedString(string: "\("PLACE_HOLDER_PHONE_NUMBER".localized) :  \("ERROR_TYPE_PHONE".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
        }
        if !(roomPostRequestModel.minPrice?.toString.isValidPrice() ?? false){
//            message.append(NSAttributedString(string: "\("PRICE".localized) :  \(String(format: "ERROR_TYPE_PRICE".localized, Int(Constants.MIN_PRICE).formatString,Int(roomOfPost.price).formatString))\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            priceInputView.showErrorView()
            isValid = false
        }
//        if message.string.isEmpty{
//            return true
//        }else{
//            let title = NSAttributedString(string: "INFORMATION".localized, attributes: [NSAttributedStringKey.font:UIFont.boldMedium,NSAttributedStringKey.foregroundColor:UIColor.defaultBlue])
//            AlertController.showAlertInfoWithAttributeString(withTitle: title, forMessage: message, inViewController: self)
//        }
        
        return isValid
    }
    
    func saveRoomPost(){
        self.roomPostRequestModel.roomId = roomOfPost.roomId
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        
        hub.label.text = self.cERoomPostVCType == .create ?  "MB_LOAD_CREATE_POST".localized :
            "MB_LOAD_EDIT_POST".localized
        DispatchQueue.global(qos: .userInteractive).async {
            APIConnection.request(apiRouter:self.cERoomPostVCType == .create ? APIRouter.createRoomPost(model: self.roomPostRequestModel) : APIRouter.editRoomPost(model: self.roomPostRequestModel),  errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    hub.hide(animated: true)
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                }
            }, completion: { (error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    hub.hide(animated: true)
                }
                if error == .SERVER_NOT_RESPONSE {
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                    }
                }else{
                    //200
                    if statusCode == .Created || statusCode == .OK{
                        DispatchQueue.main.async {
                            hub.hide(animated: true)
                            if self.cERoomPostVCType == .edit{
                                NotificationCenter.default.post(name: Constants.NOTIFICATION_EDIT_POST, object: self.roomPostRequestModel)
                            }
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: self.cERoomPostVCType == .create ? "POST_CREATE_SUCCESS".localized : "POST_EDIT_SUCCESS".localized, inViewController: self,rhsButtonHandler: {
                                (action) in
                                if self.cERoomPostVCType == .create{
                                    self.dimissEntireNavigationController()
                                }else{
                                    
                                    self.popSelfInNavigationController()
                                }
                            })
                            
                        }
                    }else  if statusCode == .Conflict || statusCode == .InternalServerError{
                        DispatchQueue.main.async {
                            APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                        }
                    }
                }
            })
        }
    }

}
