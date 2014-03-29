//
//  Favorite.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asana;

@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *asanas;
@end

@interface Favorite (CoreDataGeneratedAccessors)

- (void)addAsanasObject:(Asana *)value;
- (void)removeAsanasObject:(Asana *)value;
- (void)addAsanas:(NSSet *)values;
- (void)removeAsanas:(NSSet *)values;

+ (instancetype)favoriteWithName:(NSString *)name definition:(NSString *)definition
                       inContext:(NSManagedObjectContext *)context;

@end
