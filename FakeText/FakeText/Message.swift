//
//  Message.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
struct Message {
    var name: String!
    var content: String!
    var date: Date!
    var profileImagePath: String!
    
    init()
    {
        
    }
    init(name: String, content: String, date: Date, profileImagePath: String) {
        self.name = name
        self.content = content
        self.date = date
        self.profileImagePath = profileImagePath
    }
}
