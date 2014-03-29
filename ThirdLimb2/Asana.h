//
//  Asana.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AsanaType, Favorite, Sequence;

@interface Asana : NSManagedObject

@property (nonatomic, retain) NSString * document;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSSet *asanaTypes;
@property (nonatomic, retain) Favorite *favorites;
@property (nonatomic, retain) NSSet *sequences;
@end

@interface Asana (CoreDataGeneratedAccessors)

- (void)addAsanaTypesObject:(AsanaType *)value;
- (void)removeAsanaTypesObject:(AsanaType *)value;
- (void)addAsanaTypes:(NSSet *)values;
- (void)removeAsanaTypes:(NSSet *)values;

- (void)addSequencesObject:(Sequence *)value;
- (void)removeSequencesObject:(Sequence *)value;
- (void)addSequences:(NSSet *)values;
- (void)removeSequences:(NSSet *)values;

+ (instancetype)asanaWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
