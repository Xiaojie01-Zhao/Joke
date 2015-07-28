//
//  ViewController.m
//  JOKE
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "ViewController.h"
#import "JokeCell.h"

#import "JokeModel.h"


#define kUrl @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=1&level=6&message_cursor=-1&loc_mode=6&loc_time=1437796161&latitude=34.83101445244&longitude=113.56858354539&city=%E9%83%91%E5%B7%9E%E5%B8%82&count=30&min_time=1437796257&iid=2638530606&device_id=2642690739&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=341&device_platform=android&device_type=MI%203W&os_api=19&os_version=4.4.4&uuid=864690025797997&openudid=3b911d7ca03aad5d"

@interface ViewController () <UITableViewDataSource , UITableViewDelegate , UITabBarDelegate>
{
    BOOL isRefresh;
    BOOL isOne;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataSource;



@end

static NSString *cellID = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isOne = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"jiazai"];
    [self.tableView.backgroundView addSubview:imageView];
//    self.tableView.backgroundColor = [UIColor redColor];
    
    // tabbr 剔除半通明效果

    // 分割线样式
    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
 
//    [self.tableView registerClass:[JokeCell class] forCellReuseIdentifier:@"cell"];
    
    // 导航条的毛玻璃效果剔除
    self.navigationController.navigationBar.translucent = NO;
    // 配置上下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(shuaXin) ];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];

    
    self.dataSource = [NSMutableArray array];
    
    // 请求数据
    [self getDataFromJoke];
    
    
}
// 打开程序白板问题
- (void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)getDataFromJoke{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:kUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (isRefresh) {
            [self.dataSource removeAllObjects];
        }
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        // 刷新了多少条数据
//        NSString *tip = dataDic[@"tip"];

        
        NSArray *allDataArr = dataDic[@"data"];
        NSLog(@"%ld" , allDataArr.count);

        // 遍历数组
        /*
        for (NSDictionary *oneDic in allDataArr) {


            JokeModel *model = [[JokeModel alloc]init];
            NSDictionary *groupDic =  oneDic[@"group"];

            model.content = groupDic[@"conten"];
            NSLog(@"%@" , groupDic[@"conten"]);
            NSDictionary *userDic = dic[@"user"];

//            NSLog(@"%@" , userDic);
            model.avatar_url = userDic[@"avatar_url"];
            model.name = userDic[@"name"];

            [self.dataSource addObject:model];
        }
         */
        for (NSInteger i = 0; i < allDataArr.count; i++) {
            NSDictionary *waiDic  =   allDataArr[i];
            NSDictionary *groupDic = waiDic[@"group"];

            JokeModel *model = [[JokeModel alloc]init];
            model.content = groupDic[@"content"];
            
            if (model.content.length == 0) {
                continue;
            }
            NSDictionary *userDic = groupDic[@"user"];
            model.avatar_url = userDic[@"avatar_url"];
            model.name = userDic[@"name"];
            
            [self.dataSource addObject:model];
            
        }
        // 刷新数据
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@" , error);
    }];
 
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    //配置cell
    
    [self configureCell:cell atIndexpath:indexPath];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isOne) {
        cell.alpha = 0;
        isOne = NO;
    }
    
}
#pragma mark - 配置cell
- (void)configureCell:(JokeCell *)cell atIndexpath:(NSIndexPath *)indexPath{
    
    JokeModel *model = self.dataSource[indexPath.row];
    NSLog(@"%@" , model);
//    cell.imageView.layer.masksToBounds = YES;
//    cell.imageView.layer.cornerRadius = 15;
    if (model.avatar_url != nil) {
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    }
    if (!model.name.length == 0) {
        cell.userName.text = model.name;
    } else {
        cell.userName.text = @"匿名用户";
    }
    cell.contentLabel.text = model.content;


    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

#pragma mark - // 自适应cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static JokeCell *cell = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    });
    // 配置cell
    [self configureCell:cell atIndexpath:indexPath];
    
    //配置cell 的bounds
    cell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), 10000);
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // 计算cell的高度
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - 刷新数据
- (void)shuaXin{
    isRefresh = YES;
    [self getDataFromJoke];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
        isRefresh = NO;
    });
}
- (void)getMore{
    NSInteger row = self.dataSource.count;

    [self getDataFromJoke];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.footer endRefreshing];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    });
    
}

- (CGFloat)chechCacheSize{
    float totalSize = 0;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *picturePath = [cachePath stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:picturePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [picturePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long lenth = [attrs fileSize];
        totalSize += lenth / 1024.0 / 1024.0;
    }
    NSLog(@"cache size is %.2f" , totalSize);
    return totalSize;
}
- (void)clearCachePics{
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
//    float cacheSize = [SDImageCache sharedImageCache] che
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
