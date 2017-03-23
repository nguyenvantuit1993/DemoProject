//
//  BookMarkViewModel.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/2/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
class BookMarkViewModel {
    func settingsCell(cell: BookMarkCell, indexPath: IndexPath)
    {
        cell.lbl_Title.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "title") as? String
        cell.lbl_URL.text = BookMarkObjects.sharedInstance.bookmarks[indexPath.row].value(forKey: "url") as? String
    }
}
