//
//  TLFaqsViewController.m
//  ThirdLimb
//
//  Created by Keith Lee on 1/28/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLWebViewController.h"

@interface TLWebViewController()

@end

@implementation TLWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _url = url;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
	// Do any additional setup after loading the view.
  [self.webView setDelegate:self];
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
  [self.webView setScalesPageToFit:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
