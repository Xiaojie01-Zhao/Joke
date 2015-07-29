//
//  VideoTVC.m
//  JOKE
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#define kUrl @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=18&level=6&message_cursor=-1&loc_mode=6&loc_time=1437805502&latitude=34.83101489689&longitude=113.56857258606&city=%E9%83%91%E5%B7%9E%E5%B8%82&count=30&min_time=1437731122&iid=2638530606&device_id=2642690739&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=341&device_platform=android&device_type=MI%203W&os_api=19&os_version=4.4.4&uuid=864690025797997&openudid=3b911d7ca03aad5d"

#import "VideoTVC.h"
#import "VideoCell.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPalyerView.h"

@interface VideoTVC ()
{
   BOOL isRefresh;
}
@property (nonatomic , strong) NSMutableArray *dataSource;

// 视频
@property (nonatomic , strong) AVPalyerView *avPlayerView;
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , assign) BOOL isFirstTap;
@property (nonatomic , assign) BOOL isPlayOrParse;
@property (nonatomic , assign) BOOL isBigPlayer;
// 保存视频的总时长
@property (nonatomic , assign) CGFloat totalMovieDuration;
@property (nonatomic , strong) NSURL *movieURL;

@end

static NSString *cellID = @"cell";

@implementation VideoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self getDataForVideo];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isRefresh = YES;
        [self getDataForVideo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView.header endRefreshing];
            isRefresh = NO;
        });
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getDataForVideo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        });
    }];
}
- (void)getDataForVideo{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (isRefresh) {
            [self.dataSource removeAllObjects];
        }
        
        NSDictionary *bigDic = responseObject;
        NSDictionary *dataDic = bigDic[@"data"];
        
//        NSString *tip = dataDic[@"tip"];

        NSArray *dataArr = dataDic[@"data"];
        
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary *allGroupDic = dataArr[i];
            VideoModel *model = [[VideoModel alloc]init];
            
            NSDictionary *groupDic = allGroupDic[@"group"];
            model.contentVideoUrlStr = groupDic[@"mp4_url"];
            model.content = groupDic[@"text"];
            
            NSDictionary *large_coverDic = groupDic[@"large_cover"];
            NSArray *urlArr = large_coverDic[@"url_list"];
            
            NSDictionary *urlDic = urlArr[0];
            
            model.contentPlaceholderImageUrlStr = urlDic[@"url"];
            if (model.contentPlaceholderImageUrlStr.length == 0) {
                continue;
            }
            
            NSDictionary *userDic = groupDic[@"user"];
            model.userIcon = userDic[@"avatar_url"];
            model.name = userDic[@"name"];
            
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[VideoCell alloc]awakeFromNib];
//    }
    // 解决cell 的重用导致cell 的内容重复
    
    if (cell) {
        while ([cell.contentImageView.subviews lastObject] != nil) {
            [[cell.contentImageView.subviews lastObject] removeFromSuperview];
        }
        while ([cell.contentImageView.layer.sublayers lastObject] != nil) {
            [[cell.contentImageView.layer.sublayers lastObject] removeFromSuperlayer];
        }
    }
   
    
    // 配置cell
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(VideoCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    VideoModel *model = self.dataSource[indexPath.row];
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon]];
    cell.nameLabel.text = model.name;
    cell.contentLabel.text = model.content;
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.contentPlaceholderImageUrlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
}
#pragma mark - 滑动tableView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"滑动tableView");
    //  视屏播放器暂停
    [self.player pause];
    //  切换图片
    [self.avPlayerView.bigPlayButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    self.avPlayerView.bottomOperationView.alpha = 0.68;
    self.isBigPlayer = NO;

    
    self.avPlayerView.bigPlayButton.alpha = 1;
    self.isFirstTap = NO;

    //  切换图片
    [self.avPlayerView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    self.isPlayOrParse = NO;

}
#pragma  mark - big播放
- (void)playMovieAction:(UIButton *)sender{
    
    NSLog(@"***************########%@" , [sender.superview.superview.superview.superview class]);
    if (!self.isBigPlayer) {
        [self.player play];
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        
        self.isBigPlayer = YES;
        __weak typeof(self) myself = self;
        [UIView animateWithDuration:0.2f animations:^{
            myself.avPlayerView.bigPlayButton.alpha  = 0;
            myself.avPlayerView.bottomOperationView.alpha = 0;
        }];
    } else {
        //  视屏播放器暂停
        [self.player pause];
        
        //  切换图片
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
        self.avPlayerView.bottomOperationView.alpha = 0.68;
        self.isBigPlayer = NO;
        
    }
}
#pragma mark - cell点击事件 加载播放器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    VideoCell *cell0 = (VideoCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
    if (self.avPlayerView) {
        [self.avPlayerView removeFromSuperview];
        self.movieURL = nil;
        self.player = nil;
//        [cell0.contentImageView.layer removeFromSuperlayer];
        [self removeObserverFromPlayerItem:self.player.currentItem];
    }
    
    VideoCell *cell = (VideoCell *)[tableView cellForRowAtIndexPath:indexPath];
    VideoModel *model = self.dataSource[indexPath.row];

    NSLog(@"*******************%@" , model.contentVideoUrlStr);

    self.movieURL = [NSURL URLWithString:model.contentVideoUrlStr];
   
    
    // cell上添加播放器
    cell.contentImageView.userInteractionEnabled = YES;
    self.avPlayerView  = [[AVPalyerView alloc]initWithFrame:CGRectMake(0, 0, cell.contentImageView.frame.size.width, cell.contentImageView.frame.size.height)];
    [cell.contentImageView addSubview:self.avPlayerView];
    
    // 配置播放器功能
    [self configurePlayer:(VideoCell *)cell];

}
- (void)configurePlayer:(VideoCell *)cell{
    
    // 观察是否播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    // 创建视频播放层
    // 显示层
    AVPlayerLayer *playerLayer  = [ AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(self.avPlayerView.frame.origin.x, self.avPlayerView.frame.origin.y, self.avPlayerView.frame.size.width, self.avPlayerView.frame.size.height);
    
    
    // 视频的填充方式
    playerLayer.videoGravity = AVLayerVideoGravityResize ;
    
    // 插入到view的层上面，我没有用addSublayer，因为我想让播放的视图在最下层
    [cell.contentImageView.layer insertSublayer:playerLayer atIndex:0];
    
    // big播放
    [self.avPlayerView.bigPlayButton addTarget:self action:@selector(playMovieAction:) forControlEvents:UIControlEventTouchUpInside];
    // 播放
    [self.avPlayerView.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //  给进度的滑杆设置事件
    [self.avPlayerView.progressSlider addTarget:self action:@selector(scrubberIsScrolling:) forControlEvents:UIControlEventValueChanged];
    
    //  缓存按钮的点击事件
    [self.avPlayerView.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  播放页面添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllSubviews:)];
    [self.avPlayerView addGestureRecognizer:tap];
    
}
#pragma mark 缓存按钮的点击事件
- (void)saveButtonAction:(UIButton *)sender
{
    NSLog(@"您点击了下载！");
}
#pragma mark 轻拍手势的事件
//  用于把上面的操作视图动画隐藏
- (void)dismissAllSubviews:(UITapGestureRecognizer *)tap
{
    //  防止循环引用，讲过的！
    __weak typeof(self) myself = self;
    if (!self.isFirstTap) {
        // 隐藏
        [UIView animateWithDuration:.2f animations:^{
            
            
            //            myself.avPlayerView.bottomOperationView.frame = CGRectMake(0, 0, self.avPlayerView.bounds.size.width, 65);
            myself.avPlayerView.bottomOperationView.alpha = 0;
            myself.isFirstTap = YES;
            
            myself.avPlayerView.bigPlayButton.alpha = 0;

            
        }];
    } else{
        [UIView animateWithDuration:.2f animations:^{
            
            //        myself.avPlayerView.bottomOperationView.frame = CGRectMake(0, 65, self.avPlayerView.bounds.size.width, 65);
            myself.avPlayerView.bottomOperationView.alpha = 0.68;
            
            myself.avPlayerView.bigPlayButton.alpha = 1;
            myself.isFirstTap = NO;
        }];
        
    }
}

#pragma mark 播放或暂停
- (void)playButtonAction:(UIButton *)sender
{
    
    //  在这里你可以自己设置bool值来判断是否正在播放或者已经停止，也可以通过，播放器自带的rate属性，当rate为0时，为暂停，当rate为1时为正在播放
    
    if (!self.isPlayOrParse) {
        [self.player play];
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        self.isPlayOrParse = YES;
        
        __weak typeof(self) myself = self;
        [UIView animateWithDuration:.2f animations:^{
            
            myself.avPlayerView.bottomOperationView.alpha = 0;
            myself.isFirstTap = YES;
            
        }];
        
    } else{
        //  视屏播放器暂停
        [self.player pause];
        
        //  切换图片
        [sender setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
        self.isPlayOrParse = NO;
        
    }
}
#pragma mark 调节进度
- (void)scrubberIsScrolling:(UISlider *)sender
{
    //  先暂停
    [self.player pause];
    //  图片切换
    [self.avPlayerView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
    
    float current = (float)(self.totalMovieDuration * sender.value);
    CMTime currentTime = CMTimeMake(current, 1);
    //  给avplayer设置进度
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        [self.avPlayerView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
        [self.player play];
    }];
    
}
#pragma mark 播放结束后的代理回调
- (void)moviePlayDidEnd:(NSNotification *)notify
{
    // 循环播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player pause];
        self.avPlayerView.progressSlider.value = 0;
        //  播放按钮设置成播放图片
        [self.avPlayerView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_播放"] forState:UIControlStateNormal];
        CMTime currentTime = CMTimeMake(0, 1);
        [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
            [self.avPlayerView.playButton setBackgroundImage:[UIImage imageNamed:@"播放器_暂停"] forState:UIControlStateNormal];
            [self.player play];
        }];
        
    });
    
}
- (AVPlayer *)player
{
    if (!_player) {
            if (self.movieURL) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.movieURL];
            
            // NSLog(@"%@", item.duration);
            self.player = [AVPlayer playerWithPlayerItem:item];
            //  添加进度观察
            [self addProgressObserver];
            
            [self addObserverToPlayerItem:item];
            
        }
    }
    return _player;
}
//  依靠AVPlayer的- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block方法获得播放进度，这个方法会在设定的时间间隔内定时更新播放进度，通过time参数通知客户端。相信有了这些视频信息播放进度就不成问题了，事实上通过这些信息就算是平时看到的其他播放器的缓冲进度显示以及拖动播放的功能也可以顺利的实现。
- (void)addProgressObserver{
    //  获取当前媒体资源管理对象
    AVPlayerItem *playerItem = self.player.currentItem;
    
    __weak typeof(self) mySelf = self;
    //  设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //  获取当前的进度
        float current = CMTimeGetSeconds(time);
        //  获取全部资源的大小
        float total = CMTimeGetSeconds([playerItem duration]);
        //  计算出进度
        if (current) {
            [mySelf.avPlayerView.progressSlider setValue:(current / total) animated:YES];
            
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:current];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            if (current/3600 >=1) {
                [formatter setDateFormat:@"HH:mm:ss"];
            }else{
                [formatter setDateFormat:@"mm:ss"];
            }
            NSString * showTimeNew = [formatter stringFromDate:d];
            
            mySelf.avPlayerView.startTimeLabel.adjustsFontSizeToFitWidth = YES;
            
            mySelf.avPlayerView.startTimeLabel.text = showTimeNew;
            
            
            
        }
    }];
    
}
//  这个方法，用来取得播放进度，播放进度就没有其他播放器那么简单了。在系统播放器中通常是使用通知来获得播放器的状态，媒体加载状态等，但是无论是AVPlayer还是AVPlayerItem（AVPlayer有一个属性currentItem是AVPlayerItem类型，表示当前播放的视频对象）都无法获得这些信息。当然AVPlayerItem是有通知的，但是对于获得播放状态和加载状态有用的通知只有一个：播放完成通知AVPlayerItemDidPlayToEndTimeNotification。在播放视频时，特别是播放网络视频往往需要知道视频加载情况、缓冲情况、播放情况，这些信息可以通过KVO监控AVPlayerItem的status、loadedTimeRanges属性来获得当AVPlayerItem的status属性为AVPlayerStatusReadyToPlay是说明正在播放，只有处于这个状态时才能获得视频时长等信息；当loadedTimeRanges的改变时（每缓冲一部分数据就会更新此属性）可以获得本次缓冲加载的视频范围（包含起始时间、本次加载时长），这样一来就可以实时获得缓冲情况。

-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
//  观察者的方法，会在加载好后触发，我们可以在这个方法中，保存总文件的大小，用于后面的进度的实现
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            
            CMTime totalTime = playerItem.duration;
            //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
            self.totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
            
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:_totalMovieDuration];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            if (_totalMovieDuration/3600 >=1) {
                [formatter setDateFormat:@"HH:mm:ss"];
            }else{
                [formatter setDateFormat:@"mm:ss"];
            }
            NSString * showTimeNew = [formatter stringFromDate:d];
            self.avPlayerView.endTimeLabel.adjustsFontSizeToFitWidth = YES;
            self.avPlayerView.endTimeLabel.text = showTimeNew;
            
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"%.2f , %.2f" , startSeconds , durationSeconds);
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}
- (void)dealloc
{
    //  移除观察者
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
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
