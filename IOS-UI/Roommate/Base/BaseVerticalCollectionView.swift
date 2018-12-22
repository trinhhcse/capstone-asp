//
//  CustomHorizontalCollectionView.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
class BaseVerticalCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    convenience init(){
        self.init(frame: .zero, collectionViewLayout: BaseVerticalCollectionViewFlowLayout())
        setupUI()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func setupUI(){
        setCollectionViewLayout(BaseVerticalCollectionViewFlowLayout(), animated: false)
//        showsVerticalScrollIndicator = false
//        showsHorizontalScrollIndicator = false
//        allowsMultipleSelection = false
//                alwaysBounceHorizontal  = true
//        isPagingEnabled = true
        backgroundColor = .white
        alwaysBounceVertical = true
    }
}
