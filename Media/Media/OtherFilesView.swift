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
        searchController.searchResultsUpdater = self
    }
    override func viewWillAppear(_ animated: Bool) {
        otherFilesViewModel = OtherFilesViewModel(withFolderPath: URL(string:documentsPath! + "/\(kOtherFolder)")!)
        super.viewWillAppear(animated)
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return otherFilesViewModel.filteredCount()
        }
        return otherFilesViewModel.count()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var imagage: UIImage!
        var text: String!
        if searchController.isActive && searchController.searchBar.text != "" {
            imagage = UIImage(data: otherFilesViewModel.getMedia(withIndex: indexPath.row, isFilter: true))
            text = otherFilesViewModel.getNameFilteredItem(atIndex: indexPath.row)
        }
        else
        {
            imagage = UIImage(data: otherFilesViewModel.getMedia(withIndex: indexPath.row, isFilter: false))
            text = otherFilesViewModel.getNameItem(atIndex: indexPath.row)
        }
        cell.imageView?.image = imagage
        cell.textLabel?.text = text
        return cell
    }
}
extension OtherFilesView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        otherFilesViewModel.filterContentForSearchText(searchText: searchBar.text!) {
            self.tableView.reloadData()
        }
    }
}
