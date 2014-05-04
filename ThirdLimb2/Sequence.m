//
//  Sequence.m
//  ThirdLimb2
//
//  Created by Keith Lee on 4/29/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "Sequence.h"
#import "Asana.h"


@implementation Sequence

@dynamic document;
@dynamic name;
@dynamic notes;
@dynamic asanas;

+ (instancetype)sequenceWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
  // Create sequence instance
  Sequence *sequence = [NSEntityDescription insertNewObjectForEntityForName:@"Sequence"
                                               inManagedObjectContext:context];
  // Set properties using plist
  sequence.name = dictionary[@"name"];
  sequence.document = dictionary[@"document"];
  sequence.notes = dictionary[@"notes"];
  
  return sequence;
  
}

@end
