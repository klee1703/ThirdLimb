//
//  TLNotesViewController.m
//  ThirdLimb
//
//  Created by Keith Lee on 2/11/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLNotesViewController.h"

@interface TLNotesViewController ()

@end

@implementation TLNotesViewController

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
  
  self.notesArea.text = self.asana.notes;
  self.notesArea.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidEndEditing:(UITextView *)textView {
  // Persist updates to notes
  NSError *error;
  self.notesText = self.notesArea.text;
  self.asana.notes = self.notesText;
  BOOL isSaved = [self.managedObjectContext save:&error];
  if (!isSaved) {
    ;
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  // Persist updates to notes view
}

@end
