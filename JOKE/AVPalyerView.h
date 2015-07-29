//
//  AVPalyerView.h
//  AVPlayer——Demo
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPalyerView : UIView
// 缓存按钮
@property (nonatomic , strong) UIButton *saveButton;
@property (nonatomic , strong) UILabel *startTimeLabel;
@property (nonatomic , strong) UILabel *endTimeLabel;
@property (nonatomic , strong) UISlider *progressSlider;

@property (nonatomic , strong) UIButton *playButton;

// 底部的操作视图
@property (nonatomic , strong) UIView *bottomOperationView;


@property (nonatomic , strong) UIButton *bigPlayButton;

@end
