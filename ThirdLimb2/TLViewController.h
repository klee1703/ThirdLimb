//
//  TLViewController.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/23/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDetailTitle            @"Third Limb"
#define kThumbnailCellsPerRow   4
#define kThumbnailWidth         190
#define kThumbnailSpacing       1
#define kRemoveAsanaFavoritesTitle  @"Remove Asana(s) from list of favorites? Click Yes to confirm."


#define kMenuStanding     @"Standing"
#define kMenuForward      @"Forward Bends"
#define kMenuTwists       @"Twists"
#define kMenuInversions   @"Inversions"
#define kMenuSeated       @"Seated"
#define kMenuSupine       @"Supine"
#define kMenuBackbends    @"Backbends"
#define kMenuAbdominals   @"Abdominals"
#define kMenuRestorative  @"Restorative"
#define kMenuOther        @"Other"


@interface TLViewController : UIViewController <UITabBarDelegate>

// IB properties
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *editFavorites;

// CoreData properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property(nonatomic, strong) NSArray *asanas;

- (IBAction)favoritesButtonTouched:(id)sender;

@end
