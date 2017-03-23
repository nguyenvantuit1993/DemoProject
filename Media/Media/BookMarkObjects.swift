//
//  BookMarkObjects.swift
//  Media
//
//  Created by Tuuu on 2/27/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import CoreData

class BookMarkObjects{
    var bookmarks = [NSManagedObject]()
    static let sharedInstance : BookMarkObjects = {
        let instance = BookMarkObjects()
        return instance
    }()
    init() {
        getData()
    }
    func getData()
    {
        bookmarks = ManageDataBase.sharedInstance.fetchEntity(name: "BookMark")
    }
    func removeObject(index: Int)
    {
        ManageDataBase.sharedInstance.removeObject(object: bookmarks[index])
        BookMarkObjects.sharedInstance.bookmarks.remove(at: index)
    }
    func saveBookmark(title: String, url: String) {
        let managedContext = ManageDataBase.sharedInstance.managedContext
        let entity =  NSEntityDescription.entity(forEntityName: "BookMark",
                                                 in:managedContext!)
        
        let bookmark = NSManagedObject(entity: entity!,
                                     insertInto: managedContext) as! BookMark
        
        //3
        bookmark.title = title
        bookmark.url = url
        //4
        do {
            try managedContext?.save()
            //5
            bookmarks.append(bookmark)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
