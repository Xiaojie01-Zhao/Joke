//
//  CXDynamicModuleView.h
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuPassValueBlock)(BOOL);

@interface CXDynamicModuleView : UIView<UIScrollViewDelegate>

@property (retain,nonatomic) NSArray * imageNameArray;

- (UIView *)loadDynamicModuleView:(UIView *)superView ;

@property (nonatomic , copy) MenuPassValueBlock myBlock;

@end
