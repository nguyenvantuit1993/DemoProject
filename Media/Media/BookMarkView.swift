//
//  BookMarkView.swift
//  Media
//
//  Created by Nguyen Van Tu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class BookMarkView: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookMarkObjects.sharedInstance.bookmarks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "title") as? String
        cell.detailTextLabel?.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "url") as? String
        return cell
    }
    
}
