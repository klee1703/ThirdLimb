//
//  TLSequencesAnimationViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sequence.h"
#import "TLDismissAnimationViewDelegate.h"

@interface TLSequencesAnimationViewController : UIViewController

@property(nonatomic, strong) Sequence *sequence;
@property(nonatomic, strong) NSDictionary *sequencePlist;

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissAnimationViewDelegate> delegate;

@end
