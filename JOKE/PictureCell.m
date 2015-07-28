//
//  PictureCell.m
//  JOKE
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

- (void)awakeFromNib {
    // Initialization code

    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width / 2;
    [self.contentView setClipsToBounds:YES];
    [self.contentView setContentMode:UIViewContentModeTop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
