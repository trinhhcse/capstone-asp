//
//  ErrorView.swift
//  Roommate
//
//  Created by TrinhHC on 10/18/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet weak var imgvError: UIImageView!
    @IBOutlet weak var tvError: UITextView!
    var completed:(()->Void)?
    var title:String?{
        didSet{
            tvError.text  = title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tvError.font = .small
        tvError.textColor = .red
        tvError.isEditable = false
    }
}
