//
//  MediaView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


class MediasView: TableViewAndSearchBar {
    var mediasViewModel: MediasViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        mediasViewModel = MediasViewModel(withFolderPath: URL(string:documentsPath! + "/\(kVideoFolder)")!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtonList()
    }
    func playVideo(atIndex: Int)
    {
        let player = AVPlayer(url: mediasViewModel.getSourcePath(atIndex: atIndex))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    func addButtonList()
    {
        let listButton : UIBarButtonItem = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MediasView.showPlayList))
        var buttons = self.tabBarController?.navigationItem.rightBarButtonItems
        if((buttons?.count)! > 0)
        {
            buttons?.append(listButton)
            self.tabBarController?.navigationItem.rightBarButtonItems = buttons
        }
    }
    func showPlayList()
    {
        print("ShowPlayList")
    }
}
//delegate
extension MediasView
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet(index: indexPath.row)
    }
    func showActionSheet(index: Int)
    {
        let actionSheet = UIAlertController(title: mediasViewModel.getNameItem(atIndex: index), message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let play: UIAlertAction = UIAlertAction(title: "Play", style: .default) { action -> Void in
            self.playVideo(atIndex: index)
            
        }
        play.setValue(UIColor.red, forKey: "titleTextColor")
        
        let playOnExternal: UIAlertAction = UIAlertAction(title: "Play on External Display", style: .default) { action -> Void in
            
            
        }
        
        let openInOthers: UIAlertAction = UIAlertAction(title: "Open in Other Apps", style: .default) { action -> Void in
            
            
            
            let docController = UIDocumentInteractionController(url: Bundle.main.url(forResource: "test", withExtension: "mp4")!)
            docController.presentOptionsMenu(from: CGRect(x: 50, y: 50, width: 100, height: 100), in:self.view, animated:true)
            
        }
        let saveToCameraRoll: UIAlertAction = UIAlertAction(title: "Save to Camera Roll", style: .default) { action -> Void in
            self.mediasViewModel.saveMediaToCameraRoll(atIndex: index)
            
        }
        let exportFile: UIAlertAction = UIAlertAction(title: "Export File", style: .default) { action -> Void in
            let openInApp = TTOpenInAppActivity(view: self.view, andRect: CGRect(x: 0, y: 0, width: 0, height: 0))
            let activityView = UIActivityViewController(activityItems: [Bundle.main.url(forResource: "test", withExtension: "mp4")!], applicationActivities: [openInApp!])
            self.present(activityView, animated: true, completion: nil)
            
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(play)
        actionSheet.addAction(playOnExternal)
        actionSheet.addAction(openInOthers)
        actionSheet.addAction(saveToCameraRoll)
        actionSheet.addAction(exportFile)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
//datasource
extension MediasView{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mediasViewModel == nil ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return mediasViewModel.filteredCount()
        }
        return mediasViewModel.count()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var imagage: UIImage!
        var text: String!
        if searchController.isActive && searchController.searchBar.text != "" {
            imagage = UIImage(data: mediasViewModel.getMedia(withIndex: indexPath.row, isFilter: true))
            text = mediasViewModel.getNameFilteredItem(atIndex: indexPath.row)
        }
        else
        {
            imagage = UIImage(data: mediasViewModel.getMedia(withIndex: indexPath.row, isFilter: false))
            text = mediasViewModel.getNameItem(atIndex: indexPath.row)
        }
        cell.imageView?.image = imagage
        cell.textLabel?.text = text
        return cell
    }
}
extension MediasView: UIDocumentInteractionControllerDelegate
{
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
}
extension MediasView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        mediasViewModel.filterContentForSearchText(searchText: searchBar.text!) {
            self.tableView.reloadData()
        }
    }
}
