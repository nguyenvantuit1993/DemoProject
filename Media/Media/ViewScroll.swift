//
//  ViewScroll.swift
//  MyPets
//
//  Created by NguyenDucBien on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class ViewScroll: UIViewController {

    @IBOutlet weak var customScrollView: UIView!

    @IBOutlet weak var customCollectionView: UIView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customScrollView = CustomScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 80))
        self.view.addSubview(customScrollView)
        customCollectionView = CustomCollectionView(frame: CGRect(x: 0, y: self.view.bounds.size.height - 80, width: self.view.bounds.size.width, height: 30))
        customCollectionView.delegate = self
        self.view.addSubview(customCollectionView)
        
    }
    
    
    
}
extension ViewScroll: ScrollDelegate{
    func selectedImage(pageControlCurrentPage: Int, scrollViewContentOffSet: CGPoint) {
        self.customScrollView.pageControl.currentPage = pageControlCurrentPage
        self.customScrollView.scrollView.contentOffset = scrollViewContentOffSet
    }
    
    func scrollCollectionView(scrollViewContentOffSet: CGPoint) {
        self.customScrollView.scrollView.contentOffset = scrollViewContentOffSet
    }

}
