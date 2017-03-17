//
//  OtherFilesViewModel.swift
//  Media
//
//  Created by Tuuu on 2/20/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class OtherFilesViewModel:FileManagerMedia{
    let extentionSupported = ["doc", "docs", "txt", "pdf", "rtf", "ppt", "html", "htm", "xls", "xlsx", "xlc"]
    override init()
    {
        super.init()
        type = .Other
    }

//    func getSourcePathValid(atIndex index: Int) -> URL? {
//        let url = super.getSourcePath(atIndex: index)
//        return validMimeFile(url: url)
//    }
//    func validMimeFile(url: URL) -> URL?
//    {
//        if(extentionSupported.contains(url.pathExtension))
//        {
//            return url
//        }
//        return nil
//    }
}
