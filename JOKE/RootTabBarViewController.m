//
//  RootTabBarViewController.m
//  JOKE
//
//  Created by lanouhn on 15/7/30.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "DownloadViewController.h"
#import "WaterFlowViewController.h"

@interface RootTabBarViewController () <MBProgressHUDDelegate>
{
     NSMutableArray *_testMutableArray;
    MBProgressHUD *mb;
    BOOL isNight;
}

@property (nonatomic , strong) CXDynamicModuleView *c_x;
@property (nonatomic , assign) BOOL isOne;
@property (nonatomic , strong)  UIView *nightView;
@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isOne = YES;
    self.view.backgroundColor = [UIColor orangeColor];
}
- (IBAction)menuAction:(id)sender {
    
    if (self.isOne) {
        _testMutableArray = [NSMutableArray array];
        
        NSArray *color = @[RGB_COLOR(110, 195, 200),RGB_COLOR(241, 122, 110),RGB_COLOR(218, 96, 36),RGB_COLOR(250, 187, 13),RGB_COLOR(241, 146, 113),RGB_COLOR(28, 78, 147),RGB_COLOR(3, 166, 174)];
        NSArray *title = @[@"下载列表", @"夜间模式" , @"清除缓存" , @"关于我们"];
        NSInteger count = title.count;
        
        for (int index = 0; index < count; index ++) {
            SelectView *view = [[SelectView alloc]init];
            
            view.teamName.text = title[index];
            view.backgroundColor = color[index];
            view.selectButton.index = index;
            [_testMutableArray addObject:view];
            
            view.selectButton.myBlockButton = ^(BaseButton *button){
                NSLog( @"您点击的是 %ld" , button.index);
               self. isOne = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    view.transform = CGAffineTransformMakeScale(2, 2);
                    view.alpha = 0.1;
                    for (UIView *selectView in _testMutableArray) {
                        if (![selectView isEqual:view]) {
                            selectView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                            
                        }
                    }
                    
                } completion:^(BOOL finished) {
                    
                    
                    for (UIView *selectView in _testMutableArray) {
                        selectView.transform = CGAffineTransformMakeScale(1, 1);
                        selectView.alpha = 1;
                        
                    }
                    UIView *adcd = (UIView *)[self.view viewWithTag:10003];
                    [adcd removeFromSuperview];
                    if ([view.teamName.text isEqualToString:@"下载列表"]) {
                        
                        NSLog(@"下载");
//                        DownloadViewController *downloadVC = [[DownloadViewController alloc]init];
//                        [self presentViewController:downloadVC animated:YES completion:nil];
                        WaterFlowViewController *waterVC = [[WaterFlowViewController alloc]init];
                        [self.navigationController showViewController:waterVC sender:nil];

                    }
                    if ([view.teamName.text isEqualToString:@"夜间模式"]) {
                        [self goNightMode];
                    }
                    if ([view.teamName.text isEqualToString:@"清除缓存"]) {
                        
                        [self clearCache];
                    }
                    if ([view.teamName.text isEqualToString:@"关于我们"]) {
                        
                    }
                }];
                
            };
        }
        self.c_x = [[CXDynamicModuleView alloc]initWithFrame:self.view.bounds];
        _c_x.imageNameArray = _testMutableArray;
        UIView * abc =  [_c_x loadDynamicModuleView:self.view];
        abc.tag = 10003;
        [self.view addSubview:abc];
        
        
        _isOne = NO;
    }
    __weak typeof(self) weakSelf= self;
    self.c_x.myBlock = ^(BOOL one ){
        
        weakSelf.isOne = one;
    };

    
}
#pragma mark - 夜间模式
- (void)goNightMode{
    isNight = !isNight;
    if (isNight) {
        self.nightView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.nightView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.nightView.alpha = 0.5;
        self.nightView.userInteractionEnabled = NO;
        [self.view.window addSubview:self.nightView];
    } else {
        for (UIView *view in self.view.window.subviews) {
            if ([view isEqual:self.nightView]) {
                [view removeFromSuperview];
            }
        }
    }
   
}
#pragma mark - 清理缓存
- (void)clearCache{

    NSLog(@"%ld"  , [[SDImageCache sharedImageCache] getSize]);
    

    NSInteger index = [[SDImageCache sharedImageCache] getSize];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"default"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm removeItemAtPath:defaultPath error:&error];
    if (!error) {
        
        mb = [[MBProgressHUD alloc]init];
        [self.navigationController.view addSubview:mb];
        
        mb.labelText = [NSString stringWithFormat:@"您清除了%.4fM" , index / 1024 / 1024.0];
        mb.mode = MBProgressHUDModeDeterminateHorizontalBar;
        mb.dimBackground = NO;
        mb.delegate = self;
        [mb showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];

    } else {

        MBProgressHUD *HUD = [[MBProgressHUD alloc]init];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText = @"已经干净了！";
        HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        HUD.progress = 1;
        HUD.dimBackground = NO;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.5);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
       
    }
    
    
    
}
#pragma mark - 清理缓存进度条
- (void)myProgressTask{
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        mb.progress = progress;
        usleep(20000);
    }
    [mb removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    
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

@end
