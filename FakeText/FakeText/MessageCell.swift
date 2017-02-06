//
//  MessageCell.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    var sName: String!
    var sContent: String!
    var sDate: Date!
    var sProfileImage: String!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
