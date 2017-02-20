//
//  CustomWebViewModel.swift
//  Media
//
//  Created by Nguyen Van Tu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class CustomWebViewModel {
    var urls = [Track]()
    
    func addURL(urlString: String)
    {
        let track = Track(name: urlString, type: nil, previewUrl: urlString)
        urls.append(track)
    }
}
