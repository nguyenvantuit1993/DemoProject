//
//  BookMarkViewModel.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/2/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
class BookMarkViewModel {
    func settingsCell(cell: UITableViewCell, indexPath: IndexPath)
    {
        cell.textLabel?.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "title") as? String
        cell.detailTextLabel?.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "url") as? String
    }
}
