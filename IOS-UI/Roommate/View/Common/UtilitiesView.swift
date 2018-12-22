//
//  RoomUtilities.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
protocol UtilitiesViewDelegate:class{
    func utilitiesViewDelegate(utilitiesView view:UtilitiesView, didSelectUtilityAt indexPath:IndexPath)
}
class UtilitiesView : UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: BaseVerticalCollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var utilities:[UtilityMappableModel]?{
        didSet{
            collectionView.isUserInteractionEnabled = true
            collectionView.delegate = self
            collectionView.dataSource = self
            self.collectionView.reloadData()
        }
    }
    var utilitiesViewType:UtilitiesViewType = .normal{
        didSet{
            if utilitiesViewType == .required{
                let string = NSMutableAttributedString(string: "UTILITY_TITLE".localized)
                string.append(NSAttributedString(string: "UTILITY_TITLE_REQUIRED".localized, attributes: [NSAttributedStringKey.foregroundColor:UIColor.red]))
                lblTitle.attributedText = string
            }
        }
    }
    var selectedUtilities:[Int] = []
    
    weak var delegate:UtilitiesViewDelegate?
    
//    var utilityForSC:UtilityForSC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print("Init frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Init Coder")
    }
    
    override func awakeFromNib() {
//        print("awakeFromNib")
        collectionView.register(UINib(nibName: Constants.CELL_UTILITYCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_UTILITYCV)
        collectionView.allowsSelection = true
        lblTitle.text = "UTILITY_TITLE".localized
        lblTitle.font = .smallTitle
        layoutIfNeeded()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return utilities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_UTILITYCV, for: indexPath) as! UtilityCVCell
        let utility = utilities![indexPath.row]
        cell.data = utility
        if selectedUtilities.contains(utility.utilityId){
            cell.isSetSelected = true
        }else{
            cell.isSetSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.utilitiesViewDelegate(utilitiesView: self, didSelectUtilityAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("Size Of cell \(UIScreen.main.bounds.width/2-2*Constants.MARGIN_10-5.0)")
        return CGSize(width: UIScreen.main.bounds.width/2-Constants.MARGIN_10-2.5, height:CGFloat(Constants.HEIGHT_CELL_UTILITYCV-2.5))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5//Item in diffrence row
    }
    func setState(isSelected:Bool,atIndexPath indexPath:IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! UtilityCVCell
        cell.isSetSelected = isSelected
        
    }
    func resetView(){
        collectionView.reloadData()
    }
}
