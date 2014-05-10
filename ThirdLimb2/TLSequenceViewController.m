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
#import "TLSequencesTableViewController.h"
#import "Sequence.h"

@interface TLSequenceViewController ()
@property (strong, nonatomic) UIPopoverController *animationPopoverController;
@property (strong, nonatomic) UIPopoverController *sequencesPopoverController;
@property(strong, nonatomic) Sequence *currentSequence;
@property(strong, nonatomic) NSDictionary *currentSequencePlist;
@property(strong, nonatomic) NSString *indexFileURL;
@property BOOL isDisplayingSequencePage;

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
  NSArray *items = self.tabBar.items;
  UITabBarItem *barItem = (UITabBarItem *)items[kSequencesTab];
  [self.tabBar setSelectedItem:barItem];

  UINavigationController *navController =
  (UINavigationController *)self.navigationController;
  
  // Set the font for the navigation bar
  [navController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[TLUtilities navigationFont]}];
  [navController.navigationBar setBackgroundImage:[TLUtilities backgroundImage]
                                    forBarMetrics:UIBarMetricsDefault];

  // Disable animate button
  self.animateButton.enabled = NO;
  self.animateButton.hidden = YES;
  
  // Load web view
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *indexFileURL = [bundle URLForResource:kSequenceDocument withExtension:nil];
  [self.webView setDelegate:self];
  [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
  [self.webView setScalesPageToFit:YES];
  self.isDisplayingSequencePage = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (NSArray *)sequences {
  // Load Sequence entities from persistent store
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sequence"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}
*/

#pragma mark -
#pragma mark UITabBarDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  // Process based on tab bar item selection
  tabBar.selectedItem = item;
  switch (item.tag) {
    case kAsanasTab:
    {
      // Display asanas view
      [self.delegate dismissViewController:item.tag];
      break;
    }
    case kSequencesTab:
    {
      // Current view, just break
      if (!self.isDisplayingSequencePage) {
        [self displaySequencePage];
      }
      break;
    }
    case kFavoritesTab:
    {
      [self.delegate dismissViewController:item.tag];
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
    viewController.sequencesPlist = self.sequencesPlist;
    viewController.sequences = self.sequences;
  }
  else if ([segue.identifier isEqualToString:@"AnimationSegue"]) {
    TLSequencesAnimationViewController *controller =
    (TLSequencesAnimationViewController *)segue.destinationViewController;
    controller.sequence = self.currentSequence;
    controller.sequencePlist = self.currentSequencePlist;
    controller.delegate = self;
    
    // Retrieve popover controller for programmatic dismissal
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
    self.animationPopoverController = popoverSegue.popoverController;
  }
  else if ([segue.identifier isEqualToString:@"SequencesTableSegue"]) {
    TLSequencesTableViewController *controller =
    (TLSequencesTableViewController *)segue.destinationViewController;
    controller.sequences = self.sequences;
    controller.delegate = self;
    
    // Retrieve popover controller for programmatic dismissal
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
    self.sequencesPopoverController = popoverSegue.popoverController;
  }
}


- (IBAction)animateSequence:(id)sender {
  if (self.animationPopoverController != nil){
    [self.animationPopoverController dismissPopoverAnimated:YES];
    self.animationPopoverController = nil;
  }
}


#pragma mark - 
#pragma mark SequenceSelectDelegate methods
- (void)didSelectSequenceAtRow:(NSUInteger)row {
  // Set current sequence
  self.currentSequence = self.sequences[row];
  self.currentSequencePlist = self.sequencesPlist[row];
  
  // Display sequence page in web view
  [self loadSequenceView:self.currentSequence.document];

  // Enable/disable button display
  if (self.currentSequence.asanas.count > 0) {
    self.animateButton.enabled = YES;
    self.animateButton.hidden = NO;
    
    // Display new nav bar title
    [self.navigationItem setTitle:self.currentSequence.name];
  }
  else {
    self.animateButton.enabled = NO;
    self.animateButton.hidden = YES;
    
    // Display new nav bar title
    [self.navigationItem setTitle:@"Sequences"];
  }
  
  if (self.sequencesPopoverController != nil){
    [self.sequencesPopoverController dismissPopoverAnimated:YES];
    self.sequencesPopoverController = nil;
  }
  
}


#pragma mark -
#pragma mark TLDismissAnimationViewDelegate methods
-(void) dismissAnimationViewController {
  [self.animationPopoverController dismissPopoverAnimated:YES];
  self.animationPopoverController = nil;
}


-(void)loadSequenceView:(NSString *)document {
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *indexFileURL = [bundle URLForResource:document withExtension:nil];
  if (indexFileURL == nil) {
    indexFileURL = [bundle URLForResource:kSequenceDocument withExtension:nil];
  }
  [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
  [self.webView setScalesPageToFit:YES];
  self.isDisplayingSequencePage = NO;
}


- (void)displaySequencePage {
  // Disable animate button
  self.animateButton.enabled = NO;
  self.animateButton.hidden = YES;
  
  // Load web view
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *indexFileURL = [bundle URLForResource:kSequenceDocument withExtension:nil];
  [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
  [self.webView setScalesPageToFit:YES];
}
@end
