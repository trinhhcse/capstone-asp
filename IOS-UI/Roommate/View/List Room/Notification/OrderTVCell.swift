//
//  OrderCell.swift
//  Roommate
//
//  Created by TrinhHC on 9/25/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class OrderTVCell : UITableViewCell{
    
    var lblOrderType:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: .small)
        lbl.textColor = UIColor(hexString: "00A8B5")
        lbl.numberOfLines = 0
        return lbl
    }()
    //Default orderType
    var orderType:OrderType = OrderType.lowToHightPrice
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(lblOrderType)
        
        _ = lblOrderType.anchorTopLeft(topAnchor, leftAnchor,0,Constants.MARGIN_6, self.frame.width-Constants.MARGIN_6,self.frame.height)
    }
    
    func setOrderTitle(title:String,orderType:OrderType){
        lblOrderType.text = title.localized
        self.orderType  = orderType
    }
}
