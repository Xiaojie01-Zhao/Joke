//
//  VideoModel.h
//  JOKE
//
//  Created by lanouhn on 15/7/28.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic , copy) NSString *userIcon;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *contentVideoUrlStr;
@property (nonatomic , copy) NSString *contentPlaceholderImageUrlStr;

@property (nonatomic ,assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@end
