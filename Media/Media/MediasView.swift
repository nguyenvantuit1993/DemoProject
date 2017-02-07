//
//  MediaView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class MediasView: TableViewAndSearchBar {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addButtonList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtonList()
    }
    func addButtonList()
    {
        let listButton : UIBarButtonItem = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MediasView.showPlayList))
        var buttons = self.tabBarController?.navigationItem.rightBarButtonItems
        if((buttons?.count)! > 0)
        {
            buttons?.append(listButton)
            self.tabBarController?.navigationItem.rightBarButtonItems = buttons
        }
    }
    func showPlayList()
    {
        print("ShowPlayList")
    }
}
