//
//  ActionTVCell.swift
//  Roommate
//
//  Created by TrinhHC on 11/8/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class ActionTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvRight: UIImageView!
    
    var title:String?{
        didSet{
            lblTitle.text = title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvRight.image = UIImage(named: "right-arrow")
    }
    
}
