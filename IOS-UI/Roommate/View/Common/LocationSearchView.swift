//
//  LocationSearchView.swift
//  Roommate
//
//  Created by TrinhHC on 10/22/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol LocationSearchViewDelegate:class{
    func locationSearchViewDelegate(locationSearchView view:LocationSearchView,onClickButtonLocation btnLocation:UIButton)
}
class LocationSearchView: UIView {

    @IBOutlet weak var btnLocation: UIButton!
    weak var delegate:LocationSearchViewDelegate?
    var lblTitle = UILabel()
    var location:String?{
        didSet{
            lblTitle.text = location
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(hexString: "f7f7f7")
        layer.cornerRadius = 10
        clipsToBounds = true
        btnLocation.backgroundColor = .clear
        lblTitle.font = .small
        lblTitle.textColor = .defaultBlue
        lblTitle.textAlignment = .center
        
//        if let setting = DBManager.shared.getSetting(),let name = DBManager.shared.getRecord(id: setting.cityId, ofType: CityModel.self)?.name{
//            lblTitle.text = name
//        }else{
//            lblTitle.text = "LIST_CITY_TITLE".localized
//        }
        
        
        let imageView = UIImageView(image: UIImage(named: "location"))
        imageView.tintColor = .defaultBlue
        imageView.contentMode = .scaleAspectFit
        
        btnLocation.addSubview(imageView)
        btnLocation.addSubview(lblTitle)
        _ = imageView.anchor(btnLocation.topAnchor, btnLocation.leftAnchor, btnLocation.bottomAnchor, nil,UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        _ = imageView.anchorWidth(equalTo: btnLocation.heightAnchor, constant: -24)
        _ = lblTitle.anchor(btnLocation.topAnchor,imageView.rightAnchor,btnLocation.bottomAnchor,btnLocation.rightAnchor)
    }
    @IBAction func onClickBtnLocation(_ sender: Any) {
        delegate?.locationSearchViewDelegate(locationSearchView: self, onClickButtonLocation: btnLocation)
    }
}
