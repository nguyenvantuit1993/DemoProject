//
//  BookMarkCell.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/23/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class BookMarkCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_URL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
