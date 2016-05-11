//
//  Question.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 19.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import CoreData

@objc(Question)
class Question: NSManagedObject {
    
    static let className = "Question";
    
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName(className, inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init(){
        self.init(entity: Question.entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
    
   // convenience init(id: Int32,postedTime: Int64,updatedTime: Int64,level: Int32,
   //      questionText: String?,answer1: String?,answer2: String?,answer3: String?,answer4: String?,trueAnswer: Int16){
   // }
    
// Insert code here to add functionality to your managed object subclass
    class func getAll() -> [Question]{
        let request = NSFetchRequest(entityName: Question.className)
        do{
            let result = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return result as! [Question]
        }catch{
            return [Question]()
        }
        
    }
    
    class func getAll(predicate: NSPredicate) -> [Question]{
        let request = NSFetchRequest(entityName: Question.className)
        request.predicate = predicate;
        do{
            let result = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return result as! [Question]
        }catch{
            return [Question]()
        }
    }
    
    
    class func deleteAll(){
        let fRequest = NSFetchRequest(entityName: Question.className)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fRequest)
        do{
            try CoreDataHelper.instance.coordinator.executeRequest(deleteRequest, withContext: CoreDataHelper.instance.context);
        }catch let error as NSError {
            debugPrint(error)
        }
    }

}
