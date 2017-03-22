//
//  FileManager.swift
//  Media
//
//  Created by Tuuu on 3/18/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class NVT_FileManager{
    class func createFolderWithPath(path: String)
    {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func copyFolderAt(path: URL, toPath: URL)
    {
        do {
            try FileManager.default.copyItem(at: path, to: toPath)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func removeFolderAt(path: URL)
    {
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    class func moveFolderAt(atPath: URL, toPath: URL)
    {
        do {
            try FileManager.default.moveItem(at: atPath, to: toPath)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    class func renameFolderAt(path: URL, withName name: String)
    {
        
        var baseURL = path.deletingLastPathComponent()
        baseURL.appendPathComponent(name)
        do {
            try FileManager.default.moveItem(at: path, to: baseURL)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    class func createDefaultFolders(baseURL: String)
    {
        let videoFolderPath = baseURL.appending("/\(kVideoFolder)")
        let userFolderPath = baseURL.appending("/\(kUserFolders)")
        let bunchFolderPath = baseURL.appending("/\(kBunchFolder)")
        let imageFolderPath = baseURL.appending("/\(kImageFolder)")
        let otherFolderPath = baseURL.appending("/\(kOtherFolder)")
        let thumbFolderPath = videoFolderPath.appending("/\(kVideoThumbs)")
        NVT_FileManager.createFolderWithPath(path: userFolderPath)
        NVT_FileManager.createFolderWithPath(path: bunchFolderPath)
        NVT_FileManager.createFolderWithPath(path: videoFolderPath)
        NVT_FileManager.createFolderWithPath(path: imageFolderPath)
        NVT_FileManager.createFolderWithPath(path: thumbFolderPath)
        NVT_FileManager.createFolderWithPath(path: otherFolderPath)
    }
}