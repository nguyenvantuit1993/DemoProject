//
//  ImagesView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class ImagesView: BaseClearBarItemsViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currentIndex: Int!
    var mediaViewModel: MediaViewModel!
    var isFakeLogin: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaViewModel = MediaViewModel()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CustomCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImagesViewCell")
        self.view.backgroundColor = UIColor.black
        
    }
    override func viewWillAppear(_ animated: Bool) {
        mediaViewModel.getListFiles(folderPath: URL(string:documentsPath! + "/\(kImageFolder)")!, type: .Image)
        mediaViewModel.getListFiles(folderPath: URL(string:documentsPath! + "/\(kVideoFolder)")!, type: .Video)
        mediaViewModel.getListFiles(folderPath: URL(string:documentsPath! + "/\(kOtherFolder)")!, type: .Other)
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
}
extension ImagesView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (self.view.frame.size.width/4) - 1, height: (self.view.frame.size.height/6) - 1)
        return size
    }
}
extension ImagesView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch self.mediaViewModel.getItems()[indexPath.row].getType() {
        case .Image:
           self.showImageAt(index: indexPath.row)
            break
        case .Video:
            self.showActionSheet(index: indexPath.row)
            break
        default:
            break
        }
    }
    
    func showImageAt(index: Int)
    {
        self.currentIndex = index
        let viewScroll = self.storyboard?.instantiateViewController(withIdentifier: "ViewScroll") as! DetailImageView
        viewScroll.items = mediaViewModel.getItems()
        viewScroll.index = index
        viewScroll.delegate = self
        self.navigationController?.pushViewController(viewScroll, animated: true)
    }
    func showActionSheet(index: Int)
    {
        let actionSheet = UIAlertController(title: self.mediaViewModel.getNameItem(atIndex: index), message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        let play: UIAlertAction = UIAlertAction(title: "Play", style: .default) { action -> Void in
//            self.playVideo(atIndex: index)
            
        }
        play.setValue(UIColor.red, forKey: "titleTextColor")
        
        let playOnExternal: UIAlertAction = UIAlertAction(title: "Play on External Display", style: .default) { action -> Void in
            
            
        }
        
        let openInOthers: UIAlertAction = UIAlertAction(title: "Open in Other Apps", style: .default) { action -> Void in
            
            
            
            let docController = UIDocumentInteractionController(url: Bundle.main.url(forResource: "test", withExtension: "mp4")!)
            docController.presentOptionsMenu(from: CGRect(x: 50, y: 50, width: 100, height: 100), in:self.view, animated:true)
            
        }
        let saveToCameraRoll: UIAlertAction = UIAlertAction(title: "Save to Camera Roll", style: .default) { action -> Void in
//            self.mediasViewModel.saveMediaToCameraRoll(atIndex: index)
            
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
    //
}
extension ImagesView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaViewModel.count()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesViewCell", for: indexPath) as! CustomCollectionCell
        cell.imageView.image = UIImage(data: self.mediaViewModel.getMedia(withIndex: indexPath.row, isFilter: false))
        cell.fileName.text = self.mediaViewModel.getNameItem(atIndex: indexPath.row)
        return cell
        
    }
    
}
extension ImagesView: DetailImageViewDelegate
{
    func getImageAt(index: Int) -> UIImage
    {
        return UIImage(data: mediaViewModel.getMedia(withIndex: index, isFilter: false))!
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
