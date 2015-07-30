//
//  SelectView.h
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"

@interface SelectView : UIView

@property (weak, nonatomic) IBOutlet UILabel *teamName;

@property (weak, nonatomic) IBOutlet BaseButton *selectButton;

@end
