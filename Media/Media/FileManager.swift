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
    
    class func copyFolderAt(path: String, toPath: String)
    {
        do {
            try FileManager.default.copyItem(atPath: path, toPath: toPath)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func removeFolderAt(path: String)
    {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    class func moveFolderAt(path: String, toPath: String)
    {
        do {
            try FileManager.default.moveItem(atPath: path, toPath: toPath)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    class func renameFolderAt(path: NSString, withName name: String)
    {
        let baseURL = path.deletingLastPathComponent.appending("/\(name)")
        do {
            try FileManager.default.moveItem(atPath: path as String, toPath: baseURL)
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
