//
//  TLSequencesAnimationScene.m
//  ThirdLimb2
//
//  Created by Keith Lee on 4/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLSequencesAnimationScene.h"

@implementation TLSequencesAnimationScene

-(void) didMoveToView:(SKView *)view {
  self.backgroundColor = [SKColor blueColor];
  SKTexture *asana1 = [SKTexture textureWithImageNamed:@"Tadasana-Samasthiti_thumbnail.png"];
  SKTexture *asana2 = [SKTexture textureWithImageNamed:@"Virabhadrasana1_thumbnail.png"];
  SKTexture *asana3 = [SKTexture textureWithImageNamed:@"Virabhadrasana2_thumbnail.png"];
  SKTexture *asana4 = [SKTexture textureWithImageNamed:@"Uttanasana_thumbnail.png"];
  SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:asana1];
  sprite.position = CGPointMake(76, 76);
  [self addChild:sprite];
  SKAction *animate = [SKAction animateWithTextures:@[asana1, asana2, asana1, asana3, asana1, asana4, asana1]
                                       timePerFrame:2.0
                                             resize:NO
                                            restore:NO];
  //SKAction *wait = [SKAction waitForDuration:3.0];
  //  SKAction *sequence = [SKAction sequence:@[animate, wait]];
  [sprite runAction:animate completion:nil];
}

@end
