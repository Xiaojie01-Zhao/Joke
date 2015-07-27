//
//  PictureTableViewController.m
//  JOKE
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#define kUrl @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=2&level=6&message_cursor=-1&loc_mode=6&loc_time=1437805502&latitude=34.83101489689&longitude=113.56857258606&city=%E9%83%91%E5%B7%9E%E5%B8%82&count=30&min_time=1437805574&iid=2638530606&device_id=2642690739&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=341&device_platform=android&device_type=MI%203W&os_api=19&os_version=4.4.4&uuid=864690025797997&openudid=3b911d7ca03aad5d"

#import "PictureTableViewController.h"
#import "PictureCell.h"
#import "PictureModel.h"
@interface PictureTableViewController () <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *dataSource;

@end

static NSString *cellID = @"cell";

@implementation PictureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
 
    [self getDataFromPicture];
}
- (void)getDataFromPicture{
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    
    [manage GET:kUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *bigDic = responseObject;
        NSDictionary *dataDic = bigDic[@"data"];
        
//        NSString *tip = dataDic[@"tip"];
        NSArray *dataArray = dataDic[@"data"];
        
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary *dic = dataArray[i];
            NSDictionary *groupDic = dic[@"group"];
            PictureModel *model = [[PictureModel alloc]init];
            model.content = groupDic[@"content"];
            
            NSDictionary *userDic = groupDic[@"user"];
            model.userIcon = userDic[@"avatar_url"];
            model.name = userDic[@"name"];

            // 内容图片
            NSDictionary *large_imageDic = groupDic[@"large_image"];
            NSArray *urlArr = large_imageDic[@"url_list"];
            NSDictionary *urlDic = urlArr[0];
            model.contentImageUrlStr = urlDic[@"url"];
            
            [self.dataSource addObject:model];
        }
        NSLog(@"%@" , self.dataSource);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@" , error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    [self configurationCellForCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configurationCellForCell:(PictureCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    PictureModel *model = self.dataSource[indexPath.row];
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:nil];
    if (model.name.length != 0) {
        cell.namelabel.text = model.name;
    } else {
        cell.namelabel.text = @"匿名用户";
    }
    cell.contentLabel.text = model.content;
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.contentImageUrlStr] placeholderImage:nil];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
