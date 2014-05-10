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
#import "Sequence.h"
#import "TLAsanaThumbnailCell.h"
#import "TLAsanaDetailViewController.h"
#import "TLUtilities.h"
#import "TLAboutViewController.h"
#import "TLAsanasTableViewController.h"
#import "TLSequenceViewController.h"

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
  
  // Configure types button
  self.asanaTypes.enabled = YES;
  self.asanaTypes.hidden = NO;
  
  // Add observer for notification
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationWillEnterForeground:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
  // Set cells/row based on orientation
  UIInterfaceOrientation orientation = self.interfaceOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation)) {
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
  // Display tab bar item
  NSArray *items = self.tabBar.items;
  UITabBarItem *barItem = (UITabBarItem *)items[item];
  [self.tabBar setSelectedItem:barItem];
  
  // Process selection
  switch (item) {
    case kAsanasTab:
    {
      // Configure types button
      self.asanaTypes.enabled = YES;
      self.asanaTypes.hidden = NO;
      
      // Display asanas view
      self.titleLabel.text = kAsanasTitle;
      self.currentAsanas = self.asanas;
      [self.collectionView reloadData];
      break;
    }
    case kSequencesTab:
    {
      // Display Sequences view
      [self performSegueWithIdentifier:@"SequencesSegue" sender:nil];
      break;
    }
    case kFavoritesTab:
    {
      // Configure types button
      self.asanaTypes.enabled = NO;
      self.asanaTypes.hidden = YES;
      
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

- (void)selectTabItem:(NSInteger)item {
  NSArray *items = self.tabBar.items;
  UITabBarItem *barItem = (UITabBarItem *)items[item];
  [self.tabBar setSelectedItem:barItem];
  self.titleLabel.text = kAsanasTitle;
  self.currentAsanas = self.asanas;
  [self.collectionView reloadData];
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
    TLAsanaDetailViewController *viewController = segue.destinationViewController;
    viewController.asana = sender;
    viewController.asanaName = [sender name];
    viewController.translation = [sender translation];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.managedObjectModel = self.managedObjectModel;
    viewController.favoriteAsanas = [[self getFavorites] asanas];
    viewController.delegate = self;
    viewController.sequences = self.sequences;
    viewController.sequencesPlist = self.sequencesPlist;
  }
  else if ([segue.identifier isEqualToString:@"AboutSegue"]) {
    UINavigationController *controller =
    (UINavigationController *)segue.destinationViewController;
    TLAboutViewController *viewController = [controller viewControllers][0];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.managedObjectModel = self.managedObjectModel;
    viewController.delegate = self;
    viewController.sequences = self.sequences;
    viewController.sequencesPlist = self.sequencesPlist;
  }
  else if ([segue.identifier isEqualToString:@"SequencesSegue"]) {
    UINavigationController *controller =
    (UINavigationController *)segue.destinationViewController;
    TLSequenceViewController *viewController = [controller viewControllers][0];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.managedObjectModel = self.managedObjectModel;
    viewController.delegate = self;
    viewController.sequences = self.sequences;
    viewController.sequencesPlist = self.sequencesPlist;
  }
  else if ([segue.identifier isEqualToString:@"AsanasSegue"]) {
    TLAsanasTableViewController *controller =
    (TLAsanasTableViewController *)segue.destinationViewController;
    controller.delegate = self;
    
    // Retrieve popover controller for programmatic dismissal
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
    self.asanasPopoverController = popoverSegue.popoverController;
  }
}


#pragma mark -
#pragma mark Delegate method
- (void)dismissViewController:(NSInteger)itemTag {
  [self dismissViewControllerAnimated:NO
                           completion:^{
                             [self didSelectTabItem:itemTag];
                           }];
}


#pragma mark -
#pragma Button methods

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

- (IBAction)asanaTypesButtonTouched:(id)sender {
  if (self.asanasPopoverController != nil){
    [self.asanasPopoverController dismissPopoverAnimated:YES];
    self.asanasPopoverController = nil;
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

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sequence"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *unsorted = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:nil];
    self.sequencesPlist = [self createSequencesFromPList];
    self.sequences = [self sortedSequences:unsorted fromPlist:self.sequencesPlist];
  }
  else {
    // Create/retrieve asana types
    NSDictionary *dictionary = [self getAsanaTypes];
    NSMutableArray *asanas = [NSMutableArray new];
    NSMutableArray *sequences = [NSMutableArray new];
    
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
    
    // Create sequences from bundle data and persist in persistent store
    NSDictionary *asanasDictionary = [self getDictionaryFromAsanas:asanas];
    NSArray *sequencesPlist = [self createSequencesFromPList];
    for (NSDictionary *sequencePlist in sequencesPlist) {
      // Create sequence instance using plist
      Sequence *sequence = [Sequence sequenceWithDictionary:sequencePlist inContext:self.managedObjectContext];
      
      // Add asana instances using plist
      NSArray *asanaNamesPlist = [sequencePlist valueForKey:@"asanas"];
      for (NSString *asanaName in asanaNamesPlist) {
        Asana *asana = [asanasDictionary objectForKey:asanaName];
        [sequence addAsanasObject:asana];
      }
      
      // Add sequence to collection
      [sequences addObject:sequence];
    }
    self.sequencesPlist = sequencesPlist;
    self.sequences = sequences;
    
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

  /* Sort sequences according to order in property list */
- (NSArray *)sortedSequences:(NSArray *)unsorted fromPlist:(NSArray *)plist {
  NSMutableArray *sequences = [NSMutableArray new];
  for (NSDictionary *sequencePlist in plist) {
    NSString *name = sequencePlist[@"name"];
    for (Sequence *sequence in unsorted) {
      if ([name caseInsensitiveCompare:sequence.name] == NSOrderedSame) {
        [sequences addObject:sequence];
      }
    }
  }
  return sequences;
}

- (NSArray *)createAsanasFromPList {
  // First retrieve data from bundle
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *plistURL = [bundle URLForResource:@"Asanas" withExtension:@"plist"];
  return [NSArray arrayWithContentsOfURL:plistURL];
}

- (NSArray *)createSequencesFromPList {
  // First retrieve data from bundle
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *plistURL = [bundle URLForResource:@"Sequences" withExtension:@"plist"];
  return [NSArray arrayWithContentsOfURL:plistURL];
}

- (NSDictionary *)getDictionaryFromAsanas:(NSArray *)asanas {
  NSMutableDictionary *dictionary = [NSMutableDictionary new];
  for (Asana *asana in asanas) {
    [dictionary setObject:asana forKey:asana.name];
  }
  return dictionary;
  
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


#pragma mark -
#pragma mark Asana sorting methods

- (NSFetchRequest *)getFetchRequest {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Asana"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  return fetchRequest;
}

- (NSArray *)standing {
  if (_standing == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuStanding];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _standing = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _standing;
}

- (NSArray *)seated {
  if (_seated == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuSeated];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _seated = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _seated;
}

- (NSArray *)forwardBends {
  if (_forwardBends == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuForward];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _forwardBends = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _forwardBends;
}

- (NSArray *)backbends {
  if (_backbends == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuBackbends];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _backbends = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _backbends;
}

- (NSArray *)twists {
  if (_twists == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuTwists];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _twists = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _twists;
}

- (NSArray *)inversions {
  if (_inversions == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuInversions];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _inversions = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _inversions;
}

- (NSArray *)supine {
  if (_supine == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *standingPredicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuSupine];
    [fetchRequest setPredicate:standingPredicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _supine = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _supine;
}

- (NSArray *)abdominals {
  if (_abdominals == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *standingPredicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuAbdominals];
    [fetchRequest setPredicate:standingPredicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _abdominals = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _abdominals;
}

- (NSArray *)restorative {
  if (_restorative == nil) {
    // Load Asana entities from persistent store
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *standingPredicate = [NSPredicate predicateWithFormat:@"ANY asanaTypes.name == %@", kMenuRestorative];
    [fetchRequest setPredicate:standingPredicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    _restorative = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
  }
  
  return _restorative;
}


#pragma mark -
#pragma mark Asana category delegate methods

/**
 * Execute logic according to selected category
 */
- (void)didSelectAsanaCategory:(NSInteger)category
{
  // Perform operation based on category selected
  switch (category) {
    case StandingPoses:
    {
      self.titleLabel.text = kMenuStanding;
      self.currentAsanas = self.standing;
      [self.collectionView reloadData];
      break;
    }
    case ForwardBends:
    {
      self.titleLabel.text = kMenuForward;
      self.currentAsanas = self.forwardBends;
      [self.collectionView reloadData];
      break;
    }
    case Twists:
    {
      self.titleLabel.text = kMenuTwists;
      self.currentAsanas = self.twists;
      [self.collectionView reloadData];
      break;
    }
    case Inversions:
    {
      self.titleLabel.text = kMenuInversions;
      self.currentAsanas = self.inversions;
      [self.collectionView reloadData];
      break;
    }
    case SeatedPoses:
    {
      self.titleLabel.text = kMenuSeated;
      self.currentAsanas = self.seated;
      [self.collectionView reloadData];
      break;
    }
    case SupinePoses:
    {
      self.titleLabel.text = kMenuSupine;
      self.currentAsanas = self.supine;
      [self.collectionView reloadData];
      break;
    }
    case Backbends:
    {
      self.titleLabel.text = kMenuBackbends;
      self.currentAsanas = self.backbends;
      [self.collectionView reloadData];
      break;
    }
    case Abdominals:
    {
      self.titleLabel.text = kMenuAbdominals;
      self.currentAsanas = self.abdominals;
      [self.collectionView reloadData];
      break;
    }
    case Restorative:
    {
      self.titleLabel.text = kMenuRestorative;
      self.currentAsanas = self.restorative;
      [self.collectionView reloadData];
      break;
    }
      
    default:
      break;
  }
  
  // Then dismiss popover controller
  [self.asanasPopoverController dismissPopoverAnimated:YES];
  self.asanasPopoverController = nil;
}

@end
