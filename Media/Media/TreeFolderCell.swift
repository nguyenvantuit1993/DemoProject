//
//  TreeFolderCell.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class TreeFolderCell: UITableViewCell {

    @IBOutlet weak var lbl_Content: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
