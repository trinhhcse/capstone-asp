//
//  DropdownListView.swift
//  Roommate
//
//  Created by TrinhHC on 10/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol DropdownListViewDelegate:class {
    func dropdownListViewDelegate(view dropdownListView:DropdownListView,onClickBtnChangeSelect btnSelect:UIButton)
}
class DropdownListView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    weak var delegate:DropdownListViewDelegate?
    var text:String?{
        didSet{
            lblSelectTitle.text = text
            lblSelectTitle.textColor = .lightSubTitle
        }
    }
    var dropdownListViewType:DropdownListViewType?{
        didSet{
            if dropdownListViewType == .city{
                lblTitle.text = "CITY".localized
            }else if dropdownListViewType == .district{
                lblTitle.text = "DISTRICT".localized
            }else if dropdownListViewType == .roomMaster{
                lblTitle.text = "EDIT_MEMBER_ROOM_MASTER".localized
            }
            lblSelectTitle.text = "SELECT".localized
            lblSelectTitle.textColor = .red
        }
    }
    var  lblSelectTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "SELECT".localized
        lbl.textColor = .lightSubTitle
        lbl.font = .small
        lbl.textAlignment = .left
        return lbl
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSelect.layer.cornerRadius = 10
        btnSelect.clipsToBounds = true
        btnSelect.layer.borderWidth = 0.5
        btnSelect.layer.borderColor = UIColor.lightGray.cgColor
        
        
        lblTitle.font = .smallTitle
        let imageView = UIImageView(image: UIImage(named: "down-arrow"))
        imageView.tintColor = .defaultBlue
        btnSelect.addSubview(imageView)
        btnSelect.addSubview(lblSelectTitle)
        _ = imageView.anchor(btnSelect.topAnchor,nil,btnSelect.bottomAnchor,btnSelect.rightAnchor,UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -20))
        _ = imageView.anchorWidth(equalTo: btnSelect.heightAnchor, constant: -20)
        _ = lblSelectTitle.anchor(btnSelect.topAnchor,btnSelect.leftAnchor,btnSelect.bottomAnchor,imageView.leftAnchor,UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))

    }
    @IBAction func onClickBtnSelect(_ sender: UIButton) {
        delegate?.dropdownListViewDelegate(view: self, onClickBtnChangeSelect: sender)
    }
}
