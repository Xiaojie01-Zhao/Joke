//
//  WaterFlowLayout.m
//  JOKE
//
//  Created by lanouhn on 15/8/1.
//  Copyright (c) 2015年 ACE--赵肖杰. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()

@property (nonatomic , assign) NSInteger numberOfItems;
@property (nonatomic , assign) CGFloat interItemSpacing;
@property (nonatomic , strong) NSMutableArray *columnsHeight;

@property (nonatomic , strong) NSMutableArray *itemAttributes;


@end

@implementation WaterFlowLayout

- (NSMutableArray *)columnsHeight{
    
    if (!_columnsHeight) {
        self.columnsHeight = [NSMutableArray array];
    }
    return _columnsHeight;
}
- (NSMutableArray *)itemAttributes{
    if (!_itemAttributes) {
        self.itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

#pragma mark - 计算最低一列高度的下标
- (NSInteger)shortestColumnHeight{
    
    NSInteger index = 0;
    CGFloat lowestHeight = CGFLOAT_MAX;
    
    for (int i = 0; i < self.columnsHeight.count; i++) {
        CGFloat heigt = [self.columnsHeight[i] floatValue];
        if (lowestHeight > heigt) {
            lowestHeight = heigt;
            index = i;
        }
    }
    return index;
}

#pragma mark - 找到最高的那一列的 下标
- (NSInteger)longnestColumn
{
    //准备下标
    NSInteger index = 0;
    //准备一个最小值，用来拿到最高的那一列的高度
    CGFloat longestHeight = CGFLOAT_MIN;
    for (int i = 0; i < self.columnsHeight.count; i++) {
        CGFloat currentHeight = [self.columnsHeight[i]floatValue];
        if (currentHeight > longestHeight) {
            longestHeight = currentHeight;
            index = i;
        }
    }
    return index;
}
#pragma mark - 计算每一个item位置
- (void)calculateItems
{
    //拿到所有的items
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];//瀑布流只有一个分区
    //得到collectionView的有效宽度
    CGFloat contentWidth = CGRectGetWidth(self.collectionView.frame) - self.sectionIndexs.left - self.sectionIndexs.right;
    //计算item列之间的距离
    self.interItemSpacing = (contentWidth - self.itemWidth * self.numberOfColumns) / (self.numberOfColumns - 1);
    //保存每一列的初始高度
    for (int i = 0; i < self.numberOfColumns; i++) {
        self.columnsHeight[i] = @(self.sectionIndexs.top);//value转对象（NSNumber）
    }
    //根据collectionView所管理的item的数量，产生循环，每循环一次，计算出当前item的frame
    for (int i = 0; i < self.numberOfItems; i++) {
        //为每一个item对象创建对应的indexPath对象
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //
        CGFloat itemHeight = 0;
        //给代理一个indexPath ，让代理帮我算出indexPath这个为的item的高度
        if (_delegate && [_delegate respondsToSelector:@selector(collectionView:waterFlowLayout:heightForIndexPath:)]) {
            itemHeight = [_delegate collectionView:self.collectionView waterFlowLayout:self heightForIndexPath:indexPath];
        }
        //获取最短的一列的下标
        NSInteger shortestIndex = [self shortestColumnHeight];
        //开始布局，的另外准备两个变量 （origin_x , origin_y）
        CGFloat origin_x = self.sectionIndexs.left + (self.itemWidth + self.interItemSpacing) * shortestIndex;
        CGFloat origin_y = [self.columnsHeight[shortestIndex] floatValue];
        
        //根据indexPath创建布局属性的对象
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //设置布局对象的frame的值
        attributes.frame = CGRectMake(origin_x, origin_y, self.itemWidth, itemHeight);
        //向保存item的布局属性数组中，添加最终计算出来的frame大小的布局对象
        [self.itemAttributes addObject:attributes];
        //更新columnHeight数组中得当前最短列的高度
        self.columnsHeight[shortestIndex] = @(origin_y + itemHeight + self.interItemSpacing);
    }
}
//下面的是系统的方法（调用上面的自定义方法，完成功能）
#pragma mark - 一旦布局对象(self.itemAttributes这个数组中放着)交给集合视图之后，就回调下面的方法
- (void)prepareLayout
{
    [super prepareLayout];
    //计算每一个item的frame
    [self calculateItems];
}
#pragma mark - 设置文本显示区域size的协议方法
- (CGSize)collectionViewContentSize
{
    //获取集合视图size的大小
    CGSize contentSize = self.collectionView.frame.size;
    //获取最长那一列的下标
    NSInteger index = [self longnestColumn];
    // 根据拿到的最长那一列的下标，在列数组中。拿到该列的高度
    CGFloat longesHeight = [self.columnsHeight[index] floatValue];
    //根据最长列的高度，设置collectionView的内容的高度
    contentSize.height = longesHeight - self.interItemSpacing + self.sectionIndexs.bottom;
    return contentSize;
}
//开始用每一个item的布局属性对象
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemAttributes;
}

@end
