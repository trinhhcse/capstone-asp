//
//  AddressView.swift
//  Roommate
//
//  Created by TrinhHC on 10/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol BaseInformationViewDelegate:class {
    func baseInformationViewDelegate(baseInformationView:BaseInformationView,onClickBtnViewAll button:UIButton)
}
extension BaseInformationViewDelegate{
    func baseInformationViewDelegate(baseInformationView:BaseInformationView,onClickBtnViewAll button:UIButton){}
}
class BaseInformationView: UIView {
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgvtop: UIImageView!
    @IBOutlet weak var tvInfoTop: UITextView!
    @IBOutlet weak var imgvBottom: UIImageView!
    @IBOutlet weak var lblInfoBottom: UILabel!
    @IBOutlet weak var lblTitleDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMainTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnViewDetail: UIButton!
    var btnTitle:String?{
        didSet{
            _ = btnViewDetail.isHidden = false
            btnViewDetail.setTitle(btnTitle, for: .normal)
        }
    }
    weak var delegate:BaseInformationViewDelegate?
    var room:RoomMappableModel!{
        didSet{
            
            if viewType == .detailForOwner{
                self.lblMainTitle.text = room.name
                let status =  NSAttributedString(string: room.statusId == Constants.AUTHORIZED ?  "ROOM_DETAIL_STATUS_AUTHORIZED".localized : room.statusId == Constants.PENDING ? "ROOM_DETAIL_STATUS_PENDING".localized : "ROOM_DETAIL_STATUS_DECLINED".localized, attributes: [NSAttributedStringKey.font : UIFont.boldMedium,NSAttributedStringKey.backgroundColor: UIColor.defaultBlue,NSAttributedStringKey.foregroundColor:UIColor.white])
                self.lblSubTitle.text = "BASE_INFORMATION".localized
                self.lblTitleDescription.attributedText = status
            }else if viewType == .detailForMember || viewType == .currentDetailForMember{
                self.lblMainTitle.text = room.name
                self.lblSubTitle.text = "ROOM_BASE_INFORMATION".localized
                
            }else{
                //                self.lblMainTitle.text = "ROOM_BASE_INFORMATION".localized
                self.lblSubTitle.text = "ROOM_BASE_INFORMATION".localized
                
            }
            
            
            self.tvInfoTop.text = room.address
            self.lblInfoBottom.text = String(format: "AREA".localized,room.area)
        }
    }
    
    var roommatePost:RoommatePostResponseModel!{
        didSet{
            lblMainTitle.addAttributeString(string: roommatePost.userResponseModel?.fullname ?? "", withIcon: (roommatePost.userResponseModel?.gender == 2 ? UIImage(named: "female") : UIImage(named: "male"))!, size: CGSize(width: self.frame.width, height: .infinity))
            let dictrictsString = roommatePost.districtIds?.map({ (districtId) -> String in
                (DBManager.shared.getRecord(id: districtId, ofType: DistrictModel.self)?.name)!
            }).uniqueElements
            self.imgvBottom.image = UIImage(named: "city")
            self.lblSubTitle.text = "BASE_INFORMATION".localized
            self.tvInfoTop.text = dictrictsString?.joined(separator: ",")
            self.lblInfoBottom.text = DBManager.shared.getRecord(id: roommatePost.cityId, ofType: CityModel.self)!.name
        }
    }
    var roomPost:RoomPostResponseModel!{
        didSet{
            self.lblMainTitle.text = roomPost.name
            self.lblSubTitle.text = "ROOM_BASE_INFORMATION_FOR_POST".localized
            self.tvInfoTop.text = roomPost.address
            self.lblInfoBottom.text = String(format: "AREA".localized,roomPost.area!)
            self.lblTitleDescription.text  = String(format: "NUMBER_OF_PERSON".localized,roomPost.numberPartner!,(roomPost.genderPartner == 1 ? "MALE".localized : roomPost.genderPartner == 2 ? "FEMALE".localized : "\("MALE".localized)/\("FEMALE".localized)"))
            
        }
    }
    var viewType:ViewType?{
        didSet{
            if  viewType
                == .roomPostDetailForFinder || viewType == .detailForOwner || viewType == .roomPostDetailForCreatedUser{
                lblTitleDescription.textColor = .lightGray
            }else if viewType == .ceRoomPostForMaster{
                
                lblSubTitle.textColor = .red
                lblMainTitleHeightConstraint.constant = 0
                lblTitleDescriptionHeightConstraint.constant = 0
            }else{
                lblTitleDescriptionHeightConstraint.constant = 0
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMainTitle.font = .boldMedium
        lblMainTitle.textColor = .red
        lblTitleDescription.font = .smallTitle
        lblMainTitle.lineBreakMode = .byWordWrapping
        
        lblMainTitle.numberOfLines = 2
        lblSubTitle.font = .smallTitle
        tvInfoTop.font = .small
        lblInfoBottom.font = .small
        
        tvInfoTop.isEditable = false
        tvInfoTop.isUserInteractionEnabled = false
        tvInfoTop.textContainer.lineBreakMode = .byWordWrapping
        
        imgvtop.image = UIImage(named: "address")
        imgvBottom.image = UIImage(named: "area")
        
        btnViewDetail.setTitleColor(.white, for: .normal)
        btnViewDetail.backgroundColor = .defaultBlue
        btnViewDetail.layer.cornerRadius = 15
        btnViewDetail.clipsToBounds = true
        btnViewDetail.isHidden = true
        
    }
    @IBAction func onClickBtnViewDetail(_ sender: Any) {
        delegate?.baseInformationViewDelegate(baseInformationView: self, onClickBtnViewAll: btnViewDetail)
        
    }
}
