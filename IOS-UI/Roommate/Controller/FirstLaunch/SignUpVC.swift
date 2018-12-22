//
//  SIgnUpVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD
import Alamofire
import SDWebImage
class SignUpVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var tfUsernameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfRepeatPasswordHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tfPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vTop: UIView!
    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tfFullName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfDateOfBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRepeatPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var sgGender: UISegmentedControl!
    @IBOutlet weak var btnNextStep: UIButton!
    lazy var datePicker:UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.maximumDate = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        dp.date = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        dp.addTarget(self, action: #selector(onDatePickerValueChanged), for: .valueChanged)
        return dp
    }()
    private lazy var mainTabBarVC:MainTabBarVC =  {
        let vc = MainTabBarVC()
        return vc
    }()
    var user:UserMappableModel = UserMappableModel()
    var uploadImageModel:UploadImageModel?
    var signUpVCType:SignUpVCType = .normal
    var repeatPassord:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDelegateAndDataSource()
        registerNotificationForKeyboard()
    }
    func setupUI(){
        if signUpVCType == .edit{
            title = "EDIT_USER_INFO".localized
        }else{
            title = "TITLE_SIGN_UP".localized
        }
        setBackButtonForNavigationBar()
        vTop.layer.cornerRadius = 15
        vTop.clipsToBounds = true
        lblDescription.text = "SELECT_IMAGE".localized
        tfFullName.setupUI(placeholder: "PLACE_HOLDER_FULL_NAME", title: "PLACE_HOLDER_FULL_NAME", delegate: self)
        tfDateOfBirth.text = Calendar.current.date(byAdding: .year, value: -20, to: Date())!.string("dd/MM/yyyy")
        user.dob = Date(timeIntervalSince1970: 0.0)
        tfDateOfBirth.addToobarButton()
        tfDateOfBirth.setupUI(placeholder: "PLACE_HOLDER_DOB", title: "PLACE_HOLDER_DOB", keyboardType: .none, returnKeyType: .none, delegate: self)
        tfDateOfBirth.inputView = datePicker
        tfPhoneNumber.addToobarButton()
        tfPhoneNumber.setupUI(placeholder: "PLACE_HOLDER_PHONE_NUMBER", title: "PLACE_HOLDER_PHONE_NUMBER", keyboardType: .numberPad, delegate: self)
        tfEmail.setupUI(placeholder: "PLACE_HOLDER_EMAIL", title: "PLACE_HOLDER_EMAIL", delegate: self)
        
        
        if signUpVCType == .edit{
            btnNextStep.setTitle("SAVE".localized, for: .normal)
        }else{
            btnNextStep.setTitle(user.roleId == Constants.ROOMOWNER ? "SIGN_UP_AS_ROOMOWNER_TITLE".localized : "SIGN_UP_AS_MEMBER_TITLE".localized, for: .normal)
        }
//        btnNextStep.setTitleColor(.white, for: .disabled)
//        btnNextStep.isEnabled = false
        
        btnNextStep.layer.cornerRadius = 15.0
        btnNextStep.clipsToBounds = true
        sgGender.setTitle("MALE".localized, forSegmentAt: 0)
        sgGender.setTitle("FEMALE".localized, forSegmentAt: 1)
        if signUpVCType == .edit{
            tfUsername.translatesAutoresizingMaskIntoConstraints = false
            tfPassword.translatesAutoresizingMaskIntoConstraints = false
            tfRepeatPassword.translatesAutoresizingMaskIntoConstraints = false
            tfUsernameHeightConstraint.constant = 0
            tfPasswordHeightConstraint.constant = 0
            tfRepeatPasswordHeightConstraint.constant = 0
        }else{
            tfUsername.setupUI(placeholder: "PLACE_HOLDER_USERNAME", title: "PLACE_HOLDER_USERNAME", delegate: self)
            tfUsername.textContentType = UITextContentType("")
            tfPassword.setupUI(placeholder: "PLACE_HOLDER_PASSWORD", title: "PLACE_HOLDER_PASSWORD",isSecureTextEntry:true, delegate: self)
            tfPassword.textContentType = UITextContentType("")
            tfRepeatPassword.setupUI(placeholder: "PLACE_HOLDER_REPEAT_PASSWORD", title: "PLACE_HOLDER_REPEAT_PASSWORD",isSecureTextEntry:true, delegate: self)
            tfRepeatPassword.textContentType = UITextContentType("")
        }
        
        
    }
    func setDelegateAndDataSource(){
        imgvAvatar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickImgvAvatar))
        imgvAvatar.addGestureRecognizer(tap)
        tfFullName.delegate = self
        tfDateOfBirth.delegate = self
        tfPhoneNumber.delegate = self
        tfEmail.delegate = self
        sgGender.addTarget(self, action: #selector(onSegmentControlIndexChange), for: .valueChanged)
        if signUpVCType == .normal{
            tfUsername.delegate = self
            tfPassword.delegate = self
            tfRepeatPassword.delegate = self
        }else{
            imgvAvatar.sd_setImage(with: URL(string: user.imageProfile ?? ""), placeholderImage: UIImage(named: "default_load_room"), options: [.continueInBackground,.retryFailed]) { [weak self] (image, error, cacheType, url) in
                guard let _ = error else{
                    return
                }
                self?.imgvAvatar.image = image
            }
            tfFullName.text = user.fullname
            tfDateOfBirth.text = user.dob?.string("dd/MM/yyyy")
            tfEmail.text = user.email
            tfPhoneNumber.text = user.phone
            sgGender.selectedSegmentIndex = user.gender == 1 ? 0 : 1
            
        }
        
        
    }
    //MARK: Keyboard Notification handler
    override func keyBoard(notification: Notification) {
        super.keyBoard(notification: notification)
        if notification.name == NSNotification.Name.UIKeyboardWillShow{
            let userInfor = notification.userInfo!
            let keyboardFrame:CGRect = (userInfor[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            scrollView.contentInset.bottom = keyboardFrame.size.height + 50.0
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }else if notification.name == NSNotification.Name.UIKeyboardWillHide{
            scrollView.contentInset = .zero
        }
    }
    //MARK: AlertControllerDelegate
    override func alertControllerDelegate(alertController: AlertController, onSelected selectedIndexs: [IndexPath]?) {
        guard let index = selectedIndexs?.first else {
            return
        }
        alertController.dismiss(animated: true, completion: nil)
        if index.row == 0{
            checkPermission(type: .camera)
        }else{
            checkPermission(type: .photoLibrary)
        }
    }
    //MARK: UIImagePickerControllerDelegate
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
                self.imgvAvatar.image = image
                self.uploadImageModel =  UploadImageModel(name: self.generateImageName(), image: image)
                self.lblDescription.textColor = .white
            }
            
            
        }
    }
    //MARK: UIImageView Event
    @objc func onClickImgvAvatar(){
        let alertController = AlertController.showAlertList(withTitle: "ROOM_UPLOAD_SELECT".localized, andMessage: nil, alertStyle: .alert, forViewController: self, data: ["CAMERA".localized,"PHOTO".localized], rhsButtonTitle: nil)
        alertController.delegate = self
    }
    //MARK: DatePicker value changed
    @objc func onDatePickerValueChanged(){
        tfDateOfBirth.text = datePicker.date.string("dd/MM/yyyy")
        user.dob = datePicker.date
    }
    
    //MARK:UITextfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        
        guard let tfInput = textField as? SkyFloatingLabelTextField, let updatedString = (tfInput.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }
        //        print(updatedString)
        switch tfInput {
        case tfFullName:
            user.fullname = updatedString
            if updatedString.count > Constants.MAX_LENGHT_NORMAL_TEXT{
                return false
            }
            if updatedString.isValidName(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_NAME_MAX_CHAR_50".localized
            }
        case tfPhoneNumber:
            user.phone = updatedString
            if updatedString.isValidPhoneNumber(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_PHONE".localized
            }
//            checkDataAndUpdateUI()
        case tfEmail:
            user.email = updatedString
            if updatedString.isValidEmail(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_EMAIL".localized
            }
        case tfUsername:
            user.username = updatedString
            if updatedString.isValidUsername(){
                tfInput.errorMessage =  ""
            }else{
                tfInput.errorMessage =  "ERROR_TYPE_USERNAME".localized
            }
        case tfPassword:
            user.password = updatedString
            if updatedString.isValidPassword(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage =  "ERROR_TYPE_PASSWORD".localized
            }
            
            if repeatPassord.elementsEqual(updatedString){
                tfRepeatPassword.errorMessage = ""
            }else{
                tfRepeatPassword.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT".localized
            }
        case tfRepeatPassword:
            repeatPassord = updatedString
            guard let password = tfPassword.text else{
                return false
            }
            if repeatPassord.elementsEqual(password){
                tfRepeatPassword.errorMessage = ""
            }else{
                tfRepeatPassword.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT".localized
            }
        default:
            
            break
        }
