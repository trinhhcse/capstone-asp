//
//  ImageCVCell.swift
//  Roommate
//
//  Created by TrinhHC on 10/1/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
protocol ImageCVCellDelegate:class{
    func imageCVCellDelegate(imageViewCell cell:ImageCVCell,onClickRemoveImageView imageView:UIImageView
        ,atIndexPath indexPath:IndexPath?)
}
class ImageCVCell:UICollectionViewCell {
    
    @IBOutlet weak var imgvRoom: UIImageView!
    @IBOutlet weak var imgvTrash: UIImageView!
    var indexPath:IndexPath?
    weak var delegate:ImageCVCellDelegate?
    var imageCVCellType:ImageCVCellType?{
        didSet{
            if imageCVCellType == .upload{
                imgvTrash.isHidden = false
                let tapReconizer = UITapGestureRecognizer(target: self, action: #selector(onClickImageView))
                imgvTrash.isUserInteractionEnabled = true
                imgvTrash.addGestureRecognizer(tapReconizer)
            }else if imageCVCellType == .full{
                imgvRoom.contentMode = .scaleAspectFit
            }
        }
    }
    var uploadImageModel:UploadImageModel?{
        didSet{
            if let image = uploadImageModel?.image{
                imgvRoom.image = image
            }else if let url = uploadImageModel?.linkUrl {
                sd_showActivityIndicatorView()
                sd_setIndicatorStyle(.gray)
                imgvRoom.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "default_load_room"), options: [.continueInBackground,.retryFailed]) { [weak self] (image, error, cacheType, url) in
                    guard let _ = error else{
                        return
                    }
                    self?.imgvRoom.image = image
                    self?.uploadImageModel?.image = image
                }
            }
        }
    }
    var link_url:String?{
        didSet{
            sd_showActivityIndicatorView()
            sd_setIndicatorStyle(.gray)
            imgvRoom.sd_setImage(with: URL(string: link_url!), placeholderImage: UIImage(named: "default_load_room"), options: [.continueInBackground,.retryFailed]) { [weak self] (image, error, cacheType, url) in
                guard let _ = error else{
                    return
                }
                self?.imgvRoom.image = image
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvTrash.isHidden = true
        imgvTrash.image = UIImage(named: "remove")
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    @objc func onClickImageView(){
        delegate?.imageCVCellDelegate(imageViewCell: self, onClickRemoveImageView: imgvTrash, atIndexPath: indexPath)
    }
}
