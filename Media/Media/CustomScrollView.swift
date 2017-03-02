//
//  CustomScrollView.swift
//  MyPets
//
//  Created by NguyenDucBien on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class CustomScrollView: UIView {

    let scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var photo: [UIImageView] = [] // chứa ảnh để trả về lúc zoom
    var frontScrollViews: [UIScrollView] = [] // scrollView con để zoom không bị lỗi
    var first = false
    var clickedImage: CGFloat!
    var imagesStore: [UIImage]! // chứa ảnh
    var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let images = Images.sharedInstance
        clickedImage = images.clickedImage // lưu lại ảnh được click ở ViewController
        imagesStore = images.cells
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        if !first
        {
            first = true
            scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            self.scrollView.isPagingEnabled = true
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            self.addSubview(scrollView)
            pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 2
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(imagesStore.count) , height: 0)
            scrollView.contentOffset = CGPoint(x: CGFloat(clickedImage) * scrollView.frame.size.width, y: 0)
            for i in 0..<imagesStore.count
            {
                let imgView = UIImageView()
                imgView.image = imagesStore[i]
                imgView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
                imgView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg(_:)))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg(_:)))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.require(toFail: doubleTap)
                photo.append(imgView)
                let frontScrollView = UIScrollView(frame: CGRect( x: (CGFloat(i) * scrollView.frame.size.width), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                self.scrollView.addSubview(frontScrollView)
            }
            configurePageControl()
            
        }
        
    }
    
    func configurePageControl()
    {
        self.pageControl.frame = CGRect(x: 0, y: self.bounds.size.height - 30, width: self.bounds.width, height: 30)
        self.pageControl.numberOfPages = imagesStore.count
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.currentPage = Int(clickedImage)
        //        self.view.addSubview(pageControl)
    }
    
    
}

extension CustomScrollView: UIScrollViewDelegate
{
    
    
    func changePage(sender: UIPageControl) -> ()
    {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    
    func tapImg(_ gesture: UITapGestureRecognizer)
    {
        let position = gesture.location(in: photo[pageControl.currentPage])
        zoomRectForScale(frontScrollViews[pageControl.currentPage].zoomScale * 1.5, center: position)
    }
    
    func doubleTapImg(_ gesture: UITapGestureRecognizer)
    {
        if frontScrollViews[pageControl.currentPage].zoomScale > frontScrollViews[pageControl.currentPage].minimumZoomScale
        {
            let position = gesture.location(in: photo[pageControl.currentPage])
            zoomRectForScale(frontScrollViews[pageControl.currentPage].zoomScale * 0.5, center: position)
        }
    }
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint)
    {
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollViews[pageControl.currentPage].zoom(to: zoomRect, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return photo[pageControl.currentPage]
    }

}