//        checkDataAndUpdateUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func onClickTextfieldDateOfBirth(_ sender: Any) {
        print("onClickTextfieldDateOfBirth ")
    }
    //MARK: Validation
//    func checkDataAndUpdateUI(){
//        if isValidData(){
//            btnNextStep.isEnabled = true
//        }else{
//            btnNextStep.isEnabled = false
//        }
//    }
    func checkDataAndUpdateUI()->Bool{
//        let message = NSMutableAttributedString(string: "")
        var isValid = true
        if !(user.fullname?.isValidName() ?? false){
//            message.append(NSAttributedString(string: "\("PLACE_HOLDER_FULL_NAME".localized) :  \("ERROR_TYPE_NAME_MAX_CHAR_50".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            tfFullName.errorMessage = "ERROR_TYPE_NAME_MAX_CHAR_50".localized
            isValid = false
        }
        
        if !(user.phone?.isValidPhoneNumber() ?? false){
            tfPhoneNumber.errorMessage = "ERROR_TYPE_PHONE".localized
            isValid =  false
//            message.append(NSAttributedString(string: "\("PLACE_HOLDER_PHONE_NUMBER".localized) :  \("ERROR_TYPE_PHONE".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            
        }
        
        if !(user.email?.isValidEmail() ?? false){
            tfEmail.errorMessage = "ERROR_TYPE_EMAIL".localized
            isValid =  false
//            message.append(NSAttributedString(string: "\("PLACE_HOLDER_EMAIL".localized) :  \("ERROR_TYPE_EMAIL".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
            
        }
        if signUpVCType == .normal{
            if !(user.username?.isValidUsername() ?? false){
                tfUsername.errorMessage = "ERROR_TYPE_USERNAME".localized
                isValid =  false
//                message.append(NSAttributedString(string: "\("PLACE_HOLDER_USERNAME".localized) :  \("ERROR_TYPE_USERNAME".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                
            }
            if !(user.password?.isValidPassword() ?? false){
                tfPassword.errorMessage = "ERROR_TYPE_PASSWORD".localized
//                message.append(NSAttributedString(string: "\("PLACE_HOLDER_PASSWORD".localized) :  \("ERROR_TYPE_PASSWORD".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                
                isValid =  false
            }
            
            if !repeatPassord.elementsEqual(user.password ?? ""){
//                message.append(NSAttributedString(string: "\("PLACE_HOLDER_REPEAT_PASSWORD".localized) :  \("ERROR_TYPE_PASSWORD_NOT_REPEAT".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                tfRepeatPassword.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT".localized
                isValid =  false
            }
            if  uploadImageModel == nil{
//                message.append(NSAttributedString(string: "\("PLACE_HOLDER_AVATAR_IMAGE".localized) :  \("ERROR_TYPE_REQUIRED_IMAGE".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
                lblDescription.textColor = .red
                isValid =  false
            }
        }
        
//        if message.string.isEmpty{
//            return true
//        }else{
//            let title = NSAttributedString(string: "INFORMATION".localized, attributes: [NSAttributedStringKey.font:UIFont.boldMedium,NSAttributedStringKey.foregroundColor:UIColor.defaultBlue])
//            AlertController.showAlertInfoWithAttributeString(withTitle: title, forMessage: message, inViewController: self)
//        }
//        return false
        return isValid
    }
    
    
    //MARK: Segment Control event
    @objc func onSegmentControlIndexChange(){
        user.gender = sgGender.selectedSegmentIndex+1
    }
    //MARK: Button Next Step event
    
    @IBAction func onClickBtnNextStep(_ sender: Any) {
        if checkDataAndUpdateUI()  {
            if signUpVCType == .normal{
                checkExistedUser()
            }else{
                requestSaveUser()
            }
        }else{
            AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: "ERROR_TYPE_INPUT".localized, inViewController: self)
        }
    }
    //MARK: Save User
    func requestSaveUser(){
        
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .userInteractive).async {
            if let _ = self.uploadImageModel{
                DispatchQueue.main.async {
                    hub.label.text =  "MB_LOAD_UPLOAD_IMAGE".localized
                }
                self.group.enter()
                self.uploadImage(self.uploadImageModel!)
                self.group.wait()
            }else{
                self.uploadImageModel = UploadImageModel()
                self.uploadImageModel?.linkUrl = self.user.imageProfile
            }
            DispatchQueue.main.async {
                hub.label.text =  "MB_LOAD_SAVE".localized
            }
            if let _  = self.uploadImageModel?.linkUrl{
                APIConnection.request(apiRouter: APIRouter.editUser(model: self.user), completion: { (error, statusCode) -> (Void) in
                    DispatchQueue.main.async {
                        hub.hide(animated: true)
                    }
                    if error == .SERVER_NOT_RESPONSE{
                        DispatchQueue.main.async {
                            APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                        }
                    }else if error == .PARSE_RESPONSE_FAIL{
                        //404
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                    }else{
                        //200
                        if statusCode == .OK{
                            _ = DBManager.shared.addUser(user: UserModel(userMappedModel: self.user))
                            NotificationCenter.default.post(name: Constants.NOTIFICATION_EDIT_USER, object: self.user)
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "EDIT_USER_INFO_SUCCESS".localized, inViewController: self,rhsButtonHandler:{
                                (action) in
                                self.popSelfInNavigationController()
                            })
                        }else if statusCode == .Conflict {
                            DispatchQueue.main.async {
                                APIResponseAlert.apiResponseError(controller: self, type: .exitedUser)
                            }
                        }
                    }
                })
            }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "ROOM_UPLOAD_ERROR".localized, inViewController: self)
            }
        }
    }
    func requestCreateUser(hub:MBProgressHUD){
        DispatchQueue.main.async {
            hub.label.text =  "MB_LOAD_UPLOAD_IMAGE".localized
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if self.signUpVCType == .normal{
                
            }
            self.group.enter()
            self.uploadImage(self.uploadImageModel!)
            self.group.wait()
            DispatchQueue.main.async {
                hub.label.text =  "MB_LOAD_CREATE_USER".localized
            }
            if let _  = self.uploadImageModel?.linkUrl{
                APIConnection.requestObject(apiRouter: APIRouter.createUser(model: self.user), errorNetworkConnectedHander: {
                    DispatchQueue.main.async {
                        hub.hide(animated: true)
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                    }
                }, returnType: CreateResponseModel.self) { (createResponseModel, error, statusCode) -> (Void) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    if error == .SERVER_NOT_RESPONSE{
                        DispatchQueue.main.async {
                            APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                        }
                    }else if error == .PARSE_RESPONSE_FAIL{
                        //404
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                    }else{
                        //200
                        if statusCode ==
                            .Created{
                            guard let id = createResponseModel?.id else{
                                return
                            }
                            DBManager.shared.deleteAllRealmDB()
                            self.user.userId = id
                            _ = DBManager.shared.addUser(user: UserModel(userMappedModel: self.user))
                            _ = DBManager.shared.addSingletonModel(ofType:SettingModel.self, object:SettingModel())
                            DispatchQueue.main.async {
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                appdelegate.window!.rootViewController = self.mainTabBarVC
                            }
                        }else if statusCode == .Conflict {
                            DispatchQueue.main.async {
                                APIResponseAlert.apiResponseError(controller: self, type: .exitedUser)
                            }
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage: "ROOM_UPLOAD_ERROR".localized, inViewController: self)
            }
        }
    }
    func  checkExistedUser(){
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        
        DispatchQueue.global(qos: .background).async {
            APIConnection.request(apiRouter: APIRouter.findByUsername(username: self.user.username!), errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    hub.hide(animated: true)
                }
                APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.HTTP_ERROR)
            }, completion: { (error, statusCode) -> (Void) in
                if error == nil {
                    if statusCode == .OK{
                        DispatchQueue.main.async {
                            hub.hide(animated: true)
                        }
                        APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.exitedUser)
                    }else{
                        self.requestCreateUser(hub:hub)
                    }
                }else{
                    DispatchQueue.main.async {
                        hub.hide(animated: true)
                    }
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: ApiResponseErrorType.SERVER_NOT_RESPONSE)
                }
            })
        }
    }
    
    func uploadImage(_ uploadImageModel:UploadImageModel){
        var urlRequest = try! URLRequest(url: URL(string: "\(Constants.BASE_URL_API)image/upload")!, method: .post, headers:nil)
        urlRequest.timeoutInterval = 40
        let data:Data = UIImageJPEGRepresentation(uploadImageModel.image!, 0.01)!
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: uploadImageModel.name!, mimeType: "image/jpg")
        }, with: urlRequest) { (result) in
            switch result{
            case .failure(let error):
                print(error)
                self.group.leave()
                break
            case .success(let request, let fromDisk, let url):
                request.responseObject(completionHandler: { (response:DataResponse<UploadImageResponseModel>) in
                    if response.error != nil{
                        self.group.leave()
                    }else{
                        guard let uploadImageResponseModel = response.result.value else{
                            self.group.leave()
                            return
                        }
                        print("Upload image url :\(uploadImageResponseModel.imageUrl)")
                        uploadImageModel.linkUrl = uploadImageResponseModel.imageUrl
                        self.user.imageProfile = uploadImageResponseModel.imageUrl
                        self.group.leave()
                    }
                })
                
            }
        }
    }
}
