//
//  RateCVCell.swift
//  Roommate
//
//  Created by TrinhHC on 11/28/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import SDWebImage
class RateCVCell: UICollectionViewCell {
    @IBOutlet weak var imgvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRateLeft: UILabel!
    @IBOutlet weak var lblRateRight: UILabel!
    @IBOutlet weak var lblRateCenter: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    var textColor = UIColor.defaultPink
    var textFont = UIFont.small
    var roomRateResponseModel:RoomRateResponseModel?{
        didSet{
            let defaultSize = CGSize(width: self.frame.width, height: .infinity)
            lblRateLeft.addAttributeString(string: String(format: "RATE_ROOM_SECURITY_VALUE".localized, roomRateResponseModel!.securityRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblRateCenter.addAttributeString(string: String(format: "RATE_ROOM_LOCATION_VALUE".localized, roomRateResponseModel!.locationRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblRateRight.addAttributeString(string:String(format: "RATE_ROOM_UTILITY_VALUE".localized, roomRateResponseModel!.utilityRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblTitle.text = roomRateResponseModel?.username
            tvComment.text = roomRateResponseModel?.comment
            lblDate.text = roomRateResponseModel?.date?.string(Constants.SHOW_DATE_FORMAT)
            sd_showActivityIndicatorView()
            sd_setIndicatorStyle(.gray)
            imgvIcon.sd_setImage(with: URL(string: roomRateResponseModel?.imageProfile ?? ""), placeholderImage: UIImage(named: "default_load_room"), options: [.continueInBackground,.retryFailed]) { [weak self] (image, error, cacheType, url) in
                guard let _ = error else{
                    return
                }
                DispatchQueue.main.async {
                    self?.imgvIcon.image = image
                }
            }
        }
    }
    var userRateResponseModel:UserRateResponseModel?{
        didSet{
            let defaultSize = CGSize(width: self.frame.width, height: .infinity)
            lblRateLeft.addAttributeString(string: String(format: "RATE_MEMBER_BEHAVIOR_VALUE".localized, userRateResponseModel!.behaviourRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblRateCenter.addAttributeString(string: String(format: "RATE_MEMBER_LIFESTYLE_VALUE".localized, userRateResponseModel!.lifeStyleRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblRateRight.addAttributeString(string:String(format: "RATE_MEMBER_PAYMENT_VALUE".localized, userRateResponseModel!.paymentRate!), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
            lblTitle.text = userRateResponseModel?.username
            tvComment.text = userRateResponseModel?.comment
            lblDate.text = userRateResponseModel?.date?.string(Constants.SHOW_DATE_FORMAT)
            
            sd_showActivityIndicatorView()
            sd_setIndicatorStyle(.gray)
            imgvIcon.sd_setImage(with: URL(string: userRateResponseModel?.imageProfile ?? ""), placeholderImage: UIImage(named: "default_load_room"), options: [.continueInBackground,.retryFailed]) { [weak self] (image, error, cacheType, url) in
                guard let _ = error else{
                    return
                }
                DispatchQueue.main.async {
                    self?.imgvIcon.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = .medium
        lblTitle.textColor = .red
        lblDate.textAlignment = .right
        lblDate.textColor = .lightGray
        tvComment.font = .small
        tvComment.layer.borderWidth = 0
        tvComment.isEditable = false
        tvComment.isScrollEnabled = false
        
        imgvIcon.layer.cornerRadius = imgvIcon.frame.height/2
        imgvIcon.clipsToBounds = true
        
        addBorder(side: .Bottom, color: .lightGray, width: 0.5)
    }

}
