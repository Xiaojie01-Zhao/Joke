//
//  WaterFlowLayout.h
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowLayout : UICollectionViewLayout


@property (nonatomic , assign) id<WaterFlowLayoutDelegate> delegate;

@property (nonatomic , assign) NSInteger numberOfColumns;
@property (nonatomic , assign) CGFloat itemWidth;
@property (nonatomic , assign) UIEdgeInsets sectionIndexs;



@end
