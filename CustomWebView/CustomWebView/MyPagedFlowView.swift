//
//  MyPagedFlowView.swift
//  CustomWebView
//
//  Created by Tuuu on 2/10/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class MyPagedFlowView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lbl_Title: UILabel!

     @IBOutlet weak var lbl_SubTitle: UILabel!

    @IBOutlet weak var scrollView: PagedFlowView!

    @IBOutlet weak var pageController: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    func setup() {
        view = loadViewFromNib()
        self.addSubview(view)
//        self.scrollView.pageControl = self.pageController;
        self.scrollView.minimumPageAlpha = 0.3;
        self.scrollView.minimumPageScale = 1;
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("MyPagedFlowView", owner: self, options: nil)?[0]
        return subView as! UIView
    }
}
