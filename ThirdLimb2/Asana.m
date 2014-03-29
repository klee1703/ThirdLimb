//
//  Asana.m
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "Asana.h"
#import "AsanaType.h"
#import "Favorite.h"
#import "Sequence.h"


@implementation Asana

@dynamic document;
@dynamic image;
@dynamic name;
@dynamic notes;
@dynamic thumbnail;
@dynamic translation;
@dynamic asanaTypes;
@dynamic favorites;
@dynamic sequences;

+ (instancetype)asanaWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
  // Create asana instance
  Asana *asana = [NSEntityDescription insertNewObjectForEntityForName:@"Asana"
                                               inManagedObjectContext:context];
  // Set properties using plist
  asana.image = dictionary[@"image"];
  asana.name = dictionary[@"name"];
  asana.document = dictionary[@"document"];
  asana.thumbnail = dictionary[@"thumbnail"];
  asana.translation = dictionary[@"translation"];
  
  return asana;
}

@end
