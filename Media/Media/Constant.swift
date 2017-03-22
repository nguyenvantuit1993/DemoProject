//
//  Constant.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first 
let kVideoFolder = "NVT_Videos"
let kVideoThumbs = "NVT_VideoThumbs"
let kImageFolder = "NVT_Images"
let kOtherFolder = "NVT_Others"
let kUserFolders = "NVT_UserFolders"
let kBunchFolder = "NVT_BunchFiles"
let kHtmlPath = "http"
let kFolderIcon = "Folder"
let kGoogleSearchLink = "http://www.google.com/search?q="
enum MimeTypes: String {
    case Image
    case Video
    case Folder
    case Other
    case All
}

enum EditOptionsEnum
{
    case Move
    case Delete
    case Copy
    case Rename
}
