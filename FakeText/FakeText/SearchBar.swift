//
//  SearchBar.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

protocol ActionHomeView{
    func didFilter()
}

protocol SearchBarPresentable {
    var searchBar_bgColor: UIColor{get}
    var searchBar_tintColor: UIColor{get}
}
