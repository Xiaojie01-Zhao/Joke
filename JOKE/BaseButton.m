//
//  BaseButton.m
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           [self addTarget:self action:@selector(doclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(doclick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doclick:(BaseButton *)bloke
{
    self.myBlockButton(bloke);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
