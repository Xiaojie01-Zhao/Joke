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
    
    [self.contentImageView setClipsToBounds:YES];
    [self.contentImageView setContentMode:UIViewContentModeScaleToFill];
    [self.contentImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];

    self.contentImageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    NSLog(@"*************%f" , self.contentImageView.frame.size.width);

}
- (void)setNeedsDisplay{
    
}
- (void)drawRect:(CGRect)rect{
    

}
- (void)calulateCellHeight{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.contentImageView setAutoresizesSubviews:YES];
//    [self.contentImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
