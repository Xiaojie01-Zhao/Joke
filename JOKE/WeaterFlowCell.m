//
//  WeaterFlowCell.m
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "WeaterFlowCell.h"

@implementation WeaterFlowCell

- (UIImageView *)imageView{
    
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
//- (UIButton *)button{
//    if (!_button) {
//        self.button = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 30, 0, 30, 30)];
//        [_button setTitle:@"X" forState:UIControlStateNormal];
//        [self.contentView addSubview:_button];
//    }
//    return _button;
//}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
//    self.button.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
}
@end
