//
//  Item.swift
//  Media
//
//  Created by Tuuu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
struct Item {
    private var name: String!
    private var filePath: URL!
    private var thumbPath: URL!
    private var thumbName: String!
    private var type = MimeTypes.Other
    init() {
        self.init(name: nil, filePath: nil, type: MimeTypes.Other)
    }
    init(name: String?, filePath: URL?, type: MimeTypes) {
        self.init(name: name, filePath: filePath, thumbPath: nil, thumbName: nil, type: type)
    }
    init(name: String?, filePath: URL?, thumbName: String?, type: MimeTypes)
    {
        self.init(name: name, filePath: filePath, thumbPath: nil, thumbName: thumbName, type: type)
    }
    init(name: String?, filePath: URL?, thumbPath: URL?, type: MimeTypes) {
        self.init(name: name, filePath: filePath, thumbPath: thumbPath, thumbName: nil, type: type)
    }
    init(name: String?, filePath: URL?, thumbPath: URL?, thumbName: String?, type: MimeTypes) {
        self.name = name
        self.filePath = filePath
        self.thumbPath = thumbPath
        self.thumbName = thumbName
        self.type = type
    }
    func getFilePath() -> URL
    {
        return self.filePath
    }
    func getType() -> MimeTypes
    {
        return self.type
    }
    func getNameToShow() -> String
    {
        return self.name
    }
    func getImageToView() -> Data
    {
        var filePath: URL!
        switch type {
        case .Image:
            filePath = self.filePath
            break
        case .Video:
            filePath = self.thumbPath
            break
        default :
            filePath = nil
            break
        }
        
        return try! filePath == nil ? UIImagePNGRepresentation(UIImage(named: self.thumbName)!)! : Data(contentsOf:filePath)
    }
}
