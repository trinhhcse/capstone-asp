//
//  UtilityInputVC.swift
//  Roommate
//
//  Created by TrinhHC on 10/16/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol UtilityInputVCDelegate:class{
    func utilityInputVCDelegate(onCompletedInputUtility utility: UtilityMappableModel, atIndexPath indexPath:IndexPath?)
    func utilityInputVCDelegate(onDeletedInputUtility utility: UtilityMappableModel, atIndexPath indexPath:IndexPath?)
}
class UtilityInputVC: BaseVC ,UITextFieldDelegate,UITextViewDelegate{
    @IBOutlet weak var tfBrand: SkyFloatingLabelTextField!
    @IBOutlet weak var tfQuantity: SkyFloatingLabelTextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var popupView: UIView!
    var utilityModel = UtilityMappableModel()
    var indexPath:IndexPath?
    var delegate:UtilityInputVCDelegate?
    var quantity:String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupView.clipsToBounds = true
        lblTitle.textAlignment = .center
        lblTitle.text = utilityModel.name.localized
        lblDescription.text = "DESCRIPTION".localized
        setupTFUI(tfBrand,placeholder: "BRAND_PLACE_HOLDER", title: "BRAND_PLACE_HOLDER")
        setupTFUI(tfQuantity,placeholder: "QUANTITY_PLACE_HOLDER", title: "QUANTITY_PLACE_HOLDER",keyboardType:UIKeyboardType.numberPad)

        tvDescription.textColor = .black
        tvDescription.addToobarButton()
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        tvDescription.delegate = self
        tfBrand.delegate = self
        tfQuantity.delegate = self
        btnLeft.setTitle("CANCEL".localized, for: .normal)
        btnRight.setTitle("OK".localized, for: .normal)
        
        
        tfBrand.text = utilityModel.brand
        tfQuantity.text =  utilityModel.quantity.toString
        tvDescription.text = utilityModel.utilityDescription
        
        btnLeft.setTitleColor(.defaultBlue, for: .normal)
        btnRight.setTitleColor(.defaultBlue, for: .normal)
        
        
    }

    func setupTFUI(_ tfInput:SkyFloatingLabelTextField,placeholder:String,title:String,keyboardType:UIKeyboardType? = .default,returnKeyType:UIReturnKeyType? = .done){
        //        tfInput.isSecureTextEntry = true
        tfInput.returnKeyType = returnKeyType!
        tfInput.placeholder = placeholder.localized
        tfInput.placeholderColor = .lightGray
        tfInput.titleColor = .defaultBlue
        tfInput.keyboardType = keyboardType!
        tfInput.title = title.localized
        tfInput.errorColor = .red
        tfInput.selectedLineColor = .defaultBlue
        tfInput.selectedTitleColor = .defaultBlue//Title color
        tfInput.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string){
            if textField == tfBrand{
                utilityModel.brand = updatedString
                if updatedString.isValidBrand(){
                    tfBrand.errorMessage = ""
                }else{
                    tfBrand.errorMessage = "ERROR_TYPE_BRAND".localized
                }
            }else{
                quantity = updatedString
                if updatedString.isValidQuantity(){
                    tfQuantity.errorMessage = ""
                }else{
                    tfQuantity.errorMessage = "ERROR_TYPE_QUANTITY".localized
                }
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text){
            if updatedString.count > Constants.MAX_LENGHT_DESCRIPTION{
                textView.text = text
                return false
            }
            utilityModel.utilityDescription = updatedString
        }
        return true
    }
    @IBAction func onclickBtnLeft(_ sender: Any) {
        self.delegate?.utilityInputVCDelegate(onDeletedInputUtility: utilityModel,atIndexPath:indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onclickBtnRight(_ sender: Any) {
        if checkValidInformation(){
            self.utilityModel.quantity = quantity.toInt()!
            self.delegate?.utilityInputVCDelegate(onCompletedInputUtility: utilityModel,atIndexPath:indexPath)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func checkValidInformation()->Bool{
        let message = NSMutableAttributedString(string: "")
        
        if !utilityModel.brand.isValidBrand(){
            message.append(NSAttributedString(string: "\("BRAND_PLACE_HOLDER".localized) :  \("ERROR_TYPE_BRAND".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
        }
        
        if !quantity.isValidQuantity(){
            message.append(NSAttributedString(string: "\("QUANTITY_PLACE_HOLDER".localized) :  \("ERROR_TYPE_QUANTITY".localized)\n", attributes: [NSAttributedStringKey.font:UIFont.small]))
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
