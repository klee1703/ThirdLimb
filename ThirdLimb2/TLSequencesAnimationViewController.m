//
//  TLSequencesAnimationViewController.m
//  ThirdLimb2
//
//  Created by Keith Lee on 4/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLSequencesAnimationViewController.h"
#import "TLSequencesAnimationScene.h"

@interface TLSequencesAnimationViewController ()

@end

@implementation TLSequencesAnimationViewController

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
}


-(void) viewWillAppear:(BOOL)animated {
  // Run animation
  TLSequencesAnimationScene *scene = [[TLSequencesAnimationScene alloc] initWithSize:CGSizeMake(152, 152)];
  scene.sequence = self.sequence;
  scene.sequencePlist = self.sequencePlist;
  scene.delegate = self.delegate;
  SKView *spriteView = (SKView *)self.view;
  [spriteView presentScene:scene];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
