//
//  AddMemberView.swift
//  Roommate
//
//  Created by TrinhHC on 11/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
protocol AddMemberViewDelegate:class {
    func addMemberViewDelegate(addMemberView view:AddMemberView,shouldChangeCharactersTo string:String)->Bool
    func addMemberViewDelegate(addMemberView view:AddMemberView,onClickBtnAdd btnAdd:UIButton)
}
class AddMemberView: UIView ,UITextFieldDelegate{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAdd: UIButton!
    weak var delegate:AddMemberViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.font = .boldMedium
        lblTitle.text = "EDIT_MEMBER_TITLE".localized;
        
//        tfUsername.placeholder = "EDIT_MEMBER_USERNAME".localized
//        tfUsername.placeholderColor = .lightGray
//        tfUsername.titleColor = .defaultBlue
//        tfUsername.title = "EDIT_MEMBER_USERNAME".localized
//        tfUsername.errorColor = .red
//        tfUsername.selectedLineColor = .defaultBlue
//        tfUsername.selectedTitleColor = .defaultBlue//Title color
//        tfUsername.delegate = self
        tfUsername.setupUI(placeholder: "EDIT_MEMBER_USERNAME", title: "EDIT_MEMBER_USERNAME", delegate: self)
        
        btnAdd.setTitle("EDIT_MEMBER_ADD".localized, for: .normal)
        btnAdd.backgroundColor = .defaultBlue
        btnAdd.tintColor = .white
        btnAdd.layer.cornerRadius  = 10
        btnAdd.clipsToBounds = true
    }
    //MARK:UITextfieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedString = (tfUsername.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }
        tfUsername.errorMessage = updatedString.isValidUsername() ?  "" :  "ERROR_TYPE_USERNAME".localized
        return delegate?.addMemberViewDelegate(addMemberView: self, shouldChangeCharactersTo: updatedString) ?? false
    }
    //MARK: Button event
    @IBAction func onClickBtnAdd(_ sender: UIButton) {
        self.delegate?.addMemberViewDelegate(addMemberView: self, onClickBtnAdd: sender)
    }
    //MARK: Others
    func clearText(){
        self.tfUsername.text = ""
    }
}
