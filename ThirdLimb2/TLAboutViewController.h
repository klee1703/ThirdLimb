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

@interface TLAboutViewController : UIViewController <UITabBarDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

// CoreData properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissViewControllerDelegate> delegate;

@end
