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
    
    fileprivate override init(){
        let modelURL = Bundle.main.url(forResource: "QuestionsModel", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOf: modelURL)!
        
        let fileManager = FileManager.default
        
        
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last! as URL;
        
        let storeURL = docsURL.appendingPathComponent("base.sqlite")
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model);
        
        
        do{
            let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil);
            
        }catch{
            abort();
            
        }
        
        context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
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
