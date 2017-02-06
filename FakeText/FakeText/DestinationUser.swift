//
//  DestinationUser.swift
//  FakeText
//
//  Created by Tuuu on 2/6/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class DestinationUser: UIView
{
    
    @IBOutlet weak var lbl_To: UILabel!
    @IBOutlet weak var lbl_Users: UILabel!
    @IBOutlet weak var btn_Add: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_Add.addTarget(self, action: #selector(addUserToList), for: .touchUpInside)
    }
    func addUserToList() {
        
    }
}
