//
//  GenderView.swift
//  Roommate
//
//  Created by TrinhHC on 10/2/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol GenderViewDelegate :class{
    func genderViewDelegate(genderView view:GenderView,onChangeGenderSelect genderSelect:GenderSelect?)
}
class GenderView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    weak var delegate:GenderViewDelegate?
    
    var genderSelect:GenderSelect?{
        didSet{
            select()
        }
    }
    
    var viewType:ViewType?{
        didSet{
            if  viewType == .detailForMember || viewType == .detailForOwner || viewType == .roomPostDetailForFinder || viewType == .roommatePostDetailForFinder{
                btnMale.isUserInteractionEnabled = false
                btnFemale.isUserInteractionEnabled = false
                lblDescription.isHidden = true
            }else{
                btnMale.isUserInteractionEnabled = true
                btnFemale.isUserInteractionEnabled = true
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = "GENDER_ACCEPT".localized
        lblTitle.font = .smallTitle
        
        lblDescription.font = .verySmall
        lblDescription.attributedText = NSAttributedString(string: "GENDER_REQUIRED_DESCRIPTION".localized, attributes: [NSAttributedStringKey.foregroundColor:UIColor.red])
        
        btnMale.tintColor = .clear
        btnMale.setTitle("MALE".localized, for: .normal)
        btnMale.layer.cornerRadius = btnFemale.frame.height/2
        btnMale.layer.borderColor = UIColor.lightSubTitle.cgColor
        deselect(button: btnMale)
        
        btnFemale.tintColor = .clear
        btnFemale.setTitle("FEMALE".localized, for: .normal)
        btnFemale.layer.cornerRadius = btnFemale.frame.height/2
        btnFemale.layer.borderColor = UIColor.lightSubTitle.cgColor
        deselect(button: btnFemale)
        
    }
    @IBAction func onChangeGenderSelect(_ sender: UIButton) {
        if sender == btnMale{
            genderSelect = genderSelect == GenderSelect.male ? GenderSelect.none : genderSelect == GenderSelect.female ?  GenderSelect.both : genderSelect == GenderSelect.both ?  GenderSelect.female :  GenderSelect.male
        }else{
            genderSelect = genderSelect == GenderSelect.female ? GenderSelect.none : genderSelect == GenderSelect.male ?  GenderSelect.both : genderSelect == GenderSelect.both ?  GenderSelect.male :  GenderSelect.female
        }
        delegate?.genderViewDelegate(genderView: self, onChangeGenderSelect: genderSelect)
    }
    
    func select(){
//        btnMale.isSelected = genderSelect == GenderSelect.both || genderSelect == GenderSelect.male ? true : false
//        btnFemale.isSelected = genderSelect == GenderSelect.both || genderSelect == GenderSelect.female ? true : false
        if genderSelect == GenderSelect.male{
            select(button: btnMale)
            deselect(button: btnFemale)
            if  viewType == .detailForMember || viewType == .detailForOwner || viewType == .roomPostDetailForFinder || viewType == .roommatePostDetailForFinder{
                btnFemale.isHidden = true
            }
        }else if genderSelect == GenderSelect.female{
            select(button: btnFemale)
            deselect(button: btnMale)
            if  viewType == .detailForMember || viewType == .detailForOwner || viewType == .roomPostDetailForFinder || viewType == .roommatePostDetailForFinder{
                btnMale.isHidden = true
            }
        }else if genderSelect == GenderSelect.both{
            select(button: btnMale)
            select(button: btnFemale)
        }else{
            //Select none
            deselect(button: btnMale)
            deselect(button: btnFemale)
        }
        layoutIfNeeded()
    }
    
    func select(button:UIButton){
        //Select
        button.isSelected = true
        button.layer.borderWidth = 0
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .defaultBlue
    }
    func deselect(button:UIButton)  {
        //Deselect
        button.isSelected = false
        button.layer.borderWidth = 1.0
        button.setTitleColor(.lightSubTitle, for: .normal)
        button.backgroundColor = .white
        
    }
    
}

