//
//  TLUtilities.m
//  ThirdLimb
//
//  Created by Keith Lee on 2/20/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLUtilities.h"

@implementation TLUtilities

#pragma mark -
+ (UIColor *)backgroundColor {
  return [UIColor colorWithPatternImage:[TLUtilities backgroundImage]];
}

+ (UIImage *)backgroundImage {
  return [UIImage imageNamed:@"BackgroundBeton.jpg"];
}

+ (UIFont *)navigationFont {
  return [UIFont fontWithName:@"Papyrus" size:30.0];
}


@end
