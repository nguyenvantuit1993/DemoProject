//
//  FileManager.swift
//  Media
//
//  Created by Tuuu on 3/18/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
let kFileEsxit = 516
protocol NVT_FileManagerDelegate {
    func showError(description: String)
    func didFinishAction()
}
class NVT_FileManager{
    var delegate: NVT_FileManagerDelegate!
    func copyFolderAt(at path: URL, toPath: URL)
    {
        do {
            try FileManager.default.copyItem(at: path, to: toPath)
        } catch let error as NSError {
            if(error.code == kFileEsxit)
            {
                let lastComponent = toPath.lastPathComponent.appending("_copy")
                self.copyFolderAt(at: path, toPath: toPath.deletingLastPathComponent().appendingPathComponent(lastComponent))
            }
            else
            {
                self.delegate.showError(description: error.localizedDescription)
            }
            self.delegate.didFinishAction()
        }
    }
    
    func removeFolderAt(at path: URL)
    {
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error as NSError {
            self.delegate.showError(description: error.localizedDescription)
        }
        self.delegate.didFinishAction()
    }
    func moveFolderAt(at path: URL, toPath: URL)
    {
        do {
            try FileManager.default.moveItem(at: path, to: toPath)
        } catch let error as NSError {
            if(error.code == kFileEsxit)
            {
                let lastComponent = toPath.lastPathComponent.appending("_copy")
                self.moveFolderAt(at: path, toPath: toPath.deletingLastPathComponent().appendingPathComponent(lastComponent))
            }
            else
            {
                self.delegate.showError(description: error.localizedDescription)
            }
        }
        self.delegate.didFinishAction()
    }
    func renameFolderAt(at path: URL, withName name: String)
    {
        
        var baseURL = path.deletingLastPathComponent()
        baseURL.appendPathComponent(name)
        do {
            try FileManager.default.moveItem(at: path, to: baseURL)
        } catch let error as NSError {
            self.delegate.showError(description: error.localizedDescription)
        }
        self.delegate.didFinishAction()
    }
    func createFolderWithPath(path: String)
    {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            self.delegate.showError(description: error.localizedDescription)
        }
    }
    func createDefaultFolders(baseURL: String)
    {
        let videoFolderPath = baseURL.appending("/\(kVideoFolder)")
        let userFolderPath = baseURL.appending("/\(kUserFolders)")
        let bunchFolderPath = baseURL.appending("/\(kBunchFolder)")
        let imageFolderPath = baseURL.appending("/\(kImageFolder)")
        let otherFolderPath = baseURL.appending("/\(kOtherFolder)")
        let thumbFolderPath = videoFolderPath.appending("/\(kVideoThumbs)")
        self.createFolderWithPath(path: userFolderPath)
        self.createFolderWithPath(path: bunchFolderPath)
        self.createFolderWithPath(path: videoFolderPath)
        self.createFolderWithPath(path: imageFolderPath)
        self.createFolderWithPath(path: thumbFolderPath)
        self.createFolderWithPath(path: otherFolderPath)
    }
}
