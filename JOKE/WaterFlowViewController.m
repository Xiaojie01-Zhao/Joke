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

@property (nonatomic , strong) AppDelegate *appdelegate;

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) WaterFlowLayout *waterLayout;

@property (nonatomic , strong) UIButton *deleteButton;
@property (nonatomic , assign) NSInteger deleteIndexPath;
@end
static NSString *cellID = @"waterCell";

@implementation WaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSourceImage = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
    self.appdelegate = [UIApplication sharedApplication ].delegate;
    
    self.waterLayout = [[WaterFlowLayout alloc]init];
    self.waterLayout.numberOfColumns = 2;
    self.waterLayout.itemWidth = (CGRectGetWidth(self.view.bounds) - 15) / 2;
    self.waterLayout.sectionIndexs = UIEdgeInsetsMake(5, 5, 5, 5);
    self.waterLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.waterLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPress];
    longPress.delegate = self;
    
    
    
    [self.collectionView registerClass:[WeaterFlowCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
    [self getDataForFile];
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, 0, 40, 40);
    self.deleteButton.backgroundColor = [UIColor redColor];
    self.deleteButton.hidden = YES;
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];



    
}

- (void)getDataForFile{
    
    NSFetchRequest *fet = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    
    NSArray *dataArr = [self.appdelegate.managedObjectContext executeFetchRequest:fet error:nil];
    

    for (Movie *movieModel in dataArr) {
        [self.dataSourceImage addObject:movieModel];
    }
    
}
#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"item个数:%ld" , self.dataSourceImage.count);
    return [self.dataSourceImage count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", self.dataSourceImage.count);
    WeaterFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    
    Movie *movieModel = self.dataSourceImage[indexPath.row];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieImageName]];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
 
    
    return cell;
}
#pragma mark - 点击事件

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld" , indexPath.row);
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    Movie *model = self.dataSourceImage[indexPath.row];
    NSString *moviePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , model.movieName]];
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:moviePath]];
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
//            [self.deleteButton bringSubviewToFront:self.collectionView];
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];
    NSLog(@"____________________%ld" , sender.tag - 1000);

    NSLog(@"%@" , self.dataSourceImage[sender.tag - 1000]);
    
        Movie *movieModel = self.dataSourceImage[sender.tag - 1000];

        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieImageName]];
        NSString *moviePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , movieModel.movieName]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSLog(@"图片路径：%@" , imagePath);
    NSLog(@"视频路径：%@" , moviePath);
        [fm removeItemAtPath:imagePath error:&error];
        [fm removeItemAtPath:moviePath error:&error];
    if (error) {
        NSLog(@"%@" , error);
    }
    [self.appdelegate.managedObjectContext deleteObject:movieModel];
    [self.appdelegate.managedObjectContext save:nil];

        [self.dataSourceImage removeObjectAtIndex:sender.tag - 1000];
//
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];

//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
//    [self.dataSourceImage removeAllObjects];
//    [self getDataForFile];
//    [self.collectionView reloadData];


}


#pragma mark - Layout Delegate
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForIndexPath:(NSIndexPath *)indexPath{
    

    Movie *model = self.dataSourceImage[indexPath.row];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Movie/%@" , model.movieImageName]];
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
