//
//  CXDynamicModuleView.m
//  CXDynamicModule
//
//  Created by 蔡翔 on 15/6/24.
//  Copyright (c) 2015年 蔡翔. All rights reserved.
//

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "CXDynamicModuleView.h"
#import "UIImage+BlurredFrame.h"
#import "BluePageControl.h"
@implementation CXDynamicModuleView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIView *)loadDynamicModuleView:(UIView *)superView
{
    UIImage *img  = [self getLucencyImage:[self captureScreen:superView]];
    UIImageView *bgselectTeamView  = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgselectTeamView.tag = 10001;
    bgselectTeamView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [bgselectTeamView addGestureRecognizer:tap];
    bgselectTeamView.image = img;
    [self addSubview:bgselectTeamView];
    
    UIScrollView *_selectScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _selectScrollView.showsHorizontalScrollIndicator = NO;
    _selectScrollView.showsVerticalScrollIndicator = NO;
    _selectScrollView.pagingEnabled = YES;
    _selectScrollView.delegate = self;
    [bgselectTeamView addSubview:_selectScrollView];
    
    NSInteger _page = 0;//页数
    NSInteger _countTwo = 0;
    CGFloat  landscapeBottom = (SCREEN_WIDTH - 210)/4;//横向,纵向间隙
    
    _page = _imageNameArray.count/9;
    if (_imageNameArray.count%9!=0) {
        _page++;
    }
    _selectScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_page, SCREEN_HEIGHT);
    for (int i = 0 ; i < _page; i++) {
        UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0+i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        aview.backgroundColor = [UIColor clearColor];
        [_selectScrollView addSubview:aview];
        _countTwo = i + 1 == _page ? _imageNameArray.count - i * 9:9;
        for (int j = 0; j < _countTwo; j ++) {
            NSInteger index = 9 * i;
            index = index + j;
            UIView* view = _imageNameArray[index];
            int x = (j % 3)*(landscapeBottom + 70) + landscapeBottom;
            int y = (j / 3)*(landscapeBottom + 70)  - 3 * 70 - 2 * landscapeBottom;//起始位置
            view.frame = CGRectMake(x, y, 70, 70);
            [aview addSubview:view];
        }
    }
    CGFloat  downDistance = (SCREEN_HEIGHT - (3 * 70 + 2 * landscapeBottom))/2 + 3 * 70 + 2 *landscapeBottom ;
    
    BluePageControl *pageVC = [[BluePageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50/2,downDistance + 10 , 50, 37)];
    pageVC.hidden = YES;
    pageVC.numberOfPages = _page;
    pageVC.hidden = _page == 1;
    pageVC.currentPage = 0;
    pageVC.tag = 10002;
    [bgselectTeamView addSubview:pageVC];
    [self startAnimation];

    return self;
}

- (void)click:(UITapGestureRecognizer *)sender
{
    BluePageControl *pageVC = (BluePageControl *)[self viewWithTag:10002];
    [self backAnimation:pageVC.currentPage ];
}

- (void) startAnimation
{
    CGFloat  landscapeBottom = (SCREEN_WIDTH - 210)/4;//横向,纵向间隙
    CGFloat  downDistance = (SCREEN_HEIGHT - (3 * 70 + 2 * landscapeBottom))/2 + 3 * 70 + 2 *landscapeBottom + 20;//下降距离
    NSInteger count  = _imageNameArray.count >9?9:_imageNameArray.count;
    // 小于一页的App数量
    for (int index = (int)count - 1; index >= 0; index --) {
        UIView* view = _imageNameArray[index];
        [UIView animateWithDuration:0.3 delay:0.05*(count - 1-index) options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = view.frame;
            // 500为第一次下落的距离
            frame.origin.y += downDistance;
            view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect frame = view.frame;
                    // 20为向上弹跳的距离
                    frame.origin.y -= 20;
                    view.frame = frame;
                } completion:^(BOOL finished) {
#warning 如果当前index为0 则动画完成时可以做一些动作
                }];
            }
        }];
    }
    for (int i = (int)count; i < _imageNameArray.count;  i ++) {
        UIView* view = _imageNameArray[i];
        CGRect frame = view.frame;
        // 450为第一次下落的距离
        frame.origin.y += downDistance - 20;
        view.frame = frame;
    }
}


- (void)backAnimation:(NSInteger)curentPage
{
    CGFloat  landscapeBottom = (SCREEN_WIDTH - 210)/4;//横向,纵向间隙
    CGFloat  upDistance = (SCREEN_HEIGHT - (3 * 70 + 2 * landscapeBottom))/2 + 3 * 70 + 2 *landscapeBottom + 20;
    
    int startIndex = (int)curentPage * 9;
    int endIndex = startIndex + 8;
    if (endIndex > (_imageNameArray.count - 1)) {
        endIndex = (int)_imageNameArray.count - 1;
    }
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    for (int index = startIndex; index <= endIndex; index ++) {
        [tempArray addObject:_imageNameArray[index]];
    }
    
    for (int index = 0; index < tempArray.count; index ++) {
        UIView* view = tempArray[index];
        [UIView animateWithDuration:0.3 delay:0.05*(index) options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = view.frame;
            // 20为向下弹跳的距离
            frame.origin.y += 20;
            view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (finished) {
                        CGRect frame = view.frame;
                        // 上滑的距离
                        frame.origin.y -= upDistance;
                        view.frame = frame;
                    }
                } completion:^(BOOL finished) {
#warning 如果当前index为最后一个 则动画完成时可以做一些动作
                    if (index == tempArray.count - 1) {
                        UIImageView *bgselectTeamView = (UIImageView *)[self viewWithTag:10001];
                        [bgselectTeamView removeFromSuperview];
                        [self removeFromSuperview];
                    }
                }];
            }
        }];
    }
}

#pragma mark -scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = ((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    BluePageControl *pageVC = (BluePageControl *)[self viewWithTag:10002];
    pageVC.currentPage = page;
}
#pragma mark - private
- (UIImage *)captureScreen:(UIView *)superView
{
    UIGraphicsBeginImageContext(superView.window.frame.size);
    [superView.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();                              UIGraphicsEndImageContext();
    return viewImage;
}

- (UIImage *)getLucencyImage:(UIImage *)image
{
    UIImage *img = image;
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
    return  [img applyLightWhiteEffectAtFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
