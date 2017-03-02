//
//  CellItem.swift
//  MyPets
//
//  Created by NguyenDucBien on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class CellItem: UICollectionViewCell {

    var imageView: UIImageView!
    var sizeImageView = CGSize(width: 37.5, height: 30)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func addSubViews() {
        if (imageView == nil)
        {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeImageView.width, height: sizeImageView.height))
            imageView.layer.borderColor = tintColor.cgColor
            imageView.contentMode = .scaleAspectFit
            contentView.addSubview(imageView)
        }
    }
    
    override var isSelected: Bool {
        didSet{
            imageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }

}
