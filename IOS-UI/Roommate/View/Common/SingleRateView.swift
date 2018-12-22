//
//  SingleRateView.swift
//  Roommate
//
//  Created by TrinhHC on 12/2/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Cosmos
class SingleRateView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cvRate: CosmosView!
    var starSize:Double = 20.0{
        didSet{
            cvRate.settings.starSize = starSize
            cvRate.translatesAutoresizingMaskIntoConstraints = false
            cvRateWidthConstraint.constant = CGFloat(5*starSize)
        }
    }
    @IBOutlet weak var cvRateWidthConstraint: NSLayoutConstraint!
    var singleRateViewType:SingleRateViewType = .security{
        didSet{
            var text  = ""
            switch singleRateViewType{
                case .security:
                    text = "RATE_ROOM_SECURITY"
                case .location:
                    text = "RATE_ROOM_LOCATION"
                case .utility:
                    text = "RATE_ROOM_UTILITY"
                case .behavior:
                    text = "RATE_MEMBER_BEHAVIOR"
                case .lifestyle:
                    text = "RATE_MEMBER_LIFESTYLE"
                case .payment:
                    text = "RATE_MEMBER_PAYMENT"
            }
            lblTitle.text = text.localized
        }
    }
    var didFinishTouchingRateView: ((Double)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = .medium
        lblTitle.textColor = .red
        cvRate.settings.emptyBorderWidth = 1
        cvRate.settings.emptyBorderColor = .lightGray
        cvRate.settings.filledBorderWidth = 1
        cvRate.settings.filledBorderColor = .lightGray
        cvRate.settings.filledColor = UIColor(hexString: "f79f24")
        
    
        
        cvRate.settings.starMargin = 5.0
        cvRate.settings.totalStars = 5
        cvRate.rating = 0
        cvRate.settings.fillMode = .half
        cvRate.translatesAutoresizingMaskIntoConstraints = false
        cvRateWidthConstraint.constant = CGFloat(5*starSize)
//        cvRate.settings.emptyImage = UIImage(named: "empty-star")?.withRenderingMode(.alwaysOriginal)
//        cvRate.settings.filledImage = UIImage(named: "star")?
//            .withRenderingMode(.alwaysOriginal)
        
        cvRate.didFinishTouchingCosmos = {(rate) in
            self.didFinishTouchingRateView?(rate)
        }
        
        cvRate.settings.starSize = starSize
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        cvRate.settings.starSize = 20.0
    }
}
