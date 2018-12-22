//
//  FeedbackVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
class ImagesVC: BaseVC{
    
    var imageUrls:[String]?
    var indexPath:IndexPath?
    @IBOutlet weak var imgvCancel: UIImageView!
    @IBOutlet weak var imagesView: HorizontalImagesView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesView.images = imageUrls
        imagesView.horizontalImagesViewType = .full
        imgvCancel.image = UIImage(named: "cancel")
        imgvCancel.contentMode = .scaleToFill
//        imgvCancel.layer.zPosition = 1
        imgvCancel.isUserInteractionEnabled = true
        
        
        imgvCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCancel)))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.view.bringSubview(toFront: self.imgvCancel)
            self.view.sendSubview(toBack: self.imagesView)
            self.imagesView.collectionView.selectItem(at: self.indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    @objc func onClickCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
