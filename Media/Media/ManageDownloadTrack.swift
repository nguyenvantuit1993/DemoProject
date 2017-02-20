//
//  ManageDownloadTrack.swift
//  Media
//
//  Created by Tuuu on 2/18/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class ManageDownloadTrack: NSObject {
    var activeDownloads = [String: Download]()
    //MARK: Shared Instance
    lazy var downloadsSession: URLSession = {
        // instead of using the default session configuration, you use a special background session configuration
        // you also set a unique identifier for the session here to allow you to reference and "reconnect" to the same background session if needed
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    static let sharedInstance : ManageDownloadTrack = {
        let instance = ManageDownloadTrack(array: [])
        return instance
    }()
    
    //MARK: Local Variable
    
    var tracks : [Track]
    
    //MARK: Init
    
    init( array : [Track]) {
        tracks = array
    }
    func addNewTrack(_ track: Track)
    {
        self.tracks.append(track)
        self.startDownload(track)
    }
    func startDownload(_ track: Track) {
        if let urlString = track.previewUrl, let url = URL(string: urlString) {
            // initialize a Download with the preview URL of the track
            let download = Download(url: urlString)
            // using your new session object, you create a URLSessionDownloadTask with the preview URL and set it to the downloadTask property of the Download
            download.downloadTask = downloadsSession.downloadTask(with: url)
            // start the download task by calling resume() on it
            download.downloadTask!.resume()
            // indicate that the download is in progress
            download.isDownloading = true
            // finally map the download URL to its Download in the activeDownloads dictionary
            activeDownloads[download.url] = download
        }
    }
    func createThumnails(name: String)
    {
        let folderVideoPath = documentsPath!.appending("/\(kVideoFolder)")
        let videoPath = folderVideoPath.appending("/\(name)")
        let thumnailPath = folderVideoPath.appending("/\(kVideoThumbs)").appending("/\((name as NSString).deletingPathExtension).png")
        do {
            let asset = AVURLAsset(url: URL(fileURLWithPath: videoPath) , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            try? UIImagePNGRepresentation(thumbnail)!.write(to: URL(fileURLWithPath: thumnailPath))
            // thumbnail here
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }
    
    func localFolder(mime: String) -> (folderName: String, extentionFile: String)
    {
        var extentionFile: String!
        var folderName: String!
        var type = MimeTypes.Other
        switch mime {
        case "video/x-flv": extentionFile = ".flv"; type = .Video
            break
        case "video/mp4" : extentionFile = ".mp4"; type = .Video
            break
        case "application/x-mpegURL" : extentionFile = ".m3u8"; type = .Video
            break
        case "video/MP2T" : extentionFile = ".ts"; type = .Video
            break
        case "video/3gpp" : extentionFile = ".3gp"; type = .Video
            break
        case "video/quicktime" : extentionFile = ".mov"; type = .Video
            break
        case "video/x-msvideo" : extentionFile = ".avi"; type = .Video
            break
        case "video/x-ms-wmv" : extentionFile = ".wmv"; type = .Video
            break
        case "image/gif" : extentionFile = ".gif"; type = .Image
            break
        case "image/x-icon" : extentionFile = ".ico"; type = .Image
            break
        case "image/jpeg" : extentionFile = ".jpg"; type = .Image
            break
        case "image/svg+xml" : extentionFile = ".svg"; type = .Image
            break
        case "image/tiff" : extentionFile = ".tif"; type = .Image
            break
        case "image/webp" : extentionFile = ".webp"; type = .Image
            break
        default: extentionFile = ""; type = .Other
            break
        }
        
        switch type {
        case .Image: folderName = kImageFolder
            break
        case .Video: folderName = kVideoFolder
            break
        case .Other: folderName = kOtherFolder
            break
        }
        
        return (folderName, extentionFile)
    }
    func localFilePathForUrl(_ previewUrl: String, mime type:String) -> (url: URL?, lastComponent: String)? {
        if let url = URL(string: previewUrl) {
            let infoLocalFile = self.localFolder(mime: type)
            let extentionFile = infoLocalFile.extentionFile
            var lastComponent = url.lastPathComponent as NSString
            if(extentionFile != "")
            {
                lastComponent = lastComponent.deletingPathExtension.appending("\(extentionFile)") as NSString
            }
            
            let fullPath = documentsPath?.appending("/\(infoLocalFile.folderName)").appending("/\(lastComponent)")
            return (URL(fileURLWithPath:fullPath!), lastComponent as String)
        }
        return nil
    }
    func trackIndexForDownloadTask(downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in tracks.enumerated() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }
}

extension ManageDownloadTrack: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var extensionURL: String!
        if let extensionURLCheck = downloadTask.response?.mimeType
        {
            extensionURL = extensionURLCheck
        }
        extensionURL = extensionURL == nil ? "":"\(extensionURL!)"
        // extract the original request URL from the task and pass it to the provided localFilePathForUrl(_:) helper method.
        // localFilePathForUrl(_:) then generates a permanent local file path to save to by appending the lastPastComponent of the URL
        // (i.e. the file name and extension of the file) to the path of the app's Documents directory
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString, let destinationURLAndName = localFilePathForUrl(originalURL, mime: extensionURL) {
            print(destinationURLAndName.url)
            
            // with FileManager you move the downloaded file from its temporary file location to the desired destination file path by
            // clearing out any item at that location before you start the copy task
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: destinationURLAndName.url!)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURLAndName.url!)
                self.createThumnails(name: destinationURLAndName.lastComponent)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        // look up the corresponding Download in your active downloads and remove it
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            activeDownloads[url] = nil
            // look up the Track in your table view and reload the corresponding cell
            if let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask) {
                DispatchQueue.main.async {
                    //                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // using the provided downloadTask, you extract the URL and use it to find the Download in your dictionary of active downloads.
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString, let download = activeDownloads[downloadUrl] {
            // method returns total bytes written and the total bytes expected to be written. You calculate the progress as the ratio of the two
            // values and save the result in the Download. You'll use this value to update the progress view.
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            // ByteCountFormatter takes a byte value and generates a human-readable string showing the total download file size. You'll use this string to show the size of the download alongside the percentage complete
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            // find the cell responsible for displaying the Track and update both its progress view and progress label with the values derived form the previous steps
            
            print(download.progress * 100)
            //            if let trackIndex = trackIndexForDownloadTask(downloadTask: downloadTask), let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? ItemCell {
            //                DispatchQueue.main.async {
            //                    trackCell.progressView.progress = download.progress
            //                    trackCell.progressLabel.text = String(format: "%.1f%% of %@", download.progress * 100, totalSize)
            //                }
            //            }
        }
    }
}
// MARK: URLSessionDelegate
extension ManageDownloadTrack: URLSessionDelegate {
    //     simply grabs the stored completion handler from the app delegate and invokes it on the main thread
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
}
