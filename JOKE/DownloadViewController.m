//
//  DownloadViewController.m
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()


@property (nonatomic , strong) NSMutableArray *items;


@end




@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // view格式
    self.carousel.type = iCarouselTypeCylinder;

    [self setUp];
    
    
}
- (IBAction)mySwitchAction:(id)sender {
    
    if (self.mySwitch.on == YES) {
        self.shijiaoLabel.alpha = 1;
        self.shijiaoSlider.alpha = 1;
        self.viewpointOffsetLabel.alpha = 1;
        self.yPointLabel.alpha = 1;
        self.yPointSlider.alpha = 1;
        self.contentOffsetLabel.alpha = 1;
    } else {
        self.shijiaoLabel.alpha = 0;
        self.shijiaoSlider.alpha = 0;
        self.viewpointOffsetLabel.alpha = 0;
        self.yPointLabel.alpha = 0;
        self.yPointSlider.alpha = 0;
        self.contentOffsetLabel.alpha = 0;

    }
    
}

// 本方法被遗弃
- (void)viewDidUnload{
    [super viewDidUnload];
    self.carousel = nil;
}
- (void)setUp{
    self.items = [NSMutableArray array];
    
    // 显示多少个元素
    for (int i = 0; i < 100000; i++) {
        [self.items addObject:@(i)];
    }
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (IBAction)updateViewpointOffset:(UISlider *)sender {
    
    CGSize offset = CGSizeMake(0.0f, sender.value);
    self.carousel.viewpointOffset = offset;
    self.viewpointOffsetLabel.text = NSStringFromCGSize(offset);
    
}
- (IBAction)updateContentOffset:(UISlider *)sender {
    
    CGSize offset = CGSizeMake(0.0f, sender.value);
    
    self.carousel.contentOffset = offset;
    // 把CGSize格式转为NSString
    self.contentOffsetLabel.text = NSStringFromCGSize(offset);
    
}

#pragma mark - iCarousel Delegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.items.count;
}


// 占位视图
//- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view{
//    
//}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UILabel *label = nil;
    if (view == nil) {
        carousel.currentItemIndex = 2;
        
//        LBorderView *aaaaa = [[LBorderView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
//        aaaaa.borderType = BorderTypeDashed;
//        aaaaa.dashPattern = 15;
//        aaaaa.spacePattern = 9;
//        aaaaa.borderWidth = 4;
//        aaaaa.cornerRadius = 20;
//        
//        view = aaaaa;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 290, 380)];
        
        NSString *cachepath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imagePath = [cachepath stringByAppendingPathComponent:@"Movie"];
        NSString *newPath = [imagePath stringByAppendingPathComponent:@"httpp3.pstatp.comlarge67523785171565.png"];
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:newPath];
        NSLog(@"%f,%f",image.size.width , image.size.height);
//        imageView.image = [UIImage imageNamed:@"image"];
        imageView.image = image;
        view = imageView;
        
        label = [[UILabel alloc]initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        label.tag = 1000;
        [view addSubview:label];
    } else {
        label = (UILabel *)[view viewWithTag:1000];
    }
    label.text = [self.items[index] stringValue];
    
    return view;
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"%ld" , index);
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    
    switch (option) {
        case iCarouselOptionSpacing:
        {
            return value * 1.05f;
        }
            break;
            
        default:
        {
            return value;
        }
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
    
}
@end
