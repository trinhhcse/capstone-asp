//
//  BaseHorizontalCollectionView.swift
//  Roommate
//
//  Created by TrinhHC on 10/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
class BaseHorizontalCollectionView: UICollectionView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    convenience init(){
        print("init BaseHorizontalCollectionView")
        self.init(frame: .zero, collectionViewLayout: BaseHorizontalCollectionViewFlowLayout())
        
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        print(" init frame BaseHorizontalCollectionView")
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func setupUI(){
        setCollectionViewLayout(BaseHorizontalCollectionViewFlowLayout(), animated: false)
//        showsVerticalScrollIndicator = false
//        showsHorizontalScrollIndicator = false
//        allowsMultipleSelection = false
//        bounces = false
        isPagingEnabled = true
        backgroundColor = .white
    }
}
