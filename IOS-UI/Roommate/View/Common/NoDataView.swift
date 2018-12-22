//
//  NoDataView.swift
//  Roommate
//
//  Created by TrinhHC on 11/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    var title:String?{
        didSet{
            lblTitle.text = title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = .boldSmall
        lblTitle.text = "NO_DATA".localized
    }

}
