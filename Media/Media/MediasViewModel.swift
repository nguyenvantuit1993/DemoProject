//
//  MediasViewModel.swift
//  Media
//
//  Created by Tuuu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import AVKit
import Photos

class MediasViewModel: FileManagerMedia {
    override init()
    {
        super.init()
        isImageView = .Video
    }
    override init(withFolderPath folderPath: URL) {
        super.init(withFolderPath: folderPath)
        isImageView = .Video
        getListFiles()
    }
    override func saveMediaToCameraRoll(atIndex: Int) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.getSourcePath(atIndex: atIndex))
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
    }
    
}
