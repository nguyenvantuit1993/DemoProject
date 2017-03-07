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
        isImageView = .Image
    }
    override init(withFolderPath folderPath: URL) {
        super.init(withFolderPath: folderPath)
        isImageView = .Image
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
    private var filteredItems:[Item]!
    let videoExtentions = ["flv", "mp4", "m3u8", "ts", "3gp", "mov", "avi", "wmv"]
    let imageExtentions = ["gif", "ico", "jpg", "svg", "tif", "webp"]
    var isImageView = MimeTypes.Image
    var folderPath: URL!
    init() {
    }
    init(withFolderPath folderPath: URL) {
        self.folderPath = folderPath
    }
    func filterContentForSearchText(searchText: String, complete: ()->()) {
        filteredItems = items.filter({( candy : Item) -> Bool in
            return candy.name.lowercased().contains(searchText.lowercased())
        })
        complete()
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
            
            switch isImageView {
            case .Image:
                item = Item(name: name, filePath: url)
                break
            case .Video:
                let thumbPath = ("\(self.folderPath.absoluteString)/\(kVideoThumbs)/\(name).png")
                print(thumbPath)
                item = Item(name: name, filePath: url, thumbPath: URL(fileURLWithPath: thumbPath))
                break
            default:
                item = Item(name: name, filePath: url, thumbName: nameUnKnown(extention: url.pathExtension))
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
        
        
    }
    func getSourcePath(atIndex index: Int) -> URL
    {
        return self.items[index].filePath
    }
    func getNameFilteredItem(atIndex index: Int) -> String
    {
        return self.filteredItems[index].name
    }

    func getNameItem(atIndex index: Int) -> String
    {
        return self.items[index].name
    }
    func getMedia(withIndex index: Int, isFilter: Bool) -> Data
    {
        var filePath: URL!
        switch isImageView {
        case .Image:
            filePath = items[index].filePath
            break
        case .Video:
            filePath = isFilter == true ? filteredItems[index].thumbPath:items[index].thumbPath
            break
        default :
            filePath = nil
            break
        }
        
        return try! filePath == nil ? UIImagePNGRepresentation(UIImage(named: isFilter == true ? filteredItems[index].thumbName:items[index].thumbName)!)! : Data(contentsOf:filePath)
    }
    func getItems() -> [Item]
    {
        return self.items
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
