//
//  OptionView.swift
//  Roommate
//
//  Created by TrinhHC on 10/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol OptionViewDelegate:class {
    func optionViewDelegate(view optionView:OptionView,onClickBtnLeft btnLeft:UIButton)
    func optionViewDelegate(view optionView:OptionView,onClickBtnRight btnRight:UIButton)
}
class OptionView: UIView {

    @IBOutlet weak var imgvLeft: UIImageView!
    @IBOutlet weak var tvPrice: UITextView!
    @IBOutlet weak var tvDate: UITextView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    weak var delegate:OptionViewDelegate?
    var viewType:ViewType?{
        didSet{
            switch viewType! {
            case .detailForOwner:
                btnEdit.setImage(UIImage(named: "edit"), for: .normal)
                btnRight.setImage(UIImage(named: "remove"), for: .normal)
            case .detailForMember,.currentDetailForMember,.roomPostDetailForFinder,.roommatePostDetailForFinder:
                btnEdit.setImage(UIImage(named: "sms"), for: .normal)
                btnRight.setImage(UIImage(named: "call"), for: .normal)
            default:
                //for future
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Default
        imgvLeft.image = UIImage(named: "home")
        setupUI(forButton: btnEdit,imageName: "edit")
        setupUI(forButton: btnRight,imageName:"remove" )
        
        tvPrice.font = .small
        tvPrice.textContainer.lineBreakMode = .byWordWrapping
        tvPrice.isEditable = false
        tvPrice.isUserInteractionEnabled = false
        tvPrice.textColor = .red
        tvDate.font = .small
        tvDate.textContainer.lineBreakMode = .byWordWrapping
        tvDate.isEditable = false
        tvDate.isUserInteractionEnabled = false
        tvDate.textColor = .red

        addBorder(side: .Top, color: .lightGray, width: 1.0)
    }
    
    @IBAction func onClickBtnEdit(_ sender: UIButton) {
        delegate?.optionViewDelegate(view: self, onClickBtnLeft: sender)
    }
    @IBAction func onClickBtnRemove(_ sender: UIButton) {
        delegate?.optionViewDelegate(view: self, onClickBtnRight: sender)
    }
    func setupUI(forButton button:UIButton,imageName:String){
        button.setImage(UIImage(named: imageName), for: .normal)
        button.layer.cornerRadius = btnEdit.frame.width/2
        button.tintColor = .white
        button.backgroundColor = .defaultBlue
    }
    
}
