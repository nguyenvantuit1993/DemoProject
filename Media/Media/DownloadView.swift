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
protocol DownloadViewDelegate {
    func reloadCellAt(indexPath: IndexPath)
}
class DownloadView: BasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var downloadViewModel = DownloadViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemCell")
        tableView.tableFooterView = UIView()
        // calling the lazily-loaded downloadsSession ensures the app creates exactly one background session upon initialization of SearchViewController
        self.downloadViewModel.delegate = self
        ManageDownloadTrack.sharedInstance.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DownloadView: DownloadViewDelegate
{
    func reloadCellAt(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: TrackCellDelegate

extension DownloadView: TrackCellDelegate {
    func pauseTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.downloadViewModel.pauseTrackAt(indexPath: indexPath)
        }
    }
    
    func resumeTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.downloadViewModel.resumeTrackAt(indexPath: indexPath)
        }
    }
    
    func cancelTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.downloadViewModel.cancelTrackAt(indexPath: indexPath)
        }
    }
    
    func downloadTapped(_ cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.downloadViewModel.downloadTrackAt(indexPath: indexPath)
        }
    }
}

// MARK: UITableViewDataSource

extension DownloadView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManageDownloadTrack.sharedInstance.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        self.downloadViewModel.settingCell(cell: cell, index: indexPath.row)
        
        return cell
    }
}


// MARK: UITableViewDelegate

extension DownloadView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        self.tableView.reloadData()
    }

}

