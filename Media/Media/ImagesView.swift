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
extension ImagesView: UICollectionViewDelegate
{
    
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
