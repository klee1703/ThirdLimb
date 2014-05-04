//
//  TLAboutViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 1/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TLDismissViewControllerDelegate.h"
#import "TLAsanasCategorySelectDelegate.h"

@interface TLAboutViewController : UIViewController <UITabBarDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

// CoreData properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property(nonatomic, strong) NSArray *sequences;
@property(nonatomic, strong) NSArray *sequencesPlist;

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissViewControllerDelegate> delegate;

@end
