//
//  NewInputView.swift
//  Roommate
//
//  Created by TrinhHC on 10/11/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol InputViewDelegate:class {
    func inputViewDelegate(inputView view:InputView,shouldChangeCharactersTo string:String)->Bool
}
class InputView: UIView,UITextFieldDelegate {
    @IBOutlet weak var tfInput: SkyFloatingLabelTextField!
    weak var delegate:InputViewDelegate?
    var text:String?{
        get{
            return self.tfInput.text
        }
        set{
            self.tfInput.text = newValue
        }
    }
    var errorMessage:String?{
        didSet{
            tfInput.errorMessage = errorMessage
        }
    }
    var isSelectedFromSuggest:Bool = false
    lazy var maxPrice = Constants.MAX_PRICE
    lazy var minPrice = Constants.MIN_PRICE
    var inputViewType:InputViewType?{
        didSet{
            switch self.inputViewType! {
            case .roomName:
                tfInput.setupUI(placeholder: "ROOM_NAME_TITLE", title: "ROOM_NAME_TITLE", delegate: self)
            case .price:
                tfInput.addToobarButton()
                tfInput.setupUI(placeholder: "PRICE", title: "PRICE", keyboardType: .numberPad, delegate: self)
            //                initData(title: "PRICE", placeHolder: "PLACE_HOLDER_PRICE")
            case .area:
                tfInput.addToobarButton()
                tfInput.setupUI(placeholder: "ROOM_AREA_TITLE", title: "ROOM_AREA_TITLE", keyboardType: .numberPad, delegate: self)
            //                initData(title: "ROOM_AREA_TITLE", placeHolder: "PLACE_HOLDER_AREA")
            case .address:
                tfInput.setupUI(placeholder: "ROOM_ADDRESS_TITLE_REQUIRED_DISTRICT", title: "ROOM_ADDRESS_TITLE", delegate: self)
            //                initData(title: "ROOM_ADDRESS_TITLE", placeHolder: "PLACE_HOLDER_ADDRESS")
            case .phone:
                tfInput.addToobarButton()
                tfInput.setupUI(placeholder: "PLACE_HOLDER_PHONE_NUMBER", title: "PLACE_HOLDER_PHONE_NUMBER", keyboardType: .numberPad, delegate: self)
            case .roomPostName:
                tfInput.setupUI(placeholder: "ROOM_POST_NAME", title: "ROOM_POST_NAME", delegate: self)
            case .password:
                tfInput.setupUI(placeholder: "PLACE_HOLDER_PASSWORD", title: "PLACE_HOLDER_PASSWORD",isSecureTextEntry:true, delegate: self)
            case .newPassword:
                tfInput.setupUI(placeholder: "PLACE_HOLDER_NEW_PASSWORD", title: "PLACE_HOLDER_NEW_PASSWORD",isSecureTextEntry:true, delegate: self)
            case .oldPassword:
                tfInput.setupUI(placeholder: "PLACE_HOLDER_OLD_PASSWORD", title: "PLACE_HOLDER_OLD_PASSWORD",isSecureTextEntry:true, delegate: self)
            case .repeatPassword:
                tfInput.setupUI(placeholder: "PLACE_HOLDER_REPEAT_PASSWORD", title: "PLACE_HOLDER_REPEAT_PASSWORD",isSecureTextEntry:true, delegate: self)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfInput.delegate = self
        tfInput.returnKeyType = .next
    }
    func initData(title:String,placeHolder:String){
        //        lblTitle.text = title.localized
        tfInput.attributedPlaceholder = NSAttributedString(string: placeHolder.localized, attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightSubTitle])
    }
    
    //MARK:UITextfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        guard let updatedString = (tfInput.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }
        
        if !validInformation(updatedString: updatedString){
            return false
        }else{
            return delegate?.inputViewDelegate(inputView: self, shouldChangeCharactersTo: updatedString) ?? false
        }
    }
    func showErrorView(){
        _ = validInformation(updatedString: self.tfInput.text ?? "")
    }
    
    func validInformation(updatedString:String)->Bool{
        switch self.inputViewType! {
        case .roomName:
            if updatedString.count > Constants.MAX_LENGHT_NORMAL_TEXT{
                return false
            }
            if updatedString.isValidName(){
                tfInput.errorMessage = ""
                
            }else{
                tfInput.errorMessage = "ERROR_TYPE_NAME_MAX_CHAR_50".localized
            }
        case .roomPostName:
            if updatedString.count > Constants.MAX_LENGHT_NORMAL_TEXT{
                return false
            }
            if updatedString.isValidName(){
                tfInput.errorMessage = ""
                
            }else{
                tfInput.errorMessage = "ERROR_TYPE_NAME_MAX_CHAR_50".localized
            }
        case .price:
            if let value = updatedString.toDouble() , (value >= minPrice && value <= maxPrice){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = String(format: "ERROR_TYPE_PRICE".localized, Int(minPrice).formatString,Int(maxPrice).formatString)
            }
        case .area:
            if updatedString.isValidArea(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_AREA".localized
            }
        case .address:
            if isSelectedFromSuggest{
                if updatedString.count < (tfInput.text?.count)!{
                    tfInput.text = ""
                    isSelectedFromSuggest = false
                }
            }
            //            if updatedString.count > Constants.MAX_LENGHT_ADDRESS{
            //                return false
            //            }
            if updatedString.isValidAddress(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_ADDRESS".localized
            }
        case .phone:
            if updatedString.isValidPhoneNumber(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_PHONE".localized
            }
        case .password,.newPassword,.oldPassword,.repeatPassword:
            if updatedString.isValidPassword(){
                tfInput.errorMessage = ""
            }else{
                tfInput.errorMessage = "ERROR_TYPE_PASSWORD".localized
            }
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponderTextField()
        return true
    }
    
    //MARK: Another
    func becomeFirstResponderTextField(returnKeyType:UIReturnKeyType){
        tfInput.returnKeyType = returnKeyType
        tfInput.becomeFirstResponder()
    }
    func resignFirstResponderTextField(){
        tfInput.resignFirstResponder()
    }
}
