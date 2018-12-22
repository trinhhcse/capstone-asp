//
//  UtilityInputView.swift
//  Roommate
//
//  Created by TrinhHC on 10/6/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class UtilityInputView: UIView,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
//    var delegate:UtilityInputViewDelegate?
    var utilityModel: UtilityMappableModel?{
        didSet{
            tfBrand.text = utilityModel?.brand
            tfQuantity.text = utilityModel?.quantity.toString
            tvDescription.text = utilityModel?.utilityDescription
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tfBrand.placeholder = "BRAND_PLACE_HOLDER".localized
        tfQuantity.placeholder = "QUANTITY_PLACE_HOLDER".localized
        tvDescription.text = "DESCRIPTION_PLACE_HOLDER".localized
        tvDescription.textColor = .lightGray
        tvDescription.delegate = self
        
        tfBrand.delegate = self
        tfQuantity.delegate = self
        tvDescription.delegate = self
        
         
        //Init data
        utilityModel = UtilityMappableModel()
    }
    
    //MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "DESCRIPTION_PLACE_HOLDER".localized
            tvDescription.textColor = .lightGray
        }else{
            utilityModel?.utilityDescription = textView.text
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            if textField == tfBrand{
                utilityModel?.brand = text
            }else if textField == tfQuantity, let int = Int(text) {
                //Quantity
                utilityModel?.quantity =  int
            }
        }
    }
    
}
