//
//  TableHomeView.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class TableHomeView:UITableViewController, ActionHomeView
{
    let searchController = UISearchController(searchResultsController: nil)
    var messageViewModel: HomeMessageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        //        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
        messageViewModel = HomeMessageViewModel()
        messageViewModel.delegate = self
        
        self.tableView.register(UINib(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessCell")
        
        addBarButtons()
        //        if let splitViewController = splitViewController {
        //            let controllers = splitViewController.viewControllers
        //            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        //        }
    }
    func addBarButtons()
    {
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = logButton
    }
    override func viewWillAppear(_ animated: Bool) {
        //        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let message: Message
                if searchController.isActive && searchController.searchBar.text != "" {
                    message = messageViewModel.filteredMessages[indexPath.row]
                } else {
                    message = messageViewModel.messages[indexPath.row]
                }
                //                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //                controller.detailCandy = candy
                //                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                //                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}
extension TableHomeView
{
    func didFilter() {
        self.tableView.reloadData()
    }
}
extension TableHomeView
{
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return messageViewModel.filteredMessages.count
        }
        return messageViewModel == nil ? 0:messageViewModel.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessCell", for: indexPath) as! MessageCell
        let message: Message
        if searchController.isActive && searchController.searchBar.text != "" {
            message = messageViewModel.filteredMessages[indexPath.row]
        } else {
            message = messageViewModel.messages[indexPath.row]
        }
        setDataForCell(cell: cell, message: message)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageViewModel.tableView_heightForCell
    }
    func setDataForCell(cell: MessageCell, message: Message)
    {
        cell.content.text = message.content
        cell.date.text = message.date.description
        cell.name.text = message.name
        //        cell.profileImage = message.profileImagePath
    }
}
extension TableHomeView: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        messageViewModel.filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension TableHomeView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        let searchBar = searchController.searchBar
        messageViewModel.filterContentForSearchText(searchText: searchBar.text!)
    }
}

