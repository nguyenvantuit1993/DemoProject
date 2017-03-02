//
//  DownloadViewModel.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/2/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
class DownloadViewModel{
    var delegate: DownloadViewDelegate!
    func settingCell(cell: ItemCell, index: Int)
    {
        let track = ManageDownloadTrack.sharedInstance.tracks[index]
        
        // Configure title and artist labels
        cell.titleLabel.text = track.name
        var showDownloadControls = false
        if let download = ManageDownloadTrack.sharedInstance.activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            
            // this toggles the button between the two states pause and resume
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: UIControlState.normal)
        }
        cell.progressView.isHidden = !showDownloadControls
        cell.progressLabel.isHidden = !showDownloadControls
        cell.downloadButton.isHidden =  showDownloadControls
        
        // show the pause and cancel buttons only if a download is active
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
    }
    func pauseTrackAt(indexPath: IndexPath)
    {
        let track = ManageDownloadTrack.sharedInstance.tracks[indexPath.row]
        ManageDownloadTrack.sharedInstance.pauseDownload(track)
        delegate?.reloadCellAt(indexPath: indexPath)
    }
    func cancelTrackAt(indexPath: IndexPath)
    {
        let track = ManageDownloadTrack.sharedInstance.tracks[indexPath.row]
        ManageDownloadTrack.sharedInstance.cancelDownload(track)
        delegate?.reloadCellAt(indexPath: indexPath)
    }
    func resumeTrackAt(indexPath: IndexPath)
    {
        let track = ManageDownloadTrack.sharedInstance.tracks[indexPath.row]
        ManageDownloadTrack.sharedInstance.resumeDownload(track)
        delegate?.reloadCellAt(indexPath: indexPath)
    }
    func downloadTrackAt(indexPath: IndexPath)
    {
        let track = ManageDownloadTrack.sharedInstance.tracks[indexPath.row]
        ManageDownloadTrack.sharedInstance.startDownload(track)
        delegate?.reloadCellAt(indexPath: indexPath)
    }
}
