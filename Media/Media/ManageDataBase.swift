//
//  ManageDataBase.swift
//  Media
//
//  Created by Nguyen Van Tu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import CoreData
class ManageDataBase {
    //MARK: Local Variable
    var bookmarks = [NSManagedObject]()
    var managedContext: NSManagedObjectContext!
    //MARK: Shared Instance
    
    static let sharedInstance : ManageDataBase = {
        let instance = ManageDataBase()
        return instance
    }()
    //MARK: Init
    
    init() {
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMark")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            bookmarks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func removeObjectAt(index: Int)
    {
        if let bookmark =  bookmarks[index] as? NSManagedObject
        {
            managedContext.delete(bookmark)
            bookmarks.remove(at: index)
            try? managedContext.save()
        }
    }
    func saveName(title: String, url: String) {
        let entity =  NSEntityDescription.entity(forEntityName: "BookMark",
                                                 in:managedContext)
        
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        person.setValue(title, forKey: "title")
        person.setValue(url, forKey: "url")
        //4
        do {
            try managedContext.save()
            //5
            bookmarks.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
