//
//  Question+CoreDataProperties.h
//  Millionaire
//
//  Created by Igor Kasyanenko on 19.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *postedTime;
@property (nullable, nonatomic, retain) NSNumber *updatedTime;
@property (nullable, nonatomic, retain) NSNumber *level;
@property (nullable, nonatomic, retain) NSString *questionText;
@property (nullable, nonatomic, retain) NSString *answer1;
@property (nullable, nonatomic, retain) NSString *answer2;
@property (nullable, nonatomic, retain) NSString *answer3;
@property (nullable, nonatomic, retain) NSString *answer4;
@property (nullable, nonatomic, retain) NSNumber *trueAnswer;

@end

NS_ASSUME_NONNULL_END
