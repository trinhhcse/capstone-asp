//
//  VerticalPostView.swift
//  Roommate
//
//  Created by TrinhHC on 10/23/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol VerticalCollectionViewDelegate:class {
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,collectionCell cell: UICollectionViewCell, onClickUIImageView: UIImageView, atIndexPath indexPath: IndexPath?)
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,collectionCell cell: UICollectionViewCell, didSelectCellAt indexPath: IndexPath?)
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,onClickButton button:UIButton)
}
extension VerticalCollectionViewDelegate{
    func verticalCollectionViewDelegate(verticalPostView view:VerticalCollectionView,collectionCell cell: UICollectionViewCell, onClickUIImageView: UIImageView, atIndexPath indexPath: IndexPath?){}
}
class VerticalCollectionView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,RoomCVCellDelegate,UICollectionViewDelegateFlowLayout,RoommateCVCellDelegate{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionView: BaseVerticalCollectionView!
    
    @IBOutlet weak var btnViewAllHeightConstraint: NSLayoutConstraint!
    weak var delegate:VerticalCollectionViewDelegate?
    var verticalCollectionViewType:VerticalCollectionViewType = .newRoomPost{
        didSet{
            switch verticalCollectionViewType {
                case .newRoomPost:
                    lblTitle.text = "TITLE_NEW_ROOM".localized
                case .newRoommatePost:
                    lblTitle.text = "TITLE_NEW_ROOMMATE".localized
                case .createdRoomOfOwner:
                    lblTitle.text = "TITLE_CREATED_ROOM".localized
//                case .currentRoomOfMember:
//                    lblTitle.text = "TITLE_CURRENT_MEMBER_ROOM".localized
//                case .historyRoomOfMember:
//                    lblTitle.text = "TITLE_HISTORY_MEMBER_ROOM".localized
//            case .createdRoomPostOfMember:
//                lblTitle.text = "TITLE_MEMBER_CREATED_ROOM_POST".localized
//            case .createdRoommatePostOfMember:
//                lblTitle.text = "TITLE_MEMBER_CREATED_ROOMMATE_POST".localized
                
            }
        }
    }
    
    var rooms:[RoomPostResponseModel] = []
    {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    var roommates:[RoommatePostResponseModel] = []
    {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var roomsOwner:[RoomMappableModel] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = .boldMedium
        lblTitle.textColor = .red
        btnViewAll.setTitle("TITLE_VIEW_ALL".localized, for: .normal)
        
        btnViewAll.setTitleColor(.white, for: .normal)
        btnViewAll.backgroundColor = .defaultBlue
        btnViewAll.layer.cornerRadius = 15
        btnViewAll.clipsToBounds = true
        
        collectionView.register(UINib(nibName: Constants.CELL_ROOMPOSTCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMPOSTCV)
        collectionView.register(UINib(nibName: Constants.CELL_ROOMMATEPOSTCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMMATEPOSTCV)
        collectionView.register(UINib(nibName: Constants.CELL_ROOMCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMCV)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        
    }
    //MARK: UICollectionView DataSourse and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if verticalCollectionViewType == .newRoomPost{
            return rooms.count
        }else if verticalCollectionViewType == .newRoommatePost{
            return roommates.count
        }else{
            return roomsOwner.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if verticalCollectionViewType == .newRoomPost{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMPOSTCV, for: indexPath) as! RoomPostCVCell
            cell.delegate  = self
            cell.room = rooms[indexPath.row]
            cell.indexPath = indexPath
            return cell
        }else if verticalCollectionViewType == .newRoommatePost{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMMATEPOSTCV, for: indexPath) as! RoommatePostCVCell
            cell.delegate  = self
            cell.roommate = roommates[indexPath.row]
            cell.indexPath = indexPath
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMCV, for: indexPath) as! RoomCVCell
            cell.room = roomsOwner[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if verticalCollectionViewType == .newRoomPost{
            return CGSize(width: collectionView.frame.width/2-5, height: Constants.HEIGHT_CELL_ROOMPOSTCV)
        }else if verticalCollectionViewType == .newRoommatePost{
            return CGSize(width: collectionView.frame.width, height: Constants.HEIGHT_CELL_ROOMMATEPOSTCV)
        }else{
            return CGSize(width: collectionView.frame.width, height: Constants.HEIGHT_CELL_ROOMFOROWNERCV)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if verticalCollectionViewType == .newRoomPost{
            let cell = collectionView.cellForItem(at: indexPath) as! RoomPostCVCell
            delegate?.verticalCollectionViewDelegate(verticalPostView:self,collectionCell: cell, didSelectCellAt: indexPath)
        }else if verticalCollectionViewType == .newRoommatePost{
            let cell = collectionView.cellForItem(at: indexPath) as! RoommatePostCVCell
            delegate?.verticalCollectionViewDelegate(verticalPostView:self,collectionCell: cell, didSelectCellAt: indexPath)
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! RoomCVCell
            delegate?.verticalCollectionViewDelegate(verticalPostView:self,collectionCell: cell, didSelectCellAt: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //dif row
        return 0
    }
    
    //MARK: NewRoomCVCellDelegate
    func roomCVCellDelegate(roomCVCell cell:RoomPostCVCell,onClickUIImageView imgvBookmark:UIImageView,atIndextPath indexPath:IndexPath?){
        delegate?.verticalCollectionViewDelegate(verticalPostView:self,collectionCell: cell, onClickUIImageView: imgvBookmark, atIndexPath: indexPath)
    }
    //MARK: NewRoommateCVCellDelegate
    func roommateCVCellDelegate(roommateCVCell cell: RoommatePostCVCell, onClickUIImageView imgvBookmark: UIImageView, atIndextPath indexPath: IndexPath?) {
        delegate?.verticalCollectionViewDelegate(verticalPostView:self,collectionCell: cell, onClickUIImageView: imgvBookmark, atIndexPath: indexPath)
    }
    @IBAction func onClickBtnViewAll(_ sender: UIButton) {
        delegate?.verticalCollectionViewDelegate(verticalPostView:self,onClickButton: sender)
    }
    
    //MARK: Others
    func hidebtnViewAllButton(){
        btnViewAllHeightConstraint.constant = 0
        //        btnViewAll.translatesAutoresizingMaskIntoConstraints  = false
        //        btnViewAll.heightAnchor.constraint(equalToConstant: 0).isActive = true
        layoutSubviews()
    }
    func showbtnViewAllButton(){
        //        btnViewAll.translatesAutoresizingMaskIntoConstraints  = false
        //        btnViewAll.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnViewAllHeightConstraint.constant = 40
        layoutSubviews()
    }
}
