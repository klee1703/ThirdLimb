//
//  TLViewController.m
//  ThirdLimb2
//
//  Created by Keith Lee on 3/23/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLViewController.h"
#import "Asana.h"
#import "AsanaType.h"
#import "Favorite.h"
#import "TLAsanaThumbnailCell.h"
#import "TLAsanaDetailViewController.h"
#import "TLUtilities.h"
#import "TLAboutViewController.h"

@interface TLViewController ()

@property(strong, nonatomic) NSArray *currentAsanas;
@property(strong, nonatomic) NSArray *standing;
@property(strong, nonatomic) NSArray *seated;
@property(strong, nonatomic) NSArray *forwardBends;
@property(strong, nonatomic) NSArray *backbends;
@property(strong, nonatomic) NSArray *twists;
@property(strong, nonatomic) NSArray *inversions;
@property(strong, nonatomic) NSArray *supine;
@property(strong, nonatomic) NSArray *abdominals;
@property(strong, nonatomic) NSArray *restorative;
@property(strong, nonatomic) Favorite *favorite;
@property NSUInteger cellsPerRow;

@property BOOL editFavoritesEnabled;

@end


@implementation TLViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.viewLabel.backgroundColor = [UIColor colorWithPatternImage:[TLUtilities backgroundImage]];
  self.viewLabel.font = [TLUtilities navigationFont];
  
  // Load persistent data
  [self loadPersistentData];
  self.currentAsanas = self.asanas;
  
  // Set cells/row based on orientation
  UIInterfaceOrientation orientation = self.interfaceOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    self.cellsPerRow = kThumbnailCellsPerRow + 1;
  }
  else {
    self.cellsPerRow = kThumbnailCellsPerRow;
  }
  
  // Configure favorites button
  self.editFavorites.enabled = NO;
  self.editFavorites.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITabBarDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  // Initialize with favorites not displayed
  self.editFavorites.enabled = NO;
  self.editFavorites.hidden = YES;
  
  // Process based on tab bar item selection
  [self didSelectTabItem:item.tag];
}


#pragma mark -
#pragma mark Select delegate method
- (void)didSelectTabItem:(NSInteger)item {
  switch (item) {
    case kHomeTab:
    {
      // Current tab, just break
      self.titleLabel.text = kHomeTitle;
      self.currentAsanas = self.asanas;
      [self.collectionView reloadData];
      break;
    }
    case kAsanasTab:
    {
      // Display asanas view
      self.titleLabel.text = kAsanasTitle;
      self.currentAsanas = self.asanas;
      [self.collectionView reloadData];
      break;
    }
    case kSequencesTab:
    {
      // Display sequences view
      self.titleLabel.text = kSequencesTitle;
      self.currentAsanas = self.asanas;
      [self.collectionView reloadData];
      break;
    }
    case kFavoritesTab:
    {
      // Retrieve favorites (sorted alphabetically)
      NSSet *favoriteAsanas = [[self getFavorites] asanas];
      NSArray *objects = [favoriteAsanas allObjects];
      NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES];
      NSArray *sortedAsanas = [objects sortedArrayUsingDescriptors:
                               [NSArray arrayWithObject:sort]];
      self.currentAsanas = sortedAsanas;
      
      // Display favorites view
      self.titleLabel.text = kFavoritesTitle;
      self.editFavorites.enabled = YES;
      self.editFavorites.hidden = NO;
      [self.editFavorites setTitle:@"Edit" forState:UIControlStateNormal];
      [self.collectionView reloadData];
      break;
    }
    case kAboutTab:
    {
      // Display About view
      [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
      break;
    }
      
    default:
      break;
  }  
}

#pragma mark -
#pragma mark UIView methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  // Update cells/row based on orientation
  if ((fromInterfaceOrientation == UIInterfaceOrientationPortrait) ||
      (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
    self.cellsPerRow = kThumbnailCellsPerRow + 1;
  }
  else {
    self.cellsPerRow = kThumbnailCellsPerRow;
  }

  // Just update collection accordingly for a rotation
  [self.collectionView performBatchUpdates:nil completion:nil];
  [self.collectionView reloadData];
}


