//
//  ImagesView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import AVKit
class MediaView: BaseClearBarItemsViewController{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedFiles = [String]()
    var currentIndex: Int!
    var mediaViewModel: MediaViewModel!
    var isFakeLogin: Bool!
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editOptions.delegate = self
        if(self.currentPath == nil)
        {
            self.currentPath = documentsPath
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ReloadMediaView"), object: nil)
        // Setup the Search Controller
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.headerView.addSubview(searchController.searchBar)
        
        mediaViewModel = MediaViewModel()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CustomCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImagesViewCell")
        self.view.backgroundColor = UIColor.black
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
        super.viewWillAppear(animated)
    }
    
    func reloadData()
    {
        mediaViewModel.resetData()
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kImageFolder)")!, type: .Image)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kVideoFolder)")!, type: .Video)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kOtherFolder)")!, type: .Other)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kUserFolders)")!, type: .Folder)
        self.collectionView.reloadData()
    }
    func playVideo(atIndex: Int)
    {
        let player = AVPlayer(url: mediaViewModel.getSourcePath(atIndex: atIndex, isFilter: self.checkIsFilter()))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    func showContentFile(url: URL?)
    {
        if(url != nil)
        {
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailFile") as! DetailFile
            detailView.urlFile = url
            self.present(detailView, animated: true, completion: nil)
        }
    }
    func showContentOfFolder(url: String)
    {
        let subMediaView = self.storyboard?.instantiateViewController(withIdentifier: "MediaView") as! MediaView
        subMediaView.currentPath = url
        self.navigationController?.pushViewController(subMediaView, animated: true)
    }
    func showImageAt(index: Int, isFilter: Bool)
    {
        self.currentIndex = index
        let image = mediaViewModel.getNameItem(atIndex: index, isFilter: isFilter)
        let viewScroll = self.storyboard?.instantiateViewController(withIdentifier: "ViewScroll") as! DetailImageView
        mediaViewModel.type = .Image
        viewScroll.items = mediaViewModel.getListItemsAt(path: URL(string:"\(self.currentPath!)/\(kImageFolder)")!)
        viewScroll.index = mediaViewModel.getIndexWithName(name: image, items: viewScroll.items)
        viewScroll.delegate = self
        self.navigationController?.pushViewController(viewScroll, animated: true)
    }
    func showActionSheet(index: Int, isFilter: Bool)
    {
        let actionSheet = UIAlertController(title: self.mediaViewModel.getNameItem(atIndex: index, isFilter: isFilter), message: "", preferredStyle: .actionSheet)
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
            self.mediaViewModel.saveMediaToCameraRoll(atIndex: index, isFilter: self.checkIsFilter())
            
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
    func checkIsFilter() -> Bool
    {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return true
        }
        return false
    }
}
extension MediaView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (self.view.frame.size.width/4) - 1, height: 95)
        return size
    }
}
extension MediaView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isFilter = false
        if checkIsFilter()
        {
            isFilter = true
        }
        selectedFiles.append(self.mediaViewModel.getSourcePath(atIndex: indexPath.row, isFilter: isFilter).absoluteString)
        if(selectedFiles.count > 1)
        {
            self.editOptions.btn_Rename.isEnabled = false
        }
        else
        {
            if(self.editOptions.btn_Rename.isEnabled == false)
            {
                self.editOptions.btn_Rename.isEnabled = true
            }
        }
        switch self.mediaViewModel.getItems(isFilter: isFilter)[indexPath.row].getType() {
        case .Image:
            self.showImageAt(index: indexPath.row, isFilter: isFilter)
            break
        case .Video:
            //khi edit can chu y
            self.showActionSheet(index: indexPath.row, isFilter: isFilter)
            break
        case .Other:
            self.showContentFile(url: self.mediaViewModel.getSourcePathValid(atIndex: indexPath.row, isFilter: isFilter))
            break
        default:
            self.showContentOfFolder(url: "\(self.currentPath!)/\(kUserFolders)/\(self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: isFilter))")
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var isFilter = false
        if checkIsFilter()
        {
            isFilter = true
        }
        self.selectedFiles = self.selectedFiles.filter{$0 != self.mediaViewModel.getSourcePath(atIndex: indexPath.row, isFilter: isFilter).absoluteString}
    }
    
}
extension MediaView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if checkIsFilter() {
            return mediaViewModel.filteredCount()
        }
        return mediaViewModel.count()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesViewCell", for: indexPath) as! CustomCollectionCell
        
        if checkIsFilter()
        {
            
            if let imageData = self.mediaViewModel.getMedia(withIndex: indexPath.row, isFilter: true)
            {
                cell.imageView.image = UIImage(data: imageData)
            }
            cell.fileName.text = self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: true)
        }
        else
        {
            if let imageData = self.mediaViewModel.getMedia(withIndex: indexPath.row, isFilter: false)
            {
                cell.imageView.image = UIImage(data: imageData)
            }
            cell.fileName.text = self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: false)
        }
        if(self.mediaViewModel.getTypeAt(index: indexPath.row) == .Video)
        {
            cell.playView.isHidden = false
        }
        else
        {
            cell.playView.isHidden = true
        }
        return cell
        
    }
    
}
extension MediaView: DetailImageViewDelegate
{
    func getImageAt(index: Int) -> UIImage?
    {
        if let imageData = self.mediaViewModel.getMedia(withIndex: index, isFilter: false)
        {
            return UIImage(data: imageData)
        }
        return nil
    }
    func numberOfRowInSection() -> Int
    {
        return self.mediaViewModel.count()
    }
    func getCurrentIndex() -> Int
    {
        return self.currentIndex
    }
    
}
extension MediaView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        mediaViewModel.filterContentForSearchText(searchText: searchBar.text!) {
            self.collectionView.reloadData()
        }
    }
}
extension MediaView: EditOptionsDelegate
{
    func copyFile()
    {
        if(self.selectedFiles.count > 0)
        {
            self.mediaViewModel.deleteFile(paths: self.selectedFiles)
        }
    }
    func moveFile()
    {
        if(self.selectedFiles.count > 0)
        {
            self.mediaViewModel.deleteFile(paths: self.selectedFiles)
        }
    }
    func renameFile()
    {
        if(self.selectedFiles.count > 0)
        {
            self.showAlert(title: "Rename Media As", titleSaveButton: "Save", type: .Rename)
        }
    }
    func deleteFile()
    {
        if(self.selectedFiles.count > 0)
        {
            self.showAlert(title: "Do you want to delete the media?", titleSaveButton: "Delete", type: .Delete)
        }
    }
    
    func showAlert(title: String, titleSaveButton: String, type: EditOptionsEnum)
    {
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: titleSaveButton, style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            switch(type)
            {
            case .Delete:
                self.mediaViewModel.deleteFile(paths: self.selectedFiles)
                break
            case .Rename:
                let firstTextField = alertController.textFields![0] as UITextField
                if let string = firstTextField.text
                {
                    self.mediaViewModel.renameFile(path: self.selectedFiles.first!, newName: string)
                }
                break
            default:
                break
            }
            
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        if type == .Rename {
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Media Name"
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
