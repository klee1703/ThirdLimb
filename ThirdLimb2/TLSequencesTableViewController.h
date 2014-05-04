//
//  TLSequencesTableViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/30/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSequenceSelectDelegate.h"

@interface TLSequencesTableViewController : UITableViewController

@property(nonatomic, strong) NSArray *sequences;

// Delegate for selecting asana category
@property (weak, nonatomic) id<TLSequenceSelectDelegate> delegate;

@end
