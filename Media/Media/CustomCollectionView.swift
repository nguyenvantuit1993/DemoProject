//
//  CustomCollectionView.swift
//  MyPets
//
//  Created by NguyenDucBien on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

protocol ScrollDelegate {
    func selectedImage(pageControlCurrentPage: Int, scrollViewContentOffSet: CGPoint)
    func scrollCollectionView(scrollViewContentOffSet: CGPoint)
}

class CustomCollectionView: UIView {

    var clickedImage: CGFloat!
    var imagesStore: [UIImage]!
    var collectionView: UICollectionView!
    var delegate: ScrollDelegate!
    var start = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let images = Images.sharedInstance
        clickedImage = images.clickedImage // lưu lại ảnh được click ở ViewController
        imagesStore = images.cells
        buildCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildCollectionView()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.bounds.size.width / 10, height: 30)
        //        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CellItem.self, forCellWithReuseIdentifier: "Cell")
        self.addSubview(collectionView)
        let myPath = NSIndexPath(item: Int(clickedImage), section: 0)
        collectionView.scrollToItem(at: myPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        start = 1
    }
    
}

extension CustomCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        let pageControlCurrentPage = indexPath.row
        let scrollViewContentOffSet = CGPoint(x: CGFloat(indexPath.row) * self.bounds.size.width, y: 0)
        delegate.selectedImage(pageControlCurrentPage: pageControlCurrentPage, scrollViewContentOffSet: scrollViewContentOffSet)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if start == 1{
            
            let indexToShow = scrollView.contentOffset.x / (self.bounds.size.width / 10)
            let scrollViewContentOffSet = CGPoint(x: CGFloat(indexToShow) * self.bounds.size.width, y: 0)
            delegate.scrollCollectionView(scrollViewContentOffSet: scrollViewContentOffSet)
        }
    }
}


extension CustomCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imagesStore.count)
        return imagesStore.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellItem
        cell.addSubViews()
        cell.imageView.image = imagesStore[indexPath.item]
        return cell
    }

}
