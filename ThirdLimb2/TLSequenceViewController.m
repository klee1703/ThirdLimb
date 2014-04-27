//
//  TLSequenceViewController.m
//  ThirdLimb2
//
//  Created by Keith Lee on 4/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLSequenceViewController.h"
#import "TLUtilities.h"
#import "TLViewController.h"
#import "TLAboutViewController.h"
#import "TLSequencesAnimationViewController.h"

@interface TLSequenceViewController ()

@end

@implementation TLSequenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
	// Do any additional setup after loading the view.
  UINavigationController *navController =
  (UINavigationController *)self.navigationController;
  
  // Set the font for the navigation bar
  [navController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[TLUtilities navigationFont]}];
  [navController.navigationBar setBackgroundImage:[TLUtilities backgroundImage]
                                    forBarMetrics:UIBarMetricsDefault];
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
      [self.delegate dismissViewController];
      [self.delegate didSelectTabItem:item.tag];
      break;
    }
    case kSequencesTab:
    {
      // Current view, just break
      break;
    }
    case kFavoritesTab:
    {
      [self.delegate dismissViewController];
      [self.delegate didSelectTabItem:item.tag];
      break;
    }
    case kAboutTab:
      // Display About view
      [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
      break;
      
    default:
      break;
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"AboutSegue"]) {
    UINavigationController *controller =
    (UINavigationController *)segue.destinationViewController;
    TLAboutViewController *viewController = [controller viewControllers][0];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.managedObjectModel = self.managedObjectModel;
    viewController.delegate = self.delegate;
  }
  else if ([segue.identifier isEqualToString:@"AnimationSegue"]) {
    //    TLSequencesAnimationViewController *controller =
    //(TLSequencesAnimationViewController *)segue.destinationViewController;
    
    // Retrieve popover controller for programmatic dismissal
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
    self.sequencesPopoverController = popoverSegue.popoverController;
  }
}


- (IBAction)animateSequence:(id)sender {
  if (self.sequencesPopoverController != nil){
    [self.sequencesPopoverController dismissPopoverAnimated:YES];
    self.sequencesPopoverController = nil;
  }
}
@end
