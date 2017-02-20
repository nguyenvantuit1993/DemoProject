//
//  OtherFilesView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class OtherFilesView: TableViewAndSearchBar {
    var otherFilesViewModel: OtherFilesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        otherFilesViewModel = OtherFilesViewModel(withFolderPath: URL(string:documentsPath! + "/\(kOtherFolder)")!)
    }
    func showContentFile(url: URL?)
    {
        if(url != nil)
        {
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailFile") as! DetailFile
            detailView.urlFile = url
            self.present(detailView, animated: true, completion: nil)
        }
    }
}
//MARK: Delegate
extension OtherFilesView
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showContentFile(url: self.otherFilesViewModel.getSourcePathValid(atIndex: indexPath.row))
    }
}
//MARK: DataSource
extension OtherFilesView
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return otherFilesViewModel == nil ? 0 : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherFilesViewModel.count()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(data: otherFilesViewModel.getMedia(withIndex: indexPath.row))
        return cell
    }
}
