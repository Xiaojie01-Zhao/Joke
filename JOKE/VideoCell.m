//
//  VideoCell.m
//  JOKE
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width / 2;
    
    [self.contentImageView setContentMode:UIViewContentModeScaleToFill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
