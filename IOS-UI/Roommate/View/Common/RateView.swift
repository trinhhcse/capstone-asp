//
//  RateView.swift
//  Roommate
//
//  Created by TrinhHC on 12/6/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol RateViewDelegate:class{
    func rateViewDelegate(rateView view:RateView,onClickButton button:UIButton)
    func rateViewDelegate(rateView view:RateView,didSelectRowAtIndexPath indexPath:IndexPath)
}
extension RateViewDelegate{
    func rateViewDelegate(rateView view:RateView,onClickButton button:UIButton){}
    func rateViewDelegate(rateView view:RateView,didSelectRowAtIndexPath indexPath:IndexPath){}
}
class RateView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vRateAvgContainer: UIView!
    @IBOutlet weak var btnTopRigh: UIButton!
    
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblRateLeft: UILabel!
    @IBOutlet weak var lblRateCenter: UILabel!
    @IBOutlet weak var lblRateRight: UILabel!
    @IBOutlet weak var collectionView: BaseVerticalCollectionView!
    @IBOutlet weak var vRateAvgContainerHeightConstraint: NSLayoutConstraint!
    var textColor = UIColor.defaultBlue
    var textFont = UIFont.smallTitle
    weak var delegate:RateViewDelegate?
    var rateViewType:RateViewType?{
        didSet{
            if rateViewType == .roomPost || rateViewType == .roomDetail{
                lblTitle.text = "RATE_ROOM_DETAIL".localized
                lblTitleDescription.text = "RATE_AVG".localized
            }else{
                lblTitle.text = "RATE_MEMBER_DETAIL".localized
                lblTitleDescription.text = "RATE_AVG".localized
            }
        }
    }
    
    var userResponseModel:UserResponseModel?{
        didSet{
            if ( userResponseModel?.userRateResponseModels?.count ?? 0) == 0{
                setupUIForNoData()
            }else{
                let defaultSize = CGSize(width: self.frame.width, height: .infinity)
                lblRateLeft.addAttributeString(string: String(format: "RATE_MEMBER_BEHAVIOR_VALUE".localized, userResponseModel!.avgBehaviourRate), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
                lblRateCenter.addAttributeString(string: String(format: "RATE_MEMBER_LIFESTYLE_VALUE".localized, userResponseModel!.avgLifeStyleRate), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                lblRateRight.addAttributeString(string:String(format: "RATE_MEMBER_PAYMENT_VALUE".localized, userResponseModel!.avgPaymentRate), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
                self.collectionView.reloadData()
            }
            
        }
    }
    var roomPostResponseModel:RoomPostResponseModel?{
        didSet{
            if (roomPostResponseModel?.roomRateResponseModels?.count ?? 0) == 0{
                setupUIForNoData()
            }else{
                let defaultSize = CGSize(width: self.frame.width, height: .infinity)
                lblRateLeft.addAttributeString(string: String(format: "RATE_ROOM_SECURITY_VALUE".localized, roomPostResponseModel!.avarageSecurity), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
                lblRateCenter.addAttributeString(string: String(format: "RATE_ROOM_LOCATION_VALUE".localized, roomPostResponseModel!.avarageLocation), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
                lblRateRight.addAttributeString(string:String(format: "RATE_ROOM_UTILITY_VALUE".localized, roomPostResponseModel!.avarageUtility), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                self.collectionView.reloadData()
            }
            
        }
    }
    var roommatePostResponseModel:RoommatePostResponseModel?{
        didSet{
            if (roommatePostResponseModel?.userResponseModel?.userRateResponseModels?.count ?? 0) == 0{
                setupUIForNoData()
            }else{
                
                let defaultSize = CGSize(width: self.frame.width, height: .infinity)
                lblRateLeft.addAttributeString(string: String(format: "RATE_MEMBER_BEHAVIOR_VALUE".localized, roommatePostResponseModel!.userResponseModel!.avgBehaviourRate), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                lblRateCenter.addAttributeString(string: String(format: "RATE_MEMBER_LIFESTYLE_VALUE".localized, roommatePostResponseModel!.userResponseModel!.avgLifeStyleRate), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                lblRateRight.addAttributeString(string:String(format: "RATE_MEMBER_PAYMENT_VALUE".localized, roommatePostResponseModel!.userResponseModel!.avgPaymentRate), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                self.collectionView.reloadData()
            }
        }
    }
    var roomMappableModel: RoomMappableModel?{
        didSet{
            if (roomMappableModel?.roomRateResponseModels?.count ?? 0) == 0{
                setupUIForNoData()
            }else{
                let defaultSize = CGSize(width: self.frame.width, height: .infinity)
                lblRateLeft.addAttributeString(string: String(format: "RATE_ROOM_SECURITY_VALUE".localized, roomMappableModel!.avarageSecurity), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                lblRateCenter.addAttributeString(string: String(format: "RATE_ROOM_LOCATION_VALUE".localized, roomMappableModel!.avarageLocation), withIcon: UIImage(named: "rate-star")!, textColor: textColor,textFont: textFont,size: defaultSize)
                lblRateRight.addAttributeString(string:String(format: "RATE_ROOM_UTILITY_VALUE".localized, roomMappableModel!.avarageUtility), withIcon: UIImage(named: "rate-star")!,textColor: textColor,textFont: textFont, size: defaultSize)
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.boldMedium
        lblTitle.textColor = .red
        lblTitleDescription.font = .smallTitle
        lblTitle.lineBreakMode = .byWordWrapping
        
        lblTitle.numberOfLines = 0
        lblRateLeft.font = .small
        lblRateCenter.font = .small
        lblRateRight.font = .small
        
        
        btnTopRigh.setTitleColor(.white, for: .normal)
        btnTopRigh.backgroundColor = .defaultBlue
        btnTopRigh.layer.cornerRadius = 15
        btnTopRigh.clipsToBounds = true
        collectionView.isScrollEnabled = false
        
        collectionView.register(UINib(nibName: Constants.CELL_RATECV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_RATECV)
        collectionView.delegate = self
        collectionView.dataSource = self
        lblTitleDescription.text = "RATE_EMPTY".localized
        btnTopRigh.setTitle("TITLE_VIEW_ALL".localized, for: .normal)
        
        collectionView.addBorder(side: .Top, color: .lightGray, width: 1.0)
        
    }
    //MARK: UICollectionVIewDelegate and DataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.rateViewDelegate(rateView: self, didSelectRowAtIndexPath: indexPath)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (rateViewType == .roomPost ? roomPostResponseModel?.roomRateResponseModels?.count : rateViewType == .roommatePost ? roommatePostResponseModel?.userResponseModel?.userRateResponseModels?.count : rateViewType == .roomDetail ? roomMappableModel?.roomRateResponseModels?.count : userResponseModel?.userRateResponseModels?.count) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: Constants.HEIGHT_CELL_RATECV)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CELL_RATECV, for: indexPath) as! RateCVCell
        switch rateViewType! {
        case .roomPost:
            cell.roomRateResponseModel = roomPostResponseModel?.roomRateResponseModels?[indexPath.row]
        case .roommatePost:
            cell.userRateResponseModel = roommatePostResponseModel?.userResponseModel?.userRateResponseModels?[indexPath.row]
        case .roomDetail:
            cell.roomRateResponseModel = roomMappableModel?.roomRateResponseModels?[indexPath.row]
        case .userDetail:
            cell.userRateResponseModel = userResponseModel?.userRateResponseModels?[indexPath.row]
        }
        return cell
    }
    //MARK: Event for controls
    @IBAction func onClickBtnTopRight(_ sender: Any) {
        delegate?.rateViewDelegate(rateView: self, onClickButton: btnTopRigh)
    }
    func setupUIForNoData(){
        vRateAvgContainer.translatesAutoresizingMaskIntoConstraints = false
        vRateAvgContainerHeightConstraint.constant = 0
        lblTitleDescription.text = "RATE_EMPTY".localized
        btnTopRigh.isHidden = true
    }
}
