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
    func copyFile(paths: [String], toPath: String)
    {
        for path in paths
        {
            NVT_FileManager.copyFolderAt(path: path, toPath: toPath)
        }
    }
    func moveFile(paths: [String], toPath: String)
    {
        for path in paths
        {
            NVT_FileManager.moveFolderAt(path: path, toPath: toPath)
        }
    }
    func renameFile(path: String, newName: String)
    {
        NVT_FileManager.renameFolderAt(path: path as NSString, withName: newName)
    }
    func deleteFile(paths: [String])
    {
        for path in paths
        {
            NVT_FileManager.removeFolderAt(path: path)
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
    func getSourcePathValid(atIndex index: Int, isFilter: Bool) -> URL? {
        let url = getSourcePath(atIndex: index, isFilter: isFilter)
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
    func getListFiles(folderPath: URL) -> [URL]
    {
        var directoryContents = [URL]()
        do {
            // Get the directory contents urls (including subfolders urls)
            directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: [])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return directoryContents
    }
    func getListFiles(folderPath: URL, type: MimeTypes)
    {
        self.folderPath = folderPath
        self.type = type
        items.append(contentsOf: addItemToShow(urls:removeNamesInCorrectFormat(withURLs: self.getListFiles(folderPath: folderPath))))
    }
    
    private func removeNamesInCorrectFormat(withURLs URLs:[URL]) -> [URL]
    {
        let hiddenFiles = [kVideoFolder, kImageFolder, kOtherFolder, kUserFolders, kVideoThumbs, kBunchFolder, ".DS_Store"]
        var currentURLs = URLs
        for url in URLs
        {
            if (hiddenFiles.contains(url.lastPathComponent))
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
            case .Other:
                item = Item(name: name, filePath: url, thumbName: nameUnKnown(extention: url.pathExtension), type: type)
                break
            default:
                item = Item(name: name, filePath: url, thumbName: kFolderIcon, type: type)
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
    func saveMediaToCameraRoll(atIndex: Int, isFilter: Bool)
    {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.getSourcePath(atIndex: atIndex, isFilter: isFilter))
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
        
    }
    func getIndexWithName(name: String, items: [Item]) -> Int
    {
        for (index, item) in items.enumerated()
        {
            if(item.getNameToShow() == name)
            {
                return index
            }
        }
        return 0
    }
    func getSourcePath(atIndex index: Int, isFilter: Bool) -> URL
    {
        return isFilter == true ? self.filteredItems[index].getFilePath() : self.items[index].getFilePath()
    }
    
    func getNameItem(atIndex index: Int, isFilter: Bool) -> String
    {
        return isFilter == true ? self.filteredItems[index].getNameToShow() : self.items[index].getNameToShow()
    }
    func getMedia(withIndex index: Int, isFilter: Bool) -> Data?
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
    func getListItemsAt(path: URL) -> [Item]
    {
        return self.addItemToShow(urls: self.getListFiles(folderPath: path))
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
