//
//  ImagesViewModel.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImagesViewModel: FileManagerMedia{
    override init()
    {
        super.init()
        isImageView = true
    }
    override init(withFolderPath folderPath: URL) {
        super.init(withFolderPath: folderPath)
        isImageView = true
        getListFiles()
    }
    override func saveMediaToCameraRoll(atIndex: Int) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: self.getSourcePath(atIndex: atIndex))
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
    }
    
}

class FileManagerMedia
{
    private var items:[Item]!
    let extentions = ["jpg", "png", "jpeg", "mp3", "mp4"]
    var isImageView: Bool!
    var folderPath: URL!
    init() {
    }
    init(withFolderPath folderPath: URL) {
        self.folderPath = folderPath
    }
    func getListFiles()
    {
        var directoryContents = [URL]()
        do {
            // Get the directory contents urls (including subfolders urls)
            directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: [])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        items = addItemToShow(urls:removeNamesInCorrectFormat(withURLs: directoryContents))
    }
    
    private func removeNamesInCorrectFormat(withURLs URLs:[URL]) -> [URL]
    {
        var currentURLs = URLs
        for url in URLs
        {
            if (!extentions.contains(url.pathExtension))
            {
                currentURLs.remove(at: currentURLs.index(of: url)!)
            }
            
        }
        return currentURLs
    }
    func addItemToShow(urls: [URL]) -> [Item]
    {
        var items = [Item]()
        for url in urls
        {
            let name = (url.lastPathComponent as NSString).deletingPathExtension
            var item = Item()
            if(isImageView == true)
            {
                item = Item(name: name, filePath: url)
            }
            else
            {
                let thumbPath = ("\(self.folderPath.absoluteString)/\(kVideoThumbs)/\(name).jpg")
                print(thumbPath)
                item = Item(name: name, filePath: url, thumbPath: URL(fileURLWithPath: thumbPath))
            }
            items.append(item)
        }
        return items
    }
    func saveMediaToCameraRoll(atIndex: Int)
    {
        

    }
    func getSourcePath(atIndex index: Int) -> URL
    {
        return self.items[index].filePath
    }
    func getNameItem(atIndex index: Int) -> String
    {
        return self.items[index].name
    }
    func getMedia(withIndex index: Int) -> Data
    {
        let filePath = isImageView == true ? items[index].filePath:items[index].thumbPath
        return try! Data(contentsOf:filePath!)
    }
    func count() -> Int
    {
        return self.items.count
    }
    
}
