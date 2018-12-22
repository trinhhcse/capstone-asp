//
//  MaxMemberSelectView.swift
//  Roommate
//
//  Created by TrinhHC on 10/2/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol MaxMemberSelectViewDelegate:class{
    func maxMemberSelectViewDelegate(view maxMemberSelectView:MaxMemberSelectView,onClickBtnSub btnSub:UIButton)
    func maxMemberSelectViewDelegate(view maxMemberSelectView:MaxMemberSelectView,onClickBtnPlus btnPlus:UIButton)
}
class MaxMemberSelectView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblContent: UILabel!
    var text: String?{
        get{
            return self.lblContent.text
        }
        set{
            self.lblContent.text = newValue
        }
    }
    var minMember = Constants.MIN_MEMBER
    var maxMember = Constants.MAX_MEMBER
    var delegate:MaxMemberSelectViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = "MAX_NUMBER_OF_PERSON".localized
        lblTitle.font = .smallTitle
        
        lblContent.text = "1"
        lblContent.font = .boldSmall
        
        btnSub.setImage(UIImage(named: "substract"), for: .normal)
        btnPlus.setImage(UIImage(named: "add"), for: .normal)

        btnSub.tintColor = .white
        btnPlus.tintColor = .white
        
        btnSub.backgroundColor = .defaultBlue
        btnPlus.backgroundColor = .defaultBlue
        
        btnSub.layer.cornerRadius = btnSub.frame.width/2
        btnPlus.layer.cornerRadius = btnPlus.frame.width/2
        
    }
    @IBAction func onClickBtnSub(_ sender: Any) {
        guard let text = lblContent.text, let int = Int(text),int != minMember else {
            return
        }
        self.text = "\(int - 1)"
        delegate?.maxMemberSelectViewDelegate(view: self, onClickBtnSub: btnSub)
    }
    
    @IBAction func onClickBtnPlus(_ sender: UIButton) {
        
        guard let text = lblContent.text, let int = Int(text),int != maxMember else {
            return
        }
        self.text = "\(int + 1)"
        delegate?.maxMemberSelectViewDelegate(view: self, onClickBtnPlus: btnPlus)
    }
}
