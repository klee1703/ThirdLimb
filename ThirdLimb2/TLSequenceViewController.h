//
//  TLSequenceViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLDismissViewControllerDelegate.h"

@interface TLSequenceViewController : UIViewController <UITabBarDelegate>

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissViewControllerDelegate> delegate;

@property(strong, nonatomic) id<TLDismissViewControllerDelegate> rootViewController;

// CoreData properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
