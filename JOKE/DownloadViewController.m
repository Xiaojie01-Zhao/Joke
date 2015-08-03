//
//  DownloadViewController.m
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "DownloadViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DownloadViewController () <UITextFieldDelegate>



@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , strong) NSMutableArray *dataSourceImage;
@property (nonatomic , strong) NSMutableArray *dataSourceMovie;
@property (nonatomic , strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic , assign) NSInteger index;

@property (nonatomic , strong)UIButton *button;
@end




@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // view格式
    self.carousel.type = iCarouselTypeCylinder;
  
    self.textField.delegate = self;
    
    self.textField.returnKeyType = UIReturnKeyDone;
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    imageView.image = [UIImage imageNamed:@"iCarousel"];
//    imageView.userInteractionEnabled = YES;
//    [self.view addSubview: imageView];
//    [imageView sendSubviewToBack:self.carousel];

    [self setUp];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button.frame = CGRectMake(40, 30, [UIScreen mainScreen].bounds.size.width - 80, 40);
    [self.button setTitle:@"删除当前的视频" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.button.backgroundColor = [UIColor yellowColor];
    self.button.hidden = YES;
    [self.button addTarget:self action:@selector(deleteaItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.carousel addSubview:self.button];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}

- (IBAction)mySwitchAction:(id)sender {
    
    if (self.mySwitch.on == YES) {
        self.shijiaoLabel.alpha = 1;
        self.shijiaoSlider.alpha = 1;
        self.viewpointOffsetLabel.alpha = 1;
        self.yPointLabel.alpha = 1;
        self.yPointSlider.alpha = 1;
        self.contentOffsetLabel.alpha = 1;

        self.button.hidden = YES;
        
    } else {
        self.shijiaoLabel.alpha = 0;
        self.shijiaoSlider.alpha = 0;
        self.viewpointOffsetLabel.alpha = 0;
        self.yPointLabel.alpha = 0;
        self.yPointSlider.alpha = 0;
        self.contentOffsetLabel.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.button.hidden = NO;
        }];
    }
    
}
- (void)deleteaItem:(UIButton *)sender{
    
        NSLog(@"*********************%ld" , self.carousel.currentItemIndex);
    
    NSLog(@"%@" , self.dataSourceImage[self.carousel.currentItemIndex]);
    
//    Movie *model = nil;
//    model.movieImageName = self.dataSourceImage[self.carousel.currentItemIndex];
//    model.movieName = self.dataSourceMovie[self.carousel.currentItemIndex];
    Movie *model = self.dataSourceImage[self.carousel.currentItemIndex];
    [self.appDelegate.managedObjectContext deleteObject:model];
    [self.appDelegate.managedObjectContext save:nil];

    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , ((Movie *)self.dataSourceImage[self.carousel.currentItemIndex]).movieImageName]];
    NSString *moviePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , ((Movie *)self.dataSourceImage[self.carousel.currentItemIndex]).movieName]];
    
    [fm removeItemAtPath:imagePath error:nil];
    [fm removeItemAtPath:moviePath error:nil];
    
    
    [self.dataSourceImage removeObjectAtIndex:self.carousel.currentItemIndex];
//    [self.dataSourceMovie removeObjectAtIndex:self.carousel.currentItemIndex];

    [self.carousel removeItemAtIndex:self.carousel.currentItemIndex animated:YES];

//    [self.carousel reloadItemAtIndex:self.carousel.currentItemIndex animated:YES];
    [self.carousel reloadData];
}


// 本方法被遗弃
- (void)viewDidUnload{
    [super viewDidUnload];
    self.carousel = nil;
}
- (void)setUp{
    self.items = [NSMutableArray array];
    self.dataSourceImage  = [NSMutableArray array];
    self.dataSourceMovie = [NSMutableArray array];
   self.appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fet = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    
    NSArray *dataArr = [self.appDelegate.managedObjectContext executeFetchRequest:fet error:nil];
    
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    for (Movie *movieModel in dataArr) {
//        
//        NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieImageName]];
        [self.dataSourceImage addObject:movieModel];
        
//        NSString *moviePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieName]];
//        [self.dataSourceMovie addObject:moviePath];
        
    }

    // 显示多少个元素
    for (int i = 0; i < self.dataSourceImage.count; i++) {
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
- (IBAction)nextAction:(id)sender {
    [self.textField resignFirstResponder];
    if ([self.textField.text integerValue] <= self.dataSourceImage.count) {
        [self.carousel scrollToItemAtIndex:[self.textField.text integerValue] animated:YES];

    }
}
#pragma mark - TExtField Delegate 只让输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumber:string];
}
- (BOOL)validateNumber:(NSString *)number{
    BOOL res = YES;
    NSCharacterSet *temSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:temSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)updateViewpointOffset:(UISlider *)sender {
  
    float f = sender.value;
    NSString *str = nil;
    if (fmodf(f, 1)==0) {
       str = [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f * 10, 1)){
        str = [NSString stringWithFormat:@"%.1f",f];
    } else {
       str = [NSString stringWithFormat:@"%.2f" ,f];
    }
    
    CGSize offset = CGSizeMake(0.0f, [str floatValue]);
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
    NSLog(@"_____________%ld" , self.dataSourceImage.count);
    return self.dataSourceImage.count;
}


// 占位视图
//- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view{
//    
//}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UILabel *label = nil;
    UIImageView *imageView = nil;
    if (view == nil) {
//        carousel.currentItemIndex = 2;
        
//        LBorderView *aaaaa = [[LBorderView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
//        aaaaa.borderType = BorderTypeDashed;
//        aaaaa.dashPattern = 15;
//        aaaaa.borderColor = [UIColor yellowColor];
//        aaaaa.spacePattern = 9;
//        aaaaa.borderWidth = 5;
//        aaaaa.cornerRadius = 20;
        
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 190, 290)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        
//        [aaaaa addSubview:imageView];
        view = imageView;
        
        
        
        label = [[UILabel alloc]initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:50];
        label.textColor = [UIColor whiteColor];
        label.tag = 1000;
        [view addSubview:label];
    } else {
        label = (UILabel *)[view viewWithTag:1000];

    }
    label.text = [self.items[index] stringValue];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , ((Movie *)self.dataSourceImage[index]).movieImageName]];

//    imageView.image = [UIImage imageWithContentsOfFile:self.dataSourceImage[index]];
    
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];

    
    return view;
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{

    NSLog(@"%ld" , index);
    Movie *model = self.dataSourceImage[index];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *moviePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , model.movieName]];

    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:moviePath]];
    [self presentViewController:mp animated:YES completion:nil];
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
