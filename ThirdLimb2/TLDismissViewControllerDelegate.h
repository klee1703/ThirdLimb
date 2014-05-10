//
//  TLDismissViewControllerDelegate.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/29/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TLDismissViewControllerDelegate <NSObject>

//-(void) dismissViewController;
-(void) dismissViewController:(NSInteger)itemTag;
-(void) didSelectTabItem:(NSInteger)item;
-(void) selectTabItem:(NSInteger)item;

@end
