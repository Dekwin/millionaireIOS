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
    
    
    
    
//    let entity = NSEntityDescription.entityForName("Car", inManagedObjectContext: context)
//    let car = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
//    car.setValue("Ferrari", forKey: “name”)
//
//  //  We can generate NSManagedObject subclass for our entity in that case the code will be like this
//    
//    
//    let entity = NSEntityDescription.entityForName("Car", inManagedObjectContext: context)
//    let car = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context) as! Car
//    car.name = “Ferrari"

    
    
    class var entit: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: className, in: CoreDataHelper.instance.context)!
    }
    
    convenience init(){
        self.init(entity: Question.entit, insertInto: CoreDataHelper.instance.context)
    }
    
   // convenience init(id: Int32,postedTime: Int64,updatedTime: Int64,level: Int32,
   //      questionText: String?,answer1: String?,answer2: String?,answer3: String?,answer4: String?,trueAnswer: Int16){
   // }
  

    
// Insert code here to add functionality to your managed object subclass
    class func getAll() -> [Question]{
        let request: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: Question.className)
        do{
            let result = try CoreDataHelper.instance.context.fetch(request)
            return result as! [Question]
        }catch{
            return [Question]()
        }
        
    }
    
    class func getAll(_ predicate: NSPredicate) -> [Question]{
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Question.className)
        request.predicate = predicate;
        do{
            let result = try CoreDataHelper.instance.context.fetch(request)
            return result as! [Question]
        }catch{
            return [Question]()
        }
    }
    
    
    class func deleteAll(){
        let fRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: Question.className)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fRequest)
        do{
            try CoreDataHelper.instance.coordinator.execute(deleteRequest, with: CoreDataHelper.instance.context);
        }catch let error as NSError {
            debugPrint(error)
        }
    }

}
