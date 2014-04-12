//
//  TLAsanasTableViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/6/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAsanasCategorySelectDelegate.h"


typedef NS_ENUM( NSUInteger, AsanaItem ) {
  StandingPoses = 0,
  SeatedPoses,
  ForwardBends,
  Backbends,
  Twists,
  Inversions,
  SupinePoses,
  Abdominals,
  Restorative
};

@interface TLAsanasTableViewController : UITableViewController

// Delegate for selecting asana category
@property (weak, nonatomic) id<TLAsanasCategorySelectDelegate> delegate;

@end
