//
//  TableView.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewPresentable {
    var tableView_bg: UIColor{get}
    var tableView_bgHeader: UIColor{get}
    var tableView_heightForCell: CGFloat{get}
}
