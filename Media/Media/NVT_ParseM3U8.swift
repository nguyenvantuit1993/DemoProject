//
//  NVT_ParseM3U8.swift
//  Media
//
//  Created by tuios on 3/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class NVT_ParseM3U8{
    
    class func getFilesFromM3U8Path(path: NSString, complete:@escaping (NSArray)->())
    {
        var baseURLString: NSString = path
        let segmentURLs = NSMutableArray()
        DispatchQueue.global(qos: .default).async {
            do
            {
                let model = try M3U8PlaylistModel(url: baseURLString as String!)
                baseURLString = baseURLString.deletingLastPathComponent as NSString
                let baseURL = NSURL(string: baseURLString as String)
                
                let segmentInfList = model.mainMediaPl.segmentList
                
                for index in 0..<Int((segmentInfList?.count)!)
                {
                    let segmentURI = segmentInfList?.segmentInfo(at: UInt(index)).uri
                    let meduaURL = baseURL?.appendingPathComponent(segmentURI!)
                    segmentURLs.add(meduaURL)
                }
                complete(segmentURLs)
                
            }
            catch let error
            {
                print(error)
            }
        }
    }
}
