//
//  CollectionViewCell.swift
//  ImageCache
//
//  Created by Akhadjon Abdukhalilov on 9/20/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    lazy var  photoImageView:UIImageView = {
         let imageView = UIImageView()
         imageView.clipsToBounds = true
         imageView.contentMode = .scaleToFill
         return imageView
     }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
 
}