#pragma mark -
#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  Asana *asana = self.currentAsanas[indexPath.row];
  
  if (self.editFavoritesEnabled) {
    // Edit mode - remove the selected Asana from the favorites list
    [self.favorite removeAsanasObject:asana];
    
    // And save context
    NSError *error;
    BOOL isSaved = [self.managedObjectContext save:&error];
    if (!isSaved) {
      // Log error and abort
    }
    else {
      // Reload view
      NSSet *asanas = [self.favorite asanas];
      NSArray *objects = [asanas allObjects];
      NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES];
      NSArray *sortedAsanas = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
      self.asanas = sortedAsanas;
    }
  }
  else {
    // Perform segue
    [self performSegueWithIdentifier:@"AsanaDetailSegue"
                              sender:asana];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
  }
  
}


#pragma mark -
#pragma mark - UICollectionView Datasource methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
  return [self.currentAsanas count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  // Create/retrieve cell
  TLAsanaThumbnailCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AsanasCell" forIndexPath:indexPath];
  
  // Always initialize cell with remove Asana image hidden!
  cell.removeAsana.hidden = YES;
  
  // Set thumbnail for cell
  Asana *asana = self.currentAsanas[indexPath.row];
  //  UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[asana thumbnail]]];
  UIImageView *view = (UIImageView *)[cell viewWithTag:100];
  view.image = [UIImage imageNamed:[asana thumbnail]];
  //cell.imageView.image = [UIImage imageNamed:[asana thumbnail]];
  //[cell addSubview:cell.imageView];
  
  // Set name for cell
  //  UILabel
  UILabel *asanaName = (UILabel *)[cell viewWithTag:50];
  asanaName.text = [asana name];
  //  cell.asanaName.text = [asana name];
  //[cell addSubview:cell.asanaName];
  
  // If in Favorites edit mode, display remove asana image
  if (self.editFavoritesEnabled) {
    cell.removeAsana.hidden = NO;
  }
  else {
    cell.removeAsana.hidden = YES;
  }
  
  return cell;
}


#pragma mark -
#pragma mark – UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGRect bounds = [collectionView bounds];
  //  NSInteger side = (int)(bounds.size.width / kThumbnailCellsPerRow);
  CGFloat side = (float)(bounds.size.width / self.cellsPerRow);
  CGSize retval = CGSizeMake(side - kThumbnailSpacing, side - kThumbnailSpacing);
  
  return retval;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  
  return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  
  return 2.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);    // top, left, bottom, right
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
  return CGSizeMake(0, 0);
  //  return CGSizeMake(1, -63);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
  return CGSizeMake(0, 0);
}


#pragma mark -
#pragma mark - Segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"AsanaDetailSegue"]) {
    UINavigationController *controller =
    (UINavigationController *)segue.destinationViewController;
    TLAsanaDetailViewController *viewController = [controller viewControllers][0];
    viewController.asana = sender;
    viewController.asanaName = [sender name];
    viewController.translation = [sender translation];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.favoriteAsanas = [[self getFavorites] asanas];
    //    viewController.favoriteAsanas = [self.favorite asanas];
    viewController.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"AboutSegue"]) {
    UINavigationController *controller =
    (UINavigationController *)segue.destinationViewController;
    TLAboutViewController *viewController = [controller viewControllers][0];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.managedObjectModel = self.managedObjectModel;
    viewController.delegate = self;
  }
}




#pragma mark -
#pragma mark Delegate method
- (void)dismissViewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma Favorites methods

- (IBAction)favoritesButtonTouched:(id)sender {
  self.editFavoritesEnabled = !self.editFavoritesEnabled;
  
  if (self.editFavoritesEnabled) {
    [self.editFavorites setTitle:@"Done" forState:UIControlStateNormal];
    [self.collectionView reloadData];
  }
  else {
    [self.editFavorites setTitle:@"Edit" forState:UIControlStateNormal];
    [self.collectionView reloadData];
  }
}


#pragma mark -
#pragma Persistent store initization methods

