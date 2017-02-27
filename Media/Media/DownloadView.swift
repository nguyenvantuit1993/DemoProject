//
//  DownloadView.swift
//  TouchToDownload
//
//  Created by Tuuu on 2/9/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class DownloadView: UITableViewController {
    var downloadFiles = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemCell")
        tableView.tableFooterView = UIView()
        // calling the lazily-loaded downloadsSession ensures the app creates exactly one background session upon initialization of SearchViewController
        ManageDownloadTrack.sharedInstance.delegate = self
        downloadFiles = ManageDownloadTrack.sharedInstance.tracks
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: TrackCellDelegate

extension DownloadView: TrackCellDelegate {
    func pauseTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = downloadFiles[indexPath.row]
            ManageDownloadTrack.sharedInstance.pauseDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func resumeTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = downloadFiles[indexPath.row]
            ManageDownloadTrack.sharedInstance.resumeDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func cancelTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = downloadFiles[indexPath.row]
            ManageDownloadTrack.sharedInstance.cancelDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func downloadTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = downloadFiles[indexPath.row]
            ManageDownloadTrack.sharedInstance.startDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
}

// MARK: UITableViewDataSource

extension DownloadView{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        
        let track = downloadFiles[indexPath.row]
        
        // Configure title and artist labels
        cell.titleLabel.text = track.name
        //        cell.artistLabel.text = track.artist
        
        // for tracks with active downloads, you set showDownloadControls to true; otherwise, you set it to false
        // you then display the progress views and labels, provided with the sample project, in accordance with the value of showDownloadControls
        // for paused downloads, display "Paused" for the status; otherwise "Downloading..."
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
        
        // If the track is already downloaded, enable cell selection and hide the Download button
        //        let downloaded = localFileExistsForTrack(track)
        //        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        //
        //        // hide the Download button also if its track is downloading
        cell.downloadButton.isHidden =  showDownloadControls
        
        // show the pause and cancel buttons only if a download is active
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
        
        return cell
    }
}


// MARK: UITableViewDelegate

extension DownloadView{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let track = searchResults[indexPath.row]
        //        if localFileExistsForTrack(track) {
        //            playDownload(track)
        //        }
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DownloadView: DownloadFileDelegate
{
    func getCellFromIndex(index: Int) -> ItemCell?
    {
        return tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ItemCell
    }
    func didWriteData(indexCell: Int, downloadInfo: Download, totalSize: String) {
        if let trackCell = getCellFromIndex(index: indexCell)
        {
            DispatchQueue.main.async {
                trackCell.progressView.progress = downloadInfo.progress
                trackCell.progressLabel.text = String(format: "%.1f%% of %@", downloadInfo.progress * 100, totalSize)
            }
        }
    }
    func didDownloaded(indexCell: IndexPath)
    {
        self.downloadFiles.remove(at: indexCell.row)
        self.tableView.reloadData()
    }

}

