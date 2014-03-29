//
//  TLAsanaDetailViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 1/8/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asana.h"

#define kAddAsanaToFavoritesTitle  @"to list of favorites? Click Yes to confirm."

@interface TLAsanaDetailViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Asana *asana;
@property (nonatomic, strong) NSString *asanaName;
@property (nonatomic, strong) NSString *translation;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UILabel *asanaTranslation;
@property (strong, nonatomic) IBOutlet UIButton *favoritesButton;
@property (strong, nonatomic) UIPopoverController *notesPopoverController;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSSet *favoriteAsanas;

- (IBAction)notesPopover:(id)sender;
- (IBAction)addToFavorites:(id)sender;

@end