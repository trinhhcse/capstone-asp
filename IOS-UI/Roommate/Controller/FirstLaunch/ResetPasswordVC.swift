//
//  ForgotPasswordVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import MBProgressHUD
class ResetPasswordVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
 
    @IBOutlet weak var btnSendEmail: RoundButton!
    var email:String = ""
    override func viewDidLoad() {
      
        super.viewDidLoad()
       setupUI()
        registerNotificationForKeyboard()
    }
    
    func setupUI(){
        setBackButtonForNavigationBar()
        
        title = "TITLE_GET_PASSWORD".localized
        btnSendEmail.setTitle("TITLE_SEND_EMAIL".localized, for: .normal)
        tvDescription.layer.borderWidth = 1
        tvDescription.isEditable = false
        tvDescription.isUserInteractionEnabled = false
        tvDescription.text = "TITLE_FORGOT_PASSWORD_DESCRIPTION".localized
        
        tfEmail.placeholder = "PLACE_HOLDER_EMAIL".localized
        tfEmail.placeholderColor = UIColor.lightGray
        tfEmail.titleColor = .defaultBlue
        tfEmail.title = "PLACE_HOLDER_EMAIL".localized
        tfEmail.errorColor = .red
        tfEmail.selectedLineColor = .defaultBlue
        tfEmail.selectedTitleColor = .defaultBlue//Title color
        tfEmail.delegate = self
        btnSendEmail.isEnabled = false
        
    }
    //MARK:UITextfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        guard let updatedString = (tfEmail.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }
        
        if updatedString.isValidEmail(){
            tfEmail.errorMessage = ""
            btnSendEmail.isEnabled = true
        }else{
            btnSendEmail.isEnabled = false
            tfEmail.errorMessage = "ERROR_TYPE_EMAIL".localized
        }
        self.email = updatedString
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        resignFirstResponderTextField()
        textField.resignFirstResponder()
        return true
    }
    @IBAction func onClickBtnSendEmail(_ sender: Any) {
        resetPassword()
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
    func resetPassword(){
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .userInteractive).async {
            APIConnection.request(apiRouter:APIRouter.resetPassword(email:self.email) ,  errorNetworkConnectedHander: {
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
                    if statusCode == .OK {
                        DispatchQueue.main.async {
                            hub.hide(animated: true)
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage:  "TITLE_GET_PASSWORD_SUCCESS".localized, inViewController: self,rhsButtonHandler: {
                                (action) in
                                self.popSelfInNavigationController()
                            })
                            
                        }
                    }else if statusCode == .NotFound{
                        AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage:  "ERROR_NON_EXIST_USER_WITH_EMAIL".localized, inViewController: self,rhsButtonHandler: nil)
                    }else  if statusCode == .Conflict{
                        DispatchQueue.main.async {
                            APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                        }
                    }
                }
            })
        }
    }
}
