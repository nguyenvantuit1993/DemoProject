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
    var imageViewModel: ImagesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CustomCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImagesViewCell")
        self.view.backgroundColor = UIColor.black
        imageViewModel = ImagesViewModel(withFolderPath: URL(string:documentsPath! + "/\(kImageFolder)")!)
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
        self.currentIndex = indexPath.row
        let viewScroll = self.storyboard?.instantiateViewController(withIdentifier: "ViewScroll") as! DetailImageView
        viewScroll.items = imageViewModel.getItems()
        viewScroll.index = indexPath.row
        viewScroll.delegate = self
        self.navigationController?.pushViewController(viewScroll, animated: true)
    }
}
extension ImagesView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewModel.count()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesViewCell", for: indexPath) as! CustomCollectionCell
        cell.imageView.image = UIImage(data: imageViewModel.getMedia(withIndex: indexPath.row))
        return cell
        
    }
    
}
extension ImagesView: DetailImageViewDelegate
{
    func getImageAt(index: Int) -> UIImage
    {
        return UIImage(data: imageViewModel.getMedia(withIndex: index))!
    }
    func numberOfRowInSection() -> Int
    {
        return self.imageViewModel.count()
    }
    func getCurrentIndex() -> Int
    {
        return self.currentIndex
    }
    
}
