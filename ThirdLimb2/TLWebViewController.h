//
//  TLWebViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 1/28/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLWebViewController : UIViewController <UIWebViewDelegate>

@property (strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url;

@end
