//
//  TLAsanaDetailViewController.m
//  ThirdLimb
//
//  Created by Keith Lee on 1/8/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLAsanaDetailViewController.h"
#import "TLNotesViewController.h"
#import "Favorite.h"

@interface TLAsanaDetailViewController ()

@end

@implementation TLAsanaDetailViewController

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
  //  self.window.rootViewController.navigationItem
  [self.navigationItem setTitle:self.asanaName];
  [self.detailWebView setDelegate:self];
  self.asanaTranslation.text = [NSString stringWithFormat:@"%@%@%@", @"(", self.translation, @")"];
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *indexFileURL = [bundle URLForResource:@"Detail" withExtension:@"html"];
  [self.detailWebView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
  [self.detailWebView setScalesPageToFit:YES];
  
  // Hide favorites button asana already in favorites list
  if ([self.favoriteAsanas containsObject:self.asana]) {
    self.favoritesButton.hidden = YES;
    self.favoritesButton.enabled = NO;
  }
  else {
    self.favoritesButton.hidden = NO;
    self.favoritesButton.enabled = YES;
  }
  //  [self.detailWebView updateConstraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Button action methods

- (IBAction)notesPopover:(id)sender {
  if (self.notesPopoverController == nil){
    [self performSegueWithIdentifier:@"NotesSegue" sender:self];
  }
  else {
    [_notesPopoverController dismissPopoverAnimated:YES];
    self.notesPopoverController = nil;
  }
}

- (IBAction)addToFavorites:(id)sender {
  NSString *title = [NSString stringWithFormat:@"Add %@ %@", self.asanaName, kAddAsanaToFavoritesTitle];
  UIActionSheet *selectAction = [[UIActionSheet alloc]
                                 initWithTitle:title
                                 delegate:self
                                 cancelButtonTitle:@"No"
                                 destructiveButtonTitle:@"Yes"
                                 otherButtonTitles:nil];
  [selectAction showInView:self.view];
}

#pragma mark -
#pragma mark Segue methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [self.notesPopoverController setPopoverContentSize:CGSizeMake(540, 620) animated:YES];
  TLNotesViewController *controller = (TLNotesViewController *)segue.destinationViewController;
  controller.asana = self.asana;
  controller.managedObjectContext = self.managedObjectContext;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
  // If button confirmed perform logic
  if (!buttonIndex) {
    // Retrieve favorite
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *favorites = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

    // Check if Asana already in collection
    NSSet *asanas = [favorites[0] asanas];
    if (![asanas containsObject:self.asana]) {      
      // Add asana to favorite collection
      [favorites[0] addAsanasObject:self.asana];
      
      // And save context
      NSError *error;
      BOOL isSaved = [self.managedObjectContext save:&error];
      if (!isSaved) {
        // Log error and abort
      }
    }
  }
}

@end
