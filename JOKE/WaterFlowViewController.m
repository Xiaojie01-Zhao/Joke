//
//  WaterFlowViewController.m
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "WaterFlowViewController.h"
#import "WaterFlowLayout.h"
#import "WeaterFlowCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WaterFlowViewController ()<WaterFlowLayoutDelegate , UICollectionViewDataSource , UICollectionViewDelegate , UIGestureRecognizerDelegate , UICollectionViewDelegateFlowLayout>
{
    BOOL isDelete;
}
@property (nonatomic , strong) NSMutableArray *dataSourceImage;
@property (nonatomic , strong) NSMutableArray *dataSourceMovie;
@property (nonatomic , strong) AppDelegate *appdelegate;
@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , assign) NSInteger deleteIndexPath;
@end
static NSString *cellID = @"waterCell";

@implementation WaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSourceImage = [NSMutableArray array];
    self.dataSourceMovie = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.appdelegate = [UIApplication sharedApplication ].delegate;
    
    WaterFlowLayout *waterLayout = [[WaterFlowLayout alloc]init];
    waterLayout.numberOfColumns = 2;
    waterLayout.itemWidth = (CGRectGetWidth(self.view.bounds) - 15) / 2;
    waterLayout.sectionIndexs = UIEdgeInsetsMake(5, 5, 5, 5);
    waterLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:waterLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPress];
    longPress.delegate = self;
    
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, 0, 30, 30);
    self.deleteButton.backgroundColor = [UIColor redColor];
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.collectionView registerClass:[WeaterFlowCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
    [self getDataForFile];
    
    
    
    
}
- (void)getDataForFile{
    
    NSFetchRequest *fet = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    
    NSArray *dataArr = [self.appdelegate.managedObjectContext executeFetchRequest:fet error:nil];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    for (Movie *movieModel in dataArr) {
        
        NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieImageName]];
        [self.dataSourceImage addObject:imagePath];

        NSString *moviePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieName]];
        [self.dataSourceMovie addObject:moviePath];

    }
    
}
#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld" , self.dataSourceImage.count);
    return [self.dataSourceImage count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeaterFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:self.dataSourceImage[indexPath.row]];
 
    
    return cell;
}
#pragma mark - 点击事件

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"%ld" , indexPath.row);
    
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:self.dataSourceMovie[indexPath.row]]];
    [self presentViewController:mp animated:YES completion:nil];

}
// 移动
- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    
    static NSIndexPath *sourceIndexPath = nil;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            WeaterFlowCell *cell = (WeaterFlowCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            self.deleteButton.hidden = NO;
            [cell addSubview:self.deleteButton];
            self.deleteIndexPath = indexPath.row + 1000;
            sourceIndexPath = indexPath;
            [self.deleteButton bringSubviewToFront:self.collectionView];
            self.deleteButton.tag = indexPath.row + 1000;
        }
            break;
          case UIGestureRecognizerStateEnded:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.dataSourceImage exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                [self.collectionView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 删除
- (void)deleteAction:(UIButton *)sender{
    
    NSLog(@"%@" , [sender.superview class]);
    
    WeaterFlowCell *cell = (WeaterFlowCell *)sender.superview;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];

    [self.dataSourceImage removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];


}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
}
#pragma mark - Layout Delegate 
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForIndexPath:(NSIndexPath *)indexPath{
    
    NSString *imagePath = self.dataSourceImage[indexPath.row];
    UIImage *image =  [UIImage imageWithContentsOfFile:imagePath];
    
    CGFloat imageHeight = waterFlowLayout.itemWidth * image.size.height / image.size.width;
    return imageHeight;
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
