//
//  ImagesViewModel.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewModel {
    private var items:[URL]!
    
    init(withFolderPath folderPath: URL) {
        getListFiles(withFolderPath: folderPath)
    }
    private func getListFiles(withFolderPath folderPath: URL)
    {
        var directoryContents = [URL]()
        do {
            // Get the directory contents urls (including subfolders urls)
            directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: [])
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        items =  removeNamesInCorrectFormat(withURLs: directoryContents)
    }
    
    private func removeNamesInCorrectFormat(withURLs URLs:[URL]) -> [URL]
    {
        var currentURLs = URLs
        for (index, url) in URLs.enumerated()
        {
            if (url.pathExtension != "png" && url.pathExtension != "jpg")
            {
                currentURLs.remove(at: index)
            }
        }
        return currentURLs
    }
    
    func getImage(withIndex index: Int) -> UIImage
    {
        return getImage(withURL: items[index])
    }
    private func getImage(withURL Url: URL) -> UIImage
    {
        return try! UIImage(data: Data(contentsOf: Url))!
    }
    
    func count() -> Int
    {
        return items.count
    }
    
}
