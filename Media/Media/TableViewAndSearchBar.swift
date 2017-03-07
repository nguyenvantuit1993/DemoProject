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
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
        addBarButtons()
    }
    func reloadTableView()
    {
        self.tableView.reloadData()
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
