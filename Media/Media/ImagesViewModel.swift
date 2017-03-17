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

class MediaViewModel: FileManagerMedia{
    override init()
    {
        super.init()
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
    private var items = [Item]()
    private var filteredItems:[Item]!
    let otherExtentions = ["doc", "docs", "txt", "pdf", "rtf", "ppt", "html", "htm", "xls", "xlsx", "xlc"]
    let videoExtentions = ["flv", "mp4", "m3u8", "ts", "3gp", "mov", "avi", "wmv"]
    let imageExtentions = ["gif", "ico", "jpg", "svg", "tif", "webp"]
    var type = MimeTypes.Image
    var folderPath: URL!
    init() {
    }
    
    init(withFolderPath folderPath: URL, type: MimeTypes) {
        self.folderPath = folderPath
        self.type = type
        
    }
    func getSourcePathValid(atIndex index: Int) -> URL? {
        let url = getSourcePath(atIndex: index)
        return validMimeFile(url: url)
    }
    func validMimeFile(url: URL) -> URL?
    {
        if(otherExtentions.contains(url.pathExtension))
        {
            return url
        }
        return nil
    }
    func filterContentForSearchText(searchText: String, complete: ()->()) {
        filteredItems = items.filter({( item : Item) -> Bool in
            return item.getNameToShow().lowercased().contains(searchText.lowercased())
        })
        complete()
    }
    func resetData()
    {
        self.items.removeAll()
    }
    func getListFiles(folderPath: URL, type: MimeTypes)
    {
        self.folderPath = folderPath
        self.type = type
        
        var directoryContents = [URL]()
        do {
            // Get the directory contents urls (including subfolders urls)
            directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: [])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        items.append(contentsOf: addItemToShow(urls:removeNamesInCorrectFormat(withURLs: directoryContents)))
    }
    
    private func removeNamesInCorrectFormat(withURLs URLs:[URL]) -> [URL]
    {
        let extentions = [".DS_Store", ""]
        var currentURLs = URLs
        for url in URLs
        {
            if (extentions.contains(url.pathExtension))
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
            
            switch type {
            case .Image:
                item = Item(name: name, filePath: url, type: type)
                break
            case .Video:
                let thumbPath = ("\(self.folderPath.absoluteString)/\(kVideoThumbs)/\(name).png")
                print(thumbPath)
                item = Item(name: name, filePath: url, thumbPath: URL(fileURLWithPath: thumbPath), type: type)
                break
            default:
                item = Item(name: name, filePath: url, thumbName: nameUnKnown(extention: url.pathExtension), type: type)
                break
            }
            items.append(item)
        }
        return items
    }
    func nameUnKnown(extention: String) -> String
    {
        var nameImage: String!
        switch extention {
        case "html", "htm":
            nameImage = "HTML"
        case "pdf":
            nameImage = "PDF"
        case "docs", "txt":
            nameImage = "TXT"
        default:
            nameImage = "UNKNOWN"
        }
        return nameImage
    }
    func saveMediaToCameraRoll(atIndex: Int)
    {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.getSourcePath(atIndex: atIndex))
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
        
    }
    func getSourcePath(atIndex index: Int) -> URL
    {
        return self.items[index].getFilePath()
    }
    func getNameFilteredItem(atIndex index: Int) -> String
    {
        return self.filteredItems[index].getNameToShow()
    }

    func getNameItem(atIndex index: Int, isFilter: Bool) -> String
    {
        return isFilter == true ? self.filteredItems[index].getNameToShow() : self.items[index].getNameToShow()
    }
    func getMedia(withIndex index: Int, isFilter: Bool) -> Data
    {
        var item: Item!
        if isFilter == true
        {
            item = self.filteredItems[index]
        }
        else
        {
            item = self.items[index]
        }
        return item.getImageToView()
    }
    func getItems(isFilter: Bool) -> [Item]
    {
        return isFilter == true ? self.filteredItems : self.items
    }
    func getTypeAt(index: Int) -> MimeTypes
    {
        return self.items[index].getType()
    }
    func count() -> Int
    {
        return self.items.count
    }
    func filteredCount() -> Int
    {
        return self.filteredItems.count
    }
    
}
