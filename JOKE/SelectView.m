//
//  SelectView.m
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//
#import "SelectView.h"

@implementation SelectView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                NSArray *arrayofViews = [[NSBundle mainBundle]loadNibNamed:@"SelectView" owner:self options:nil];
                if (arrayofViews.count<1) {
                    return nil;
                }
                if (![arrayofViews[0]isKindOfClass:[UIView class]]) {
                    return nil;
                }
                self = arrayofViews[0];
                self.layer.masksToBounds = YES;
                self.layer.cornerRadius = 15.0f;
    }
           return self;
}


@end
