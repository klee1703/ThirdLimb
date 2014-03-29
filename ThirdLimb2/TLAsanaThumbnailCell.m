//
//  TLAsanaThumbnailCell.m
//  ThirdLimb2
//
//  Created by Keith Lee on 3/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLAsanaThumbnailCell.h"

@implementation TLAsanaThumbnailCell

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _asanaName = [UILabel new];
    [self.contentView addSubview:_asanaName];
    [self.contentView bringSubviewToFront:_removeAsana];
    [self.contentView bringSubviewToFront:_asanaName];
    // Add your subviews here
    // self.contentView for content
    // self.backgroundView for the cell background
    // self.selectedBackgroundView for the selected cell background
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
