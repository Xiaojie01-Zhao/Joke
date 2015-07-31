//
//  LinesLabel.m
//  AutosizingCell
//
//  Created by lanouhn on 15/7/14.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "LinesLabel.h"

@implementation LinesLabel


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
// 使用方法
//label  number = 0 ；     Explicit 勾上    ，class ：LinesLabel   
    //设置label的preferredMaxLayoutWidth 使之等于当前设备的宽度
    if (self.numberOfLines == 0) {
        if (self.preferredMaxLayoutWidth != self.frame.size.width
            ) {
            self.preferredMaxLayoutWidth = self.frame.size.width;
            
            //更新lebel的当前约束
            [self setNeedsUpdateConstraints];
        }
    }
    
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    
    //高度+1，1px就是分割线
    if (self.numberOfLines == 0) {
        size.height += 1;
    }
    return size;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
