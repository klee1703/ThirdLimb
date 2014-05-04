//
//  TLSequenceSelectDelegate.h
//  ThirdLimb2
//
//  Created by Keith Lee on 5/1/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sequence.h"

@protocol TLSequenceSelectDelegate <NSObject>

- (void)didSelectSequenceAtRow:(NSUInteger)row;

@end
