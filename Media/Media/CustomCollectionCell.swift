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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
