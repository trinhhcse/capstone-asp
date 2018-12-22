//
//  UtilityDetailView.swift
//  Roommate
//
//  Created by TrinhHC on 10/6/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class UtilityDetailView: UIView {

    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    var utilityModel: UtilityMappableModel?{
        didSet{
            guard let utilityModel = utilityModel else {
                return
            }
            lblBrand.text = String(key: "BRAND_TITLE", args: utilityModel.brand)
            lblQuantity.text = String(key: "QUANTITY_TITLE", args: utilityModel.quantity)
            tvDescription.text = String(key: "DESCRIPTION_PLACE_HOLDER".localized, args:  utilityModel.utilityDescription)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
