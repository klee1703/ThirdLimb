//
//  TLWebViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 1/28/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLDismissViewControllerDelegate.h"

@interface TLWebViewController : UIViewController <UIWebViewDelegate, UITabBarDelegate>

@property (strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

// Delegate for dismissing view
@property (weak, nonatomic) id<TLDismissViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url;

@end
