//
//  UserView.swift
//  Roommate
//
//  Created by TrinhHC on 11/7/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SDWebImage
protocol UserViewDelegate:class{
    func userViewDelegate(onSelectedUserView view:UserView)
}
class UserView: UIView {

    @IBOutlet weak var lbltop: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var imgvIcon: UIImageView!
    var user:UserModel?{
        didSet{
            lbltop.text = user!.fullname
        }
    }
    weak var delegage:UserViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbltop.font = .boldMedium
        
        lblBottom.font = .small
        lblBottom.textColor = .lightGray
        lblBottom.text = "TITLE_USER_DETAIL".localized
        imgvIcon.image = UIImage(named: "right-arrow")
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelf)))
    }
    @objc func didTapSelf(){
        delegage?.userViewDelegate(onSelectedUserView: self)
    }
}
