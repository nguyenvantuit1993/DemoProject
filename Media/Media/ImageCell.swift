//
//  ItemCell.swift
//  iHotel
//
//  Created by DangCan on 1/19/16.
//  Copyright © 2016 DangCan. All rights reserved.
//

import UIKit
class ImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var kCellWidth: CGFloat = 50
    var kCellHeight: CGFloat = 50
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addSubviews() {
        if (imageView == nil) {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kCellWidth, height: kCellHeight))
            imageView.layer.borderColor = tintColor.cgColor
            imageView.contentMode = .scaleToFill
            contentView.addSubview(imageView)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
}
