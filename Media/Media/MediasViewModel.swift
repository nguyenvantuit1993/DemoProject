//
//  MediasViewModel.swift
//  Media
//
//  Created by Tuuu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class MediasViewModel: FileManagerMedia {
    override init()
    {
        super.init()
        isImageView = false
    }
    override init(withFolderPath folderPath: URL) {
        super.init(withFolderPath: folderPath)
        isImageView = false
        getListFiles()
    }
}
