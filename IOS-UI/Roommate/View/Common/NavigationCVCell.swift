//
//  UtilityCVCellCollectionViewCell.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class NavigationCVCell: UICollectionViewCell {

    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var imgvIcon: UIImageView!
    var data:[String]?{
        didSet{
            tvTitle.text = data![0].localized
            imgvIcon.image = UIImage(named: data![1])
        }
    }
    var indexPath:IndexPath?
    //storage property
    override func awakeFromNib() {
        super.awakeFromNib()
        tvTitle.font = .small
        tvTitle.isEditable = false
        tvTitle.isSelectable = false
        tvTitle.isScrollEnabled = false
        tvTitle.textContainerInset = .zero
        tvTitle.textContainer.lineBreakMode = .byWordWrapping
        tvTitle.textAlignment = .center
//        imgvIcon.layer.cornerRadius = imgvIcon.frame.width/2
//        imgvIcon.clipsToBounds = true
    }
}
