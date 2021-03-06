//
//  Question+CoreDataProperties.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 19.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var id: Int32
    @NSManaged var postedTime: Int64
    @NSManaged var updatedTime: Int64
    @NSManaged var level: Int32
    @NSManaged var questionText: String?
    @NSManaged var answer1: String?
    @NSManaged var answer2: String?
    @NSManaged var answer3: String?
    @NSManaged var answer4: String?
    @NSManaged var trueAnswer: Int16

}
