//
//  TableViewAndSearchBar.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class TableViewAndSearchBar: BaseClearBarItemsTableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBarButtons()
    }
    func addBarButtons()
    {
        let edit : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TableViewAndSearchBar.edit))
        self.tabBarController?.navigationItem.rightBarButtonItems = [edit]
    }
    func edit()
    {
        print("edit")
    }
}
extension TableViewAndSearchBar: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //        messageViewModel.filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension TableViewAndSearchBar: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        //        messageViewModel.filterContentForSearchText(searchText: searchBar.text!)
    }
}
