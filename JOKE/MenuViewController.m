//
//  MenuViewController.m
//  JOKE
//
//  Created by lanouhn on 15/7/30.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
{
    NSMutableArray *_testMutableArray;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testMutableArray = [NSMutableArray array];
    
    
   
    
    
    NSArray *color = @[RGB_COLOR(110, 195, 200),RGB_COLOR(241, 122, 110),RGB_COLOR(218, 96, 36),RGB_COLOR(250, 187, 13),RGB_COLOR(241, 146, 113),RGB_COLOR(28, 78, 147),RGB_COLOR(3, 166, 174)];
    NSArray *title = @[@"下载", @"夜间模式" , @"清除缓存" , @"关于我们"];
    NSInteger count = title.count;
    
    for (int index = 0; index < count; index ++) {
        SelectView *view = [[SelectView alloc]init];
        
        view.teamName.text = title[index];
        view.backgroundColor = color[index];
        view.selectButton.index = index;
        [_testMutableArray addObject:view];
        
        view.selectButton.myBlockButton = ^(BaseButton *button){
            NSLog( @"您点击的是 %ld" , button.index);
            
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
                if ([view.teamName.text isEqualToString:@"下载"]) {
                    
                }
                if ([view.teamName.text isEqualToString:@"夜间模式"]) {
                    
                }
            }];
        
        };
    }
    CXDynamicModuleView *c_x = [[CXDynamicModuleView alloc]initWithFrame:self.view.bounds];
    c_x.imageNameArray = _testMutableArray;
    UIView * abc =  [c_x loadDynamicModuleView:self.view];
    abc.tag = 10003;
    [self.view addSubview:abc];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)touchAction:(UIButton *)sender{
   
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
