//
//  ChangePasswordVC.swift
//  Roommate
//
//  Created by TrinhHC on 12/9/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class ChangePasswordVC: BaseVC ,InputViewDelegate{
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        return sv
    }()
    let contentView:UIView={
        let cv = UIView()
        return cv
    }()
    lazy var oldPasswordInputView:InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .oldPassword
        iv.delegate = self
        return iv
    }()
    
    lazy var newPasswordInputView:InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .newPassword
        iv.delegate = self
        return iv
    }()
    
    lazy var repeatPasswordInputView:InputView = {
        let iv:InputView = .fromNib()
        iv.inputViewType = .repeatPassword
        iv.delegate = self
        return iv
    }()
    
    var changePasswordRequestModel:ChangePasswordRequestModel = ChangePasswordRequestModel()
    var repeatPassword:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        title = "TITLE_CHANGE_PASSWORD".localized
        
        let barButtonItem = UIBarButtonItem(title: "SAVE".localized, style: .done, target: self, action: #selector(onClickBtnSave))
        barButtonItem.tintColor  = .defaultBlue
        navigationItem.rightBarButtonItem = barButtonItem
        
        setBackButtonForNavigationBar()
        let contentViewHeight = 3*Constants.HEIGHT_INPUT_VIEW
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(oldPasswordInputView)
        contentView.addSubview(newPasswordInputView)
        contentView.addSubview(repeatPasswordInputView)
        
        if #available(iOS 11.0, *) {
            _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        } else {
            // Fallback on earlier versions
            _ = scrollView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10))
        }
        
        _ = contentView.anchor(scrollView.topAnchor,scrollView.leftAnchor,scrollView.bottomAnchor,scrollView.rightAnchor)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        _  = contentView.anchorHeight(equalToConstrant: contentViewHeight)
        
        _ = oldPasswordInputView.anchor(contentView.topAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        _ = newPasswordInputView.anchor(oldPasswordInputView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        _ = repeatPasswordInputView.anchor(newPasswordInputView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_INPUT_VIEW))
        
    }
    
    func inputViewDelegate(inputView view: InputView, shouldChangeCharactersTo string: String) -> Bool {
        switch view {
        case oldPasswordInputView:
            changePasswordRequestModel.oldPassword = string
        case newPasswordInputView:
            changePasswordRequestModel.newPassword = string
            if !repeatPassword.elementsEqual(string){
                repeatPasswordInputView.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT".localized
            }
        case repeatPasswordInputView:
            repeatPassword = string
            if !repeatPassword.elementsEqual(changePasswordRequestModel.newPassword){
                view.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT".localized
            }
        default:
            break
        }
        return true
    }
    
    @objc func onClickBtnSave(){
        if isValidData(){
            changePasswordRequestModel.userId = DBManager.shared.getUser()!.userId
            changePassword()
        }else{
            AlertController.showAlertInfor(withTitle: "NETWORK_STATUS_TITLE".localized, forMessage: "ERROR_TYPE_INPUT".localized, inViewController: self)
        }
    }
    func isValidData()->Bool{
        var isValid = true
        if !changePasswordRequestModel.oldPassword.isValidPassword(){
            oldPasswordInputView.showErrorView()
            isValid = false
        }
        
        if !changePasswordRequestModel.newPassword.isValidPassword(){
            newPasswordInputView.showErrorView()
            isValid = false
        }
        
        if !repeatPassword.elementsEqual(changePasswordRequestModel.newPassword){
            oldPasswordInputView.showErrorView()
            oldPasswordInputView.errorMessage = "ERROR_TYPE_PASSWORD_NOT_REPEAT"
            isValid = false
        }
        
        return isValid
    }
    func changePassword(){
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        DispatchQueue.global(qos: .userInteractive).async {
            APIConnection.request(apiRouter:APIRouter.changePassowrd(model: self.changePasswordRequestModel) ,  errorNetworkConnectedHander: {
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
                            let user = UserMappableModel(userModel: DBManager.shared.getUser()!)
                            _ = DBManager.shared.addSingletonModel(ofType: UserModel.self, object: UserModel(userMappedModel: user))
                            
                            AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage:  "TITLE_CHANGE_PASSWORD_SUCCESS".localized, inViewController: self,rhsButtonHandler: {
                                (action) in
                                self.popSelfInNavigationController()
                            })
                            
                        }
                    }else if statusCode == .Forbidden{
                        AlertController.showAlertInfor(withTitle: "INFORMATION".localized, forMessage:  "ERROR_OLD_PASSWORD".localized, inViewController: self,rhsButtonHandler: nil)
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
