//
//  BluePageControl.m
//  Home
//
//  Created by 蔡翔 on 14/12/12.
//  Copyright (c) 2014年 qeebu. All rights reserved.
//

#import "BluePageControl.h"
#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation BluePageControl

-(void)awakeFromNib
{
    [super awakeFromNib];
    _activeImage = [UIImage imageNamed:@"channel_pagecontrol_bluedot.png"];
    _inactiveImage = [UIImage imageNamed:@"channel_pagecontrol_whitedot.png"];
    self.userInteractionEnabled=NO;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _activeImage = [UIImage imageNamed:@"channel_pagecontrol_bluedot.png"];
    _inactiveImage = [UIImage imageNamed:@"channel_pagecontrol_whitedot.png"];
    self.userInteractionEnabled=NO;
    return self;
}
- (void)updateDots
{
    for (int i = 0; i< [self.subviews count]; i++) {
        UIView * dot =[self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 8;     //自定义圆点的大小
        size.width = 8;      //自定义圆点的大小
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = 4.0f;
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i == self.currentPage){
            dot.backgroundColor = RGB_COLOR(21, 100, 229);
        }
        else
            dot.backgroundColor = RGB_COLOR(140, 167, 200);
        }
}
/*
- (void)updateDots
{
    for (int i = 0; i< [self.subviews count]; i++)
        
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0)
        {
            UIView *dot = [self.subviews objectAtIndex:i];
            CGSize size;
            size.height = 8;     //自定义圆点的大小
            size.width = 8;      //自定义圆点的大小
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius = 4.0f;
            [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
            if (i == self.currentPage)
            {
                dot.layer.backgroundColor=[UIColor clearColor].CGColor;
                dot.layer.contents=(id)self.activeImage.CGImage;
            }
            else
            {
                dot.layer.backgroundColor=[UIColor clearColor].CGColor;
                dot.layer.contents=(id)self.inactiveImage.CGImage;
            }
        }else{
            UIImageView* dot = [self.subviews objectAtIndex:i];
            if (i == self.currentPage)
            {
                dot.image = self.activeImage;
            }else{
                dot.image = self.inactiveImage;
            }
        }
    }
}
 */
- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}
@end
