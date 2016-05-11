//
//  CoreDataHelper.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 19.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject {
    
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
            
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    private override init(){
        let modelURL = NSBundle.mainBundle().URLForResource("QuestionsModel", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        
        
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL;
        
        let storeURL = docsURL.URLByAppendingPathComponent("base.sqlite")
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model);
        
        
        do{
            let store = try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil);
            
        }catch{
            abort();
            
        }
        
        context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator;
        super.init()
        
    }
    
    func save(){
        
        do{
            try context.save()
        }catch{
            
        }
    }
    
}