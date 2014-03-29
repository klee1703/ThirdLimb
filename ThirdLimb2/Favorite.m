//
//  Favorite.m
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "Favorite.h"
#import "Asana.h"


@implementation Favorite

@dynamic definition;
@dynamic name;
@dynamic asanas;

+ (instancetype)favoriteWithName:(NSString *)name definition:(NSString *)definition
                       inContext:(NSManagedObjectContext *)context {
  // Create favorite instance
  Favorite *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                                     inManagedObjectContext:context];
  // Set properties using parameters
  favorite.name = name;
  favorite.definition = definition;
  
  return favorite;
  
}

@end
