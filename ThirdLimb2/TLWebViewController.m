//
//  TLFaqsViewController.m
//  ThirdLimb
//
//  Created by Keith Lee on 1/28/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLWebViewController.h"
#import "TLUtilities.h"
#import "TLViewController.h"

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
  UINavigationController *navController =
  (UINavigationController *)self.navigationController;
  
  // Set the font for the navigation bar
  [navController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[TLUtilities navigationFont]}];
  [navController.navigationBar setBackgroundImage:[TLUtilities backgroundImage]
                                    forBarMetrics:UIBarMetricsDefault];

  [self.webView setDelegate:self];
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
  [self.webView setScalesPageToFit:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITabBarDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  // Process based on tab bar item selection
  tabBar.selectedItem = item;
  switch (item.tag) {
    case kAsanasTab:
    {
      // Display asanas view
      [self.delegate didSelectTabItem:item.tag];
      break;
    }
    case kSequencesTab:
    {
      // Display sequences view
      [self.delegate didSelectTabItem:item.tag];
      break;
    }
    case kFavoritesTab:
    {
      [self.delegate didSelectTabItem:item.tag];
      break;
    }
    case kAboutTab:
      // Current view, just break
      break;
      
    default:
      break;
  }
}

@end
