//
//  BaseButton.h
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseButton;

typedef void(^BlockButton)(BaseButton*);

@interface BaseButton : UIButton

@property (nonatomic,copy)BlockButton myBlockButton;

@property (nonatomic, assign) NSUInteger index;
@end
