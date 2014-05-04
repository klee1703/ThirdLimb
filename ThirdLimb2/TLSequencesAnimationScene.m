//
//  TLSequencesAnimationScene.m
//  ThirdLimb2
//
//  Created by Keith Lee on 4/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLSequencesAnimationScene.h"
#import "Sequence.h"
#import "Asana.h"

@implementation TLSequencesAnimationScene

-(void) didMoveToView:(SKView *)view {
  NSSet *asanas = self.sequence.asanas;
  NSMutableArray *textures = [NSMutableArray new];
  NSArray *asanaNamesPlist = [self.sequencePlist valueForKey:@"asanas"];
  for (NSString *asanaName in asanaNamesPlist) {
    // Find asana in NSSet with corresponding name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"SELF.name MATCHES %@", asanaName];
    Asana *asana = (Asana *)([asanas filteredSetUsingPredicate:predicate].anyObject);
    
    // Extract thumbnail name for asana and add to collection
    [textures addObject:[SKTexture textureWithImageNamed:asana.thumbnail]];
  }

  self.backgroundColor = [SKColor blueColor];
  SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:textures[0]];
  sprite.position = CGPointMake(76, 76);
  [self addChild:sprite];
  SKAction *animate = [SKAction animateWithTextures:textures
                                       timePerFrame:2.0
                                             resize:NO
                                            restore:NO];
  
  //SKAction *wait = [SKAction waitForDuration:5.0];
  //  SKAction *sequence = [SKAction sequence:@[animate, wait]];
  //SKAction *forever = [SKAction repeatActionForever:sequence];
  [sprite runAction:animate completion:nil];
}

@end
