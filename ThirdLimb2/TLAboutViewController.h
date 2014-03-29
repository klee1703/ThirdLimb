//
//  TLAboutViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 1/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TLAboutViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
