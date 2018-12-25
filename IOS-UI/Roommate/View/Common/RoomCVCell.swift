//
//  RoomForOwnerCVCellCollectionViewCell.swift
//  Roommate
//
//  Created by TrinhHC on 11/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class RoomCVCell: UICollectionViewCell {
    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var lblCurrentMember: UILabel!
    @IBOutlet weak var tvName: UITextView!
    @IBOutlet weak var tvPrice: UITextView!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var imgvStatus: UIImageView!
    
    var room: RoomMappableModel?{
        didSet{
            guard let room = room else {
                return
            }
            imgvAvatar.sd_setImage(with: URL(string: room.imageUrls.first ?? "default_load_room"), placeholderImage: UIImage(named:"default_load_room"), options: [.continueInBackground,.retryFailed]) { (image, error, cacheType, url) in
                guard let image = image else{
                    return
                }
                DispatchQueue.main.async {
                    self.imgvAvatar.image = image
                }
            }
            lblCurrentMember.text = String(format: "CURRENT_NUMBER_OF_PERSON".localized, room.members?.count ?? 0,room.maxGuest)
            imgvStatus.image = room.statusId == Constants.AUTHORIZED ? UIImage(named: "certificated") : UIImage(named: "certificate")
            tvName.text = room.name
            tvPrice.text = String(format: "PRICE_OF_ROOM".localized,room.price.formatString,"MONTH".localized)
            tvAddress.text = room.address
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvAvatar.layer.cornerRadius = 10
        imgvAvatar.clipsToBounds  = true
        
        tvName.isEditable = false
        tvPrice.isEditable = false
        tvAddress.isEditable = false
        
        tvName.isScrollEnabled = false
        tvPrice.isScrollEnabled = false
        tvAddress.isScrollEnabled = false
        
        tvName.isUserInteractionEnabled = false
        tvPrice.isUserInteractionEnabled = false
        tvAddress.isUserInteractionEnabled = false
        
        tvName.textContainerInset = .zero
        tvPrice.textContainerInset = .zero
        tvAddress.textContainerInset = .zero
        
        
        lblCurrentMember.font = .verySmall
        tvName.font = .medium
        tvPrice.font = .small
        tvAddress.font = .small
        
        
        tvName.textContainer.lineBreakMode = .byWordWrapping
        tvPrice.textContainer.lineBreakMode = .byWordWrapping
        tvAddress.textContainer.lineBreakMode = .byWordWrapping
        
        tvPrice.textColor = .defaultBlue
        lblCurrentMember.textColor = .lightGray
        tvAddress.textColor = .defaultPink
        
    }
    
    
    
}
