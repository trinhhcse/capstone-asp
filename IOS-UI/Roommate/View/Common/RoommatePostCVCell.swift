//
//  NewRoommateCVCell.swift
//  Roommate
//
//  Created by TrinhHC on 10/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol RoommateCVCellDelegate:class{
    func roommateCVCellDelegate(roommateCVCell cell:RoommatePostCVCell,onClickUIImageView imgvBookmark:UIImageView,atIndextPath indexPath:IndexPath?);
}
class RoommatePostCVCell: UICollectionViewCell {
    @IBOutlet weak var imgvLeftAvatar: UIImageView!
    @IBOutlet weak var imgvLeftBookmark: UIImageView!
    @IBOutlet weak var lblRightName: UILabel!
    @IBOutlet weak var lblRightPrice: UILabel!
    @IBOutlet weak var tvRightPriceValue: UITextView!
    @IBOutlet weak var lblRightDistricts: UILabel!
    @IBOutlet weak var tvRightDistrictsValue: UITextView!
    @IBOutlet weak var lblRightCity: UILabel!
    @IBOutlet weak var tvRightCityValue: UITextView!
    var delegate:RoommateCVCellDelegate?
    var roommate:RoommatePostResponseModel?{
        didSet{
            self.imgvLeftAvatar.sd_setImage(with: URL(string: roommate?.userResponseModel?.imageProfile ?? ""), placeholderImage: UIImage(named:"default_load_room"), options: [.continueInBackground,.retryFailed]) { (image, error, cacheType, url) in
                guard let image = image else{
                    return
                }
                DispatchQueue.main.async {
                    self.imgvLeftAvatar.image = image
                }
            }
            
            self.lblRightName.text = roommate?.userResponseModel?.fullname
            self.lblRightPrice.text = "ROMMATE_RIGHT_PRICE".localized
            self.tvRightPriceValue.text = "\(roommate!.minPrice.formatString)vnd - \(roommate!.maxPrice.formatString)vnd"
            self.lblRightDistricts.text = "ROMMATE_RIGHT_POSITION".localized
            let dictrictsString = roommate?.districtIds?.map({ (districtId) -> String in
                (DBManager.shared.getRecord(id: districtId, ofType: DistrictModel.self)?.name)!
            })
            self.tvRightDistrictsValue.text = dictrictsString?.joined(separator: ",")
            self.lblRightCity.text = "ROMMATE_RIGHT_CITY".localized
            self.tvRightCityValue.text = DBManager.shared.getRecord(id: (roommate?.cityId)!, ofType: CityModel.self)?.name
            self.imgvLeftBookmark.image = (roommate?.isFavourite)! ? UIImage(named: "bookmarked"):UIImage(named: "bookmark-black")
            
            
            
        }
    }
    var indexPath:IndexPath?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickImgvBookmark(geture:)))
        imgvLeftBookmark.addGestureRecognizer(tap)
        imgvLeftBookmark.contentMode = .scaleAspectFill
        imgvLeftBookmark.isUserInteractionEnabled = true
        imgvLeftBookmark.clipsToBounds = true
        
        imgvLeftAvatar.contentMode = .scaleAspectFill
        imgvLeftAvatar.clipsToBounds = true
        imgvLeftAvatar.layer.cornerRadius = imgvLeftAvatar.frame.width/2
        
        lblRightName.font = UIFont.boldSystemFont(ofSize:.medium)
        lblRightPrice.font = UIFont.systemFont(ofSize: .small)
        lblRightDistricts.font = UIFont.systemFont(ofSize: .small)
        lblRightCity.font = UIFont.systemFont(ofSize: .small)
        
        tvRightDistrictsValue.font = UIFont.boldSystemFont(ofSize: .small)
        tvRightCityValue.font = UIFont.boldSystemFont(ofSize: .small)
        tvRightPriceValue.font = UIFont.boldSystemFont(ofSize: .small)
        
        
        tvRightPriceValue.isEditable = false
        tvRightDistrictsValue.isEditable = false
        tvRightCityValue.isEditable = false
        
        tvRightPriceValue.isUserInteractionEnabled = false
        tvRightDistrictsValue.isUserInteractionEnabled = false
        tvRightCityValue.isUserInteractionEnabled = false
        
        tvRightPriceValue.isScrollEnabled = false
        tvRightDistrictsValue.isScrollEnabled = false
        tvRightCityValue.isScrollEnabled = false
        
        tvRightPriceValue.textContainerInset = .zero
        tvRightDistrictsValue.textContainerInset = .zero
        tvRightCityValue.textContainerInset = .zero
        
        tvRightPriceValue.textContainer.lineBreakMode = .byWordWrapping
        tvRightDistrictsValue.textContainer.lineBreakMode = .byWordWrapping
        tvRightCityValue.textContainer.lineBreakMode = .byWordWrapping
        
        tvRightPriceValue.textColor = .defaultBlue
        tvRightDistrictsValue.textColor = .defaultPink
        tvRightCityValue.textColor = .defaultPurple
        
        addBorder(side: BorderSide.Bottom, color: .lightGray, width: 0.5)
        
    }
    
    func setBookMark(isBookMark:Bool){
        imgvLeftBookmark.image = isBookMark ? UIImage(named: "bookmarked") : UIImage(named: "bookmark-black")
    }
    
    @objc func onClickImgvBookmark(geture:UITapGestureRecognizer) {
        delegate?.roommateCVCellDelegate(roommateCVCell: self, onClickUIImageView: imgvLeftBookmark, atIndextPath: indexPath)
        
    }
}
