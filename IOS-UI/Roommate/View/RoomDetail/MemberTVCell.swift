//
//  MemberTVCell.swift
//  Roommate
//
//  Created by TrinhHC on 10/2/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol MemberTVCellDelegate:class {
    func memberTVCellDelegate(memberTVCell cell:MemberTVCell,onClickButtonRate button:UIButton,atIndexPath indexPath:IndexPath)
}
class MemberTVCell: UITableViewCell {

    @IBOutlet weak var lblMemberName: UILabel!
    var buttonTitle:String?{
        didSet{
            btnRate.isHidden = false
            btnRate.setTitle(buttonTitle, for: .normal)
            btnRate.layer.borderColor = UIColor.defaultBlue.cgColor
            btnRate.layer.cornerRadius = 10.0
            btnRate.backgroundColor = .defaultBlue
            btnRate.setTitle(buttonTitle, for: .normal)
            btnRate.tintColor = .white
        }
    }
    var indexPath:IndexPath?
    weak var delegate:MemberTVCellDelegate?
    @IBOutlet weak var btnRate: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMemberName.font = .small
        btnRate.isHidden = true
//        btnRate.tintColor = .defaultBlue
        btnRate.titleLabel?.font = .small
        btnRate.titleLabel?.tintColor = .white
        btnRate.backgroundColor = .defaultBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickBtnRate(_ sender: Any) {
        delegate?.memberTVCellDelegate(memberTVCell: self, onClickButtonRate: btnRate, atIndexPath: indexPath!)
    }
}
