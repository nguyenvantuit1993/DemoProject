//
//  CustomCollectionCell.swift
//  Media
//
//  Created by Tuuu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class CustomCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var playView: UIImageView!
    @IBOutlet weak var btn_Select: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                btn_Select.setImage(UIImage(named: "Select"), for: .normal)
            } else {
                btn_Select.setImage(UIImage(named: "UnSelect"), for: .normal)
            }
        }
    }
}
