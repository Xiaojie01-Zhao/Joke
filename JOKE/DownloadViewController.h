//
//  DownloadViewController.h
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "LBorderView.h"
@interface DownloadViewController : UIViewController<iCarouselDataSource , iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UISlider *shijiaoSlider;
@property (weak, nonatomic) IBOutlet UILabel *shijiaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewpointOffsetLabel;

@property (weak, nonatomic) IBOutlet UILabel *yPointLabel;
@property (weak, nonatomic) IBOutlet UISlider *yPointSlider;

@property (weak, nonatomic) IBOutlet UILabel *contentOffsetLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *goDiLabel;


@property (weak, nonatomic) IBOutlet UILabel *geLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
