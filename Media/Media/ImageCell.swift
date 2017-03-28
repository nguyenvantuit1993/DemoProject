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
            self.center = CGPoint(x: self.center.x, y: self.center.y + 10)
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kCellWidth, height: kCellHeight))
            imageView.layer.borderColor = tintColor.cgColor
            imageView.contentMode = .scaleToFill
            contentView.addSubview(imageView)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if(isSelected)
            {
                UIView.animate(withDuration: 0.5, animations: { 
                    self.imageView.frame = CGRect(x: 0, y: -10, width: self.kCellWidth, height: self.kCellHeight + 10)
                })
            }
            else
            {
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.frame = CGRect(x: 0, y: 0, width: self.kCellWidth, height: self.kCellHeight)
                })
            }
//            imageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
}
