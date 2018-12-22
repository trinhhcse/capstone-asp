//
//  UploadImageView.swift
//  Roommate
//
//  Created by TrinhHC on 10/28/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol UploadImageViewDelegate :class{
    func uploadImageViewDelegate(uploadImageView view:UploadImageView,onClickBtnSelectImage button:UIButton)
    func uploadImageViewDelegate(uploadImageView view:UploadImageView,removeCellAtIndextPath indexPath:IndexPath?)
}
extension UploadImageViewDelegate{
    func uploadImageViewDelegate(uploadImageView view:UploadImageView,removeCellAtIndextPath indexPath:IndexPath){}
}
class UploadImageView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,ImageCVCellDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var collectionView: BaseVerticalCollectionView!
    weak var delegate:UploadImageViewDelegate?
    var images:[UploadImageModel]?{
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
        collectionView.register(UINib(nibName: Constants.CELL_IMAGECV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_IMAGECV)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        lblTitle.font = .smallTitle
        lblTitle.text = "ROOM_UPLOAD_IMAGE_TITLE".localized
        lblDesription.font = .small
        lblDesription.text  = "ROOM_UPLOAD_LIMIT".localized
        lblDesription.textColor = .red
        
        btnSelectImage.setTitle("ROOM_UPLOAD_SELECT_IMAGE".localized, for: .normal)
        btnSelectImage.backgroundColor = .defaultBlue
        btnSelectImage.tintColor = .white
        btnSelectImage.layer.cornerRadius = 10
        btnSelectImage.clipsToBounds = true
    }
    
    //MARK: UICollectionView DataSourse and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_IMAGECV, for: indexPath) as! ImageCVCell
        cell.imageCVCellType = .upload
        cell.uploadImageModel = images?[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3-10, height: frame.width/3-10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //MARK: ImageCVCellDelegate
    func imageCVCellDelegate(imageViewCell cell: ImageCVCell, onClickRemoveImageView imageView: UIImageView, atIndexPath indexPath: IndexPath?) {
        delegate?.uploadImageViewDelegate(uploadImageView: self, removeCellAtIndextPath: indexPath)
    }
    
    @IBAction func onClickBtnSelectImage(_ sender: UIButton) {
        delegate?.uploadImageViewDelegate(uploadImageView: self, onClickBtnSelectImage: sender)
    }
    func reloadData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
