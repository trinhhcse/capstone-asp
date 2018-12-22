//
//  PopupSelectListCell.swift
//  UIAlertControllerExample
//
//  Created by TrinhHC on 6/3/18.
//  Copyright © 2018 UIAlertControllerExample. All rights reserved.
//

import UIKit

class PopupSelectListTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
