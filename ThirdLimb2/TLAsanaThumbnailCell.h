//
//  TLAsanaThumbnailCell.h
//  ThirdLimb2
//
//  Created by Keith Lee on 3/26/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLAsanaThumbnailCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *asanaName;
@property (strong, nonatomic) IBOutlet UIImageView *removeAsana;

@end
