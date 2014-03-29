//
//  TLNotesViewController.h
//  ThirdLimb
//
//  Created by Keith Lee on 2/11/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asana.h"

@interface TLNotesViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) NSString *notesText;
@property (weak, nonatomic) IBOutlet UITextView *notesArea;
@property (nonatomic, strong) Asana *asana;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
