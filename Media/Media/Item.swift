//
//  Item.swift
//  Media
//
//  Created by Tuuu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
struct Item {
    var name: String!
    var filePath: URL!
    var thumbPath: URL!
    init() {
        self.init(name: nil, filePath: nil)
    }
    init(name: String?, filePath: URL?) {
        self.init(name: name, filePath: filePath, thumbPath: nil)
    }
    init(name: String?, filePath: URL?, thumbPath: URL?) {
        self.name = name
        self.filePath = filePath
        self.thumbPath = thumbPath
    }
}
