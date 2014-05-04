//
//  TLSequenceViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLDismissViewControllerDelegate.h"
#import "TLSequenceSelectDelegate.h"

#define kSequenceDocument   @"Sequences.html"

@interface TLSequenceViewController : UIViewController <UIWebViewDelegate, UITabBarDelegate, TLSequenceSelectDelegate>

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissViewControllerDelegate> delegate;

@property(strong, nonatomic) id<TLDismissViewControllerDelegate> rootViewController;

// IB properties
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *animateButton;
@property (weak, nonatomic) IBOutlet UIButton *animateButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

// CoreData properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property(nonatomic, strong) NSArray *sequences;
@property(nonatomic, strong) NSArray *sequencesPlist;

- (IBAction)animateSequence:(id)sender;

@end
