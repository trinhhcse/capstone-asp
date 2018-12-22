//
//  RoomCVCell.swift
//  Roommate
//
//  Created by TrinhHC on 10/17/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SDWebImage
protocol RoomCVCellDelegate:class {
    func roomCVCellDelegate(roomCVCell cell:RoomPostCVCell,onClickUIImageView imgvBookmark:UIImageView,atIndextPath indexPath:IndexPath?)
}
class RoomPostCVCell: UICollectionViewCell {
    @IBOutlet weak var imgvBookMark: UIImageView!
    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var tvNumberOfPatner: UITextView!
    @IBOutlet weak var tvName: UITextView!
    @IBOutlet weak var tvPrice: UITextView!
    @IBOutlet weak var tvAddress: UITextView!
    var delegate:RoomCVCellDelegate?
    var room:RoomPostResponseModel?{
        didSet{
            imgvAvatar.sd_setImage(with: URL(string: room?.imageUrls?.first ?? ""), placeholderImage: UIImage(named:"default_load_room"), options: [.continueInBackground,.retryFailed]) { (image, error, cacheType, url) in
                guard let image = image else{
                    return
                }
                DispatchQueue.main.async {
                    self.imgvAvatar.image = image
                }
            }
            guard let favorite = room?.isFavourite ,let genderOfPatner = room?.genderPartner,let numberOfPatner = room?.numberPartner,let name = room?.name,let price = room?.minPrice,let address = room?.address else {
                return
            }
            imgvBookMark.image = favorite ? UIImage(named: "bookmarked") : UIImage(named: "bookmark")
            tvNumberOfPatner.text = genderOfPatner == 1 ? String(format: "NUMBER_OF_PERSON".localized,numberOfPatner,"MALE".localized) :
                genderOfPatner == 2 ? String(format: "NUMBER_OF_PERSON".localized,numberOfPatner,"FEMALE".localized) : String(format: "NUMBER_OF_PERSON".localized,numberOfPatner,"\("MALE".localized)/\("FEMALE".localized)")
            tvName.text = name
//           print(tvPrice.frame)
//            print(tvPrice.contentInset)
//            print(tvPrice.conte)
//            tvPrice.contentOffset = CGPoint(x: 0, y: -tvPrice.contentInset.top)
            tvPrice.text = String(format: "PRICE_OF_ROOM".localized,price.formatString,"PERSON".localized)
            tvAddress.text = address
        }
    }
    var indexPath:IndexPath?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvAvatar.layer.cornerRadius = 10
        imgvAvatar.clipsToBounds  = true
        
        imgvBookMark.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickImgvBookmark))
        imgvBookMark.addGestureRecognizer(tap)
        
        tvNumberOfPatner.isEditable = false
        tvName.isEditable = false
        tvPrice.isEditable = false
        tvAddress.isEditable = false
        
        tvNumberOfPatner.isScrollEnabled = false
        tvName.isScrollEnabled = false
        tvPrice.isScrollEnabled = false
        tvAddress.isScrollEnabled = false
        
        tvNumberOfPatner.isUserInteractionEnabled = false
        tvName.isUserInteractionEnabled = false
        tvPrice.isUserInteractionEnabled = false
        tvAddress.isUserInteractionEnabled = false
        
        tvNumberOfPatner.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tvName.textContainerInset = .zero
        tvPrice.textContainerInset = .zero
        tvAddress.textContainerInset = .zero
        
        
        tvNumberOfPatner.font = .verySmall
        tvName.font = .medium
        tvPrice.font = .small
        tvAddress.font = .small
        
        tvNumberOfPatner.textContainer.lineBreakMode = .byWordWrapping
        tvName.textContainer.lineBreakMode = .byWordWrapping
        tvPrice.textContainer.lineBreakMode = .byWordWrapping
        tvAddress.textContainer.lineBreakMode = .byWordWrapping
        
        tvPrice.textColor = .defaultBlue
        tvNumberOfPatner.textColor = .lightGray
        tvAddress.textColor = .defaultPink

        self.bringSubview(toFront: imgvBookMark)
//        self.subviews[1].removeFromSuperview()
    }
    
    func setBookMark(isBookMark:Bool){
        imgvBookMark.image = isBookMark ? UIImage(named: "bookmarked") : UIImage(named: "bookmark")
    }
    //MARK: Event for UI
    @objc func onClickImgvBookmark() {
        delegate?.roomCVCellDelegate(roomCVCell: self, onClickUIImageView: imgvBookMark,atIndextPath: indexPath)
        
    }
    
}
