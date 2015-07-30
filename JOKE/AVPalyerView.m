//
//  AVPalyerView.m
//  AVPlayer——Demo
//
//  Created by lanouhn on 15/7/29.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "AVPalyerView.h"

@implementation AVPalyerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews{

    self.bottomOperationView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
//    NSLog(@"%f" , self.frame.size.height - 40);
    self.bottomOperationView.backgroundColor = [UIColor blackColor];
    self.bottomOperationView.alpha = 0.68;
   
    
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 40, 30)];
    self.startTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.startTimeLabel.text = @"00:00";
    self.startTimeLabel.textColor = [UIColor whiteColor];
    [self.bottomOperationView addSubview:_startTimeLabel];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 90, 0, 40, 30)];
    self.endTimeLabel.textColor = [UIColor whiteColor];
    [self.bottomOperationView addSubview:_endTimeLabel];
    
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.startTimeLabel.bounds) + 10, 0, self.bounds.size.width - 150, 30)];
    [self.bottomOperationView addSubview:_progressSlider];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    self.playButton.frame = CGRectMake(23, 25, 24, 24   );
//    [self.bottomOperationView addSubview:_playButton];
    
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"缓存_plyer"] forState:UIControlStateNormal];
    self.saveButton.frame = CGRectMake(self.frame.size.width - 40, 3, 30, 30);
    [self.bottomOperationView addSubview:_saveButton];
    
     [self addSubview:_bottomOperationView];
    
    
    self.bigPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigPlayButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    [self.bigPlayButton setFrame:CGRectMake(self.frame.size.width/ 2 - 30, self.frame.size.height/2 - 30, 60, 60 )];
    [self addSubview:_bigPlayButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