- (void)loadPersistentData {
  // Load Asana entities from persistent store
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Asana"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [fetchRequest setSortDescriptors:@[sortByName]];
  NSArray *asanas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  if ([asanas count] > 0) {
    // Load asanas
    self.asanas = asanas;
  }
  else {
    // Create/retrieve asana types
    NSDictionary *dictionary = [self getAsanaTypes];
    NSMutableArray *asanas = [NSMutableArray new];
    
    // Create asanas from bundle data and persist in persistent store
    NSArray *asanasPlist = [self createAsanasFromPList];
    for (NSDictionary *asanaPlist in asanasPlist) {
      // Create asana instance using plist
      Asana *asana = [Asana asanaWithDictionary:asanaPlist inContext:self.managedObjectContext];
      
      // Set asana type(s)
      NSArray *asanaTypesPlist = [asanaPlist valueForKey:@"asanaTypes"];
      
      for (NSString *asanaTypeName in asanaTypesPlist) {
        AsanaType *asanaType = dictionary[asanaTypeName];
        [asana addAsanaTypesObject:asanaType];
      }
      
      // Add asana to collection
      [asanas addObject:asana];
    }
    
    // Create/retrieve favorite instance
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *favorites = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([favorites count] <= 0) {
      // Favorite entity not created yet, create now!
      [Favorite favoriteWithName:@"Favorites"
                      definition:@"Favorite Asanas"
                       inContext:self.managedObjectContext];
    }
    
    // And save the context
    NSError *error = nil;
    BOOL isSaved = [self.managedObjectContext save:&error];
    if (isSaved) {
      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
      NSEntityDescription *entity = [NSEntityDescription entityForName:@"Asana"
                                                inManagedObjectContext:self.managedObjectContext];
      [fetchRequest setEntity:entity];
      NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
      [fetchRequest setSortDescriptors:@[sortByName]];
      NSArray *asanas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
      self.asanas = asanas;
    }
    else {
      // Log error and abort
    }
  }
}

- (NSArray *)createAsanasFromPList {
  // First retrieve data from bundle
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *plistURL = [bundle URLForResource:@"Asanas" withExtension:@"plist"];
  return [NSArray arrayWithContentsOfURL:plistURL];
}

- (NSDictionary *)getAsanaTypes {
  // Load Asana entities from persistent store
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"AsanaType"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSArray *asanaTypes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  if ([asanaTypes count] > 0) {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (AsanaType *asanaType in asanaTypes) {
      [dictionary setObject:asanaType forKey:asanaType.name];
    }
    return dictionary;
  }
  else {
    // Create asana types
    AsanaType *standing = [AsanaType asanaTypeWithName:kMenuStanding inContext:self.managedObjectContext];
    AsanaType *seated = [AsanaType asanaTypeWithName:kMenuSeated inContext:self.managedObjectContext];
    AsanaType *forward = [AsanaType asanaTypeWithName:kMenuForward inContext:self.managedObjectContext];
    AsanaType *backbends = [AsanaType asanaTypeWithName:kMenuBackbends inContext:self.managedObjectContext];
    AsanaType *twists = [AsanaType asanaTypeWithName:kMenuTwists inContext:self.managedObjectContext];
    AsanaType *inversions = [AsanaType asanaTypeWithName:kMenuInversions inContext:self.managedObjectContext];
    AsanaType *supine = [AsanaType asanaTypeWithName:kMenuSupine inContext:self.managedObjectContext];
    AsanaType *abdominals = [AsanaType asanaTypeWithName:kMenuAbdominals inContext:self.managedObjectContext];
    AsanaType *restorative = [AsanaType asanaTypeWithName:kMenuRestorative inContext:self.managedObjectContext];
    AsanaType *other = [AsanaType asanaTypeWithName:kMenuOther inContext:self.managedObjectContext];
    
    // Save the context
    NSError *error;
    BOOL isSaved = [self.managedObjectContext save:&error];
    if (!isSaved) {
      // Log error and abort
    }
    
    return @{kMenuStanding:standing, kMenuSeated:seated, kMenuForward:forward, kMenuBackbends:backbends,
             kMenuTwists:twists, kMenuInversions:inversions, kMenuSupine:supine, kMenuAbdominals:abdominals,
             kMenuRestorative:restorative, kMenuOther:other};
  }
}


- (Favorite *) getFavorites {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSArray *favorites = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  
  return favorites[0];
}


@end
