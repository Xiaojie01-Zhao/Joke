//
//  ViewController.m
//  JOKE
//
//  Created by lanouhn on 15/7/25.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "ViewController.h"
#import "JokeCell.h"

#import "AFNetworking.h"
#import "JokeModel.h"
#import "UIImageView+WebCache.h"


#define kUrl @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=1&level=6&message_cursor=-1&loc_mode=6&loc_time=1437796161&latitude=34.83101445244&longitude=113.56858354539&city=%E9%83%91%E5%B7%9E%E5%B8%82&count=30&min_time=1437796257&iid=2638530606&device_id=2642690739&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=341&device_platform=android&device_type=MI%203W&os_api=19&os_version=4.4.4&uuid=864690025797997&openudid=3b911d7ca03aad5d"

@interface ViewController () <UITableViewDataSource , UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataSource;


@end

static NSString *cellID = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
//    [self.tableView registerClass:[JokeCell class] forCellReuseIdentifier:@"cell"];
    // 导航条的毛玻璃效果剔除
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.dataSource = [NSMutableArray array];
    
    // 请求数据
    [self getDataFromJoke];
    
    
}
- (void)getDataFromJoke{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:kUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        // 刷新了多少条数据
        NSString *tip = dataDic[@"tip"];

        
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
            
            NSDictionary *userDic = groupDic[@"user"];
            model.avatar_url = userDic[@"avatar_url"];
            model.name = userDic[@"name"];
            
            [self.dataSource addObject:model];

            
        }
//        NSLog(@"%@" , self.dataSource);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@" , error);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

//    JokeModel *model = self.dataSource[indexPath.row];
//    NSLog(@"%@" , model);
//    cell.imageView.layer.masksToBounds = YES;
//    cell.imageView.layer.cornerRadius = 15;
//    
//    if (model.avatar_url != nil) {
//        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
//    }
//    if (!model.name.length == 0) {
//        cell.userName.text = model.name;
//    } else {
//        cell.userName.text = @"匿名用户";
//    }
    
//    cell.contentLabel.text = model.content;


    
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
