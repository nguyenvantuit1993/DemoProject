//
//  ViewController.swift
//  WebBrowser
//
//  Created by Tuuu on 3/6/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.showsBookmarkButton = true
        self.searchBar.setImage(UIImage(named: "test.png"), for: .bookmark, state: .normal)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
    }

}

