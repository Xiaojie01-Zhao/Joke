//
//  JokeCell.h
//  JOKE
//
//  Created by lanouhn on 15/7/27.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dianZan;
// 鄙视
@property (weak, nonatomic) IBOutlet UIButton *contempt;
@property (weak, nonatomic) IBOutlet UIButton *share;


@end
