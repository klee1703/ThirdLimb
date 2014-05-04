//
//  Sequence.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/29/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asana;

@interface Sequence : NSManagedObject

@property (nonatomic, retain) NSString * document;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *asanas;
@end

@interface Sequence (CoreDataGeneratedAccessors)

- (void)addAsanasObject:(Asana *)value;
- (void)removeAsanasObject:(Asana *)value;
- (void)addAsanas:(NSSet *)values;
- (void)removeAsanas:(NSSet *)values;

+ (instancetype)sequenceWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
