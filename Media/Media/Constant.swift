//
//  Constant.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first 
let kVideoFolder = "Videos"
let kVideoThumbs = "VideoThumbs"
let kImageFolder = "Images"
let kOtherFolder = "Others"
let kUserFolders = "UserFolders"
let kHtmlPath = "http"
let kBunchFolder = "BunchFiles"
let kFolderIcon = "Folder"
let kGoogleSearchLink = "http://www.google.com/search?q="
enum MimeTypes: Int {
    case Image = 1
    case Video
    case Folder
    case Other
}
enum CompassPoint: Int {
    case north = 1
    case south
    case east
    case west
}

