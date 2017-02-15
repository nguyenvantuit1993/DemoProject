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
    var mediasViewModel: MediasViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mediasViewModel = MediasViewModel(withFolderPath: URL(string:documentsPath! + "/\(kVideoFolder)")!)
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
extension MediasView{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mediasViewModel == nil ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediasViewModel.count()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(data: mediasViewModel.getMedia(withIndex: indexPath.row))
        return cell
    }
}
