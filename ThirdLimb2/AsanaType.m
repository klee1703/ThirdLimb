//
//  AsanaType.m
//  ThirdLimb2
//
//  Created by Keith Lee on 3/24/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "AsanaType.h"
#import "Asana.h"


@implementation AsanaType

@dynamic name;
@dynamic asanas;

+ (instancetype)asanaTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
  // Create asana type instance
  AsanaType *asanaType = [NSEntityDescription insertNewObjectForEntityForName:@"AsanaType"
                                                       inManagedObjectContext:context];
  // Set properties using plist
  asanaType.name = name;
  
  return asanaType;
}

@end
