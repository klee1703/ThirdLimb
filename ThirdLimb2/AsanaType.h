//
//  AsanaType.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asana;

@interface AsanaType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *asanas;
@end

@interface AsanaType (CoreDataGeneratedAccessors)

- (void)addAsanasObject:(Asana *)value;
- (void)removeAsanasObject:(Asana *)value;
- (void)addAsanas:(NSSet *)values;
- (void)removeAsanas:(NSSet *)values;

+ (instancetype)asanaTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
