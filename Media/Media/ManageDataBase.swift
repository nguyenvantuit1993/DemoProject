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
    var managedContext: NSManagedObjectContext!
    //MARK: Shared Instance
    
    static let sharedInstance : ManageDataBase = {
        let instance = ManageDataBase()
        return instance
    }()
    //MARK: Init
    
    init() {
        print(documentsPath)
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
    }
    func fetchEntity(name: String) -> [NSManagedObject]
    {
        var objects = [NSManagedObject]()
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            objects = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return objects
    }
    func removeObject(object: NSManagedObject)
    {
            managedContext.delete(object)
            try? managedContext.save()
    }
    func saveValue(values: [(value: Any, key: String)], entityName: String)
    {
        let entity =  NSEntityDescription.entity(forEntityName: entityName,
                                                 in:managedContext)
        
        let object = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        //3
        for value in values
        {
            object.setValue(value.value, forKey: value.key)
        }
        
        
        //4
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
