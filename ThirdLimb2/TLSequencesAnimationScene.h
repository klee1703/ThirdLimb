//
//  TLSequencesAnimationScene.h
//  ThirdLimb2
//
//  Created by Keith Lee on 4/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Sequence.h"

@interface TLSequencesAnimationScene : SKScene

@property(nonatomic, strong) Sequence *sequence;
@property(nonatomic, strong) NSDictionary *sequencePlist;

@end
