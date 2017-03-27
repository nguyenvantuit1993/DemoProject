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
import AVFoundation
import GoogleMobileAds

class MediaView: BaseClearBarItemsViewController{
    
    @IBOutlet weak var bannerMediaView: GADBannerView!
    @IBOutlet weak var btn_Filter: UIButton!
    @IBOutlet weak var headerView: UIView!
    var currentIndex: Int!
    var isFakeLogin: Bool!
    var mediaViewModel: MediaViewModel!
    var dropDown = DropDown(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .plain)
    let searchController = UISearchController(searchResultsController: nil)
    var docController: UIDocumentInteractionController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bannerMediaView = self.adBannerView
        if(self.currentPath == nil)
        {
            self.currentPath = documentsPath
        }
        let hiddenDropDownGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenDropDown))
        self.collectionView.addGestureRecognizer(hiddenDropDownGesture)
        hiddenDropDownGesture.cancelsTouchesInView = false
        
        self.addDropDown()
        self.addBaseButton()
        
        self.fileManager.delegate = self
        self.editOptions.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ReloadMediaView"), object: nil)
        // Setup the Search Controller
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.headerView.addSubview(searchController.searchBar)
        
        mediaViewModel = MediaViewModel()
        mediaViewModel.setMediaViewModelDelegate(delegate: self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CustomCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImagesViewCell")
        
        
        self.view.backgroundColor = UIColor.black
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.editOptions.resizeButtons()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dropDown.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    func addDropDown()
    {
        self.btn_Filter.backgroundColor = baseColor
        dropDown.dropDownDelegate = self
        self.view.addSubview(dropDown)
        
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: dropDown, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.btn_Filter, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: dropDown, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
        
        let heightConstraint = NSLayoutConstraint(item: dropDown, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(dropDown.items.count * 50))
        
        let verticalConstraint = NSLayoutConstraint(item: dropDown, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        editOptions.layoutIfNeeded()
        setStateForDropDown()
    }
    @IBAction func filter(_ sender: Any) {
        setStateForDropDown()
    }
    func setTitleForFilterButton(title: String)
    {
        self.btn_Filter.setTitle(title, for: .normal)
    }
    func setStateForDropDown()
    {
        dropDown.isHidden = !dropDown.isHidden
    }
    func hiddenDropDown()
    {
        self.dropDown.isHidden = true
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
    func reloadDataWith(path: URL, type: MimeTypes)
    {
        mediaViewModel.resetData()
        mediaViewModel.getListFiles(folderPath: path, type: type)
        self.collectionView.reloadData()
    }
    func playVideo(atIndex: Int)
    {
        self.playVideo(url: mediaViewModel.getSourcePath(atIndex: atIndex, isFilter: self.checkIsFilter()))
        
    }
    func playVideo(url: URL)
    {
        let player = AVPlayer(url: url)
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
            if(url?.pathExtension == "mp3")
            {
                self.playVideo(url: url!)
            }
            else
            {
                let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailFile") as! DetailFile
                detailView.urlFile = url
                self.present(detailView, animated: true, completion: nil)
            }
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
    func showActionSheet()
    {
        let actionSheet = UIAlertController(title: self.mediaViewModel.getSelectedItem(at: 0).getNameToShow(), message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            self.didFinishAction()
        }
        //        let play: UIAlertAction = UIAlertAction(title: "Play", style: .default) { action -> Void in
        //            self.playVideo(atIndex: index)
        //
        //        }
        //        play.setValue(UIColor.red, forKey: "titleTextColor")
        let openInOthers = UIAlertAction(title: "Open in Other Apps", style: .default) { action -> Void in
            self.docController = UIDocumentInteractionController(url: self.mediaViewModel.getSelectedFileSourcePath().first!)
            self.docController.presentOptionsMenu(from: CGRect(x: 50, y: 50, width: 100, height: 100), in:self.view, animated:true)
            self.docController.delegate = self
        }
        
        
        let saveToCameraRoll: UIAlertAction = UIAlertAction(title: "Save to Camera Roll", style: .default) { action -> Void in
            self.mediaViewModel.saveSelectedMediaToCameraRoll()
            self.didFinishAction()
        }
        saveToCameraRoll.setValue(UIColor.red, forKey: "titleTextColor")
        
        let urlsToExport = self.mediaViewModel.getSelectedFileSourcePath()
        let exportFile: UIAlertAction = UIAlertAction(title: "Export File", style: .default) { action -> Void in
            let openInApp = TTOpenInAppActivity(view: self.view, andRect: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            let activityView = UIActivityViewController(activityItems: urlsToExport, applicationActivities: [openInApp!])
            activityView.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                self.didFinishAction()
            }
            self.present(activityView, animated: true, completion: nil)
            
            
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(saveToCameraRoll)
        actionSheet.addAction(openInOthers)
        actionSheet.addAction(exportFile)
        
        
        //        actionSheet.addAction(play)
        
        
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
        let size = CGSize(width: (self.view.frame.size.width/4) - 20, height: 110)
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
        if(isEdit == true)
        {
            self.mediaViewModel.addSelectedItem(at: indexPath.row, isFilter: isFilter)
            self.checkButtons()
            return
        }
        if(self.mediaViewModel.getSelectedItemCount() > 1)
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
            self.playInterstitailAdMod()
            self.playVideo(atIndex: indexPath.row)
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
        if (isEdit == true)
        {
            self.mediaViewModel.removeSelectedItem(item: self.mediaViewModel.getItem(at: indexPath.row, isFilter: isFilter))
            self.checkButtons()
        }
    }
    func checkButtons()
    {
        if(self.mediaViewModel.getSelectedItemCount() == 0)
        {
            self.editOptions.btn_Rename.isEnabled = false
            self.editOptions.btn_Remove.isEnabled = false
            self.editOptions.btn_Copy.isEnabled = false
            self.editOptions.btn_Move.isEnabled = false
            self.editOptions.btn_More.isEnabled = false
        }
        else
        {
            if(self.mediaViewModel.getSelectedItemCount() == 1)
            {
                self.editOptions.btn_Rename.isEnabled = true
            }
            self.editOptions.btn_Remove.isEnabled = true
            self.editOptions.btn_Copy.isEnabled = true
            self.editOptions.btn_Move.isEnabled = true
            self.editOptions.btn_More.isEnabled = true
        }
        
        
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
        
        cell.btn_Select.isHidden = !isEdit
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
extension MediaView: TreeFolderDelegate
{
    internal func didSelectCopy(path: String) {
        self.mediaViewModel.copyFile(items: self.mediaViewModel.getSelectedItems(), to: URL(fileURLWithPath: path))
    }
    
    func didSelectMove(path: String) {
        self.mediaViewModel.moveFile(items: self.mediaViewModel.getSelectedItems(), to: URL(fileURLWithPath: path))
    }
}
extension MediaView: EditOptionsDelegate
{
    func moreOptions()
    {
        self.showActionSheet()
    }
    func copyFile()
    {
        if(self.mediaViewModel.getSelectedItemCount() > 0)
        {
            let treeFolder = CopyView(nibName: "TreeFolder", bundle: nil)
            treeFolder.currentPath = documentsPath
            treeFolder.treeFolderDelegate = self
            self.navigationController?.pushViewController(treeFolder, animated: true)
        }
    }
    func moveFile()
    {
        if(self.mediaViewModel.getSelectedItemCount() > 0)
        {
            let treeFolder = MoveView(nibName: "TreeFolder", bundle: nil)
            treeFolder.currentPath = documentsPath
            treeFolder.treeFolderDelegate = self
            self.navigationController?.pushViewController(treeFolder, animated: true)
        }
    }
    func renameFile()
    {
        if(self.mediaViewModel.getSelectedItemCount() == 1)
        {
            self.showAlert(title: "Rename Media As", titleSaveButton: "Save", type: .Rename)
        }
    }
    func deleteFile()
    {
        if(self.mediaViewModel.getSelectedItemCount() > 0)
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
                self.mediaViewModel.deleteFile(items: self.mediaViewModel.getSelectedItems())
                break
            case .Rename:
                let firstTextField = alertController.textFields![0] as UITextField
                if let string = firstTextField.text
                {
                    self.mediaViewModel.renameFile(item: self.mediaViewModel.getSelectedItems().first!, newName: string)
                }
                break
            default:
                break
            }
            self.reloadData()
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
extension MediaView: NVT_FileManagerDelegate
{
    func showError(description: String)
    {
        self.present(Alert.showError(description: description, downloadViewURL: nil), animated: true, completion: nil)
    }
    func didFinishAction()
    {
        self.mediaViewModel.removeAllSetectedItems()
        self.reloadData()
        self.checkButtons()
    }
}
extension MediaView: DropDownDelegate
{
    func didSelectItem(type: MimeTypes)
    {
        switch type {
        case .Image:
            self.reloadDataWith(path: URL(string:currentPath! + "/\(kImageFolder)")!, type: type)
            break
        case .Video:
            self.reloadDataWith(path: URL(string:currentPath! + "/\(kVideoFolder)")!, type: type)
            break
        case .Other:
            self.reloadDataWith(path: URL(string:currentPath! + "/\(kOtherFolder)")!, type: type)
            break
        case .Folder:
            self.reloadDataWith(path: URL(string:currentPath! + "/\(kUserFolders)")!, type: type)
            break
        default:
            self.reloadData()
            break
        }
        self.setTitleForFilterButton(title: type.rawValue)
    }
}
extension MediaView: UIDocumentInteractionControllerDelegate
{
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.didFinishAction()
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        self.didFinishAction()
    }
}
