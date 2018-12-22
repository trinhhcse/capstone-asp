//
//  SignInVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SkyFloatingLabelTextField
import MBProgressHUD
//This class for sign up
class SignInVC: BaseVC,UITextFieldDelegate {
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignIn: RoundButton!
    @IBOutlet weak var tfUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var imgvIcon: UIImageView!
    private lazy var mainTabBarVC:MainTabBarVC =  {
        let vc = MainTabBarVC()
        return vc
    }()
    
    var username:String = ""
    var password:String = ""
//    var btnSignIn:UIButton={
//        let btn = UIButton(
//        btn.backgroundColor = .red
//        btn.setTitle("SIGN_IN_TITLE".localized, for: .normal)
//        return btn
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNotificationForKeyboard()
    }
    func setupUI(){
        setBackButtonForNavigationBar()
        imgvIcon.layer.cornerRadius = 15
        imgvIcon.clipsToBounds = true
        
        btnSignIn.setTitle("SIGN_IN_TITLE".localized, for: .normal)
        btnForgotPassword.setTitle("SIGN_IN_TITLE".localized, for: .normal)
        tfUsername.returnKeyType = .done
        tfUsername.placeholder = "PLACE_HOLDER_USERNAME".localized
        tfUsername.title = "PLACE_HOLDER_USERNAME".localized
        tfUsername.errorColor = .red
        tfUsername.selectedLineColor = .defaultBlue
        tfUsername.selectedTitleColor = .defaultBlue
        tfUsername.delegate = self
        
        tfPassword.isSecureTextEntry = true
        tfPassword.returnKeyType = .done
        tfPassword.placeholder = "PLACE_HOLDER_PASSWORD".localized
        tfPassword.title = "PLACE_HOLDER_PASSWORD".localized
        tfPassword.errorColor = .red
        tfPassword.selectedLineColor = .defaultBlue
        tfPassword.selectedTitleColor = .defaultBlue
        tfPassword.delegate = self
        
        btnForgotPassword.setTitle("TITLE_FORGOT_PASSWORD".localized, for: .normal)
        btnForgotPassword.tintColor = .defaultBlue
        
        
    }
    
    @IBAction func onClickBtnForgotPassword(_ sender: Any) {
        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_RESET_PASSWORD, sbName: Constants.STORYBOARD_MAIN) as! ResetPasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: UIButton Event
    @IBAction func onClickBtnSignIn(_ sender: Any) {
        if isValidData(){
//            self.showIndicator()
            
            //Request for user
            requestUser()
        }else{
            AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: "ERROR_TYPE_INPUT".localized, inViewController: self)
        }
    }

    func isValidData()->Bool{
        var isValid = true
        if !username.isValidUsername(){
            tfUsername.errorMessage = "ERROR_TYPE_USERNAME".localized
            isValid = false
        }
        if !password.isValidPassword(){
            tfPassword.errorMessage = "ERROR_TYPE_PASSWORD".localized
            isValid = false
        }
        return isValid
    }
            



    //MARK: UITextFieldDeleage
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let tfFloat = textField as? SkyFloatingLabelTextField,let updatedString = (tfFloat.text as NSString?)?.replacingCharacters(in: range, with: string){
            if tfFloat == tfUsername{
                username = updatedString
                if updatedString.isValidUsername(){
                    tfFloat.errorMessage = ""
                }else{
                    tfFloat.errorMessage = "ERROR_TYPE_USERNAME".localized
                }
                
            }else{
                password = updatedString
                if updatedString.isValidPassword(){
                    tfFloat.errorMessage = ""
                }else{
                    tfFloat.errorMessage = "ERROR_TYPE_PASSWORD".localized
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:Other methods
    func requestUser(){
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        hub.label.text = "MB_SIGN_IN_TITLE".localized
        DispatchQueue.global(qos: .userInitiated).async {
            APIConnection.requestObject(apiRouter: APIRouter.login(username: self.username, password: self.password), errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                }
            }, returnType: UserMappableModel.self) { (user, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                if error == .SERVER_NOT_RESPONSE {
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                }else if error == .PARSE_RESPONSE_FAIL{
                    //404
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                }else{
                    //200
                    if statusCode == .OK{
                        DBManager.shared.deleteAllRealmDB()
                        user?.password = self.password
                        let userModel = UserModel(userMappedModel: user!)
                        _ = DBManager.shared.addSingletonModel(ofType: UserModel.self, object: userModel)
                        _ = DBManager.shared.addSingletonModel(ofType: SettingModel.self, object: SettingModel())
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        appdelegate.window!.rootViewController = self.mainTabBarVC
                        
                        //403 || 404
                    }else if statusCode == .Forbidden || statusCode == .NotFound {
                        APIResponseAlert.apiResponseError(controller: self, type: APIResponseAlertType.invalidUsernameOrPassword)
                    }else{
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                    }
                }
            }
        }
    }
    
    
    @objc override func keyBoard(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame,from: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide{
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 30, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
}
