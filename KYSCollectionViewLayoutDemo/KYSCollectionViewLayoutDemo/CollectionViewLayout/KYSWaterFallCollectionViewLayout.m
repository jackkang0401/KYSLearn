//
//  KYSWaterFallCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/10.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSWaterFallCollectionViewLayout.h"

@interface KYSWaterFallCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *attrsArray;
@property (nonatomic, strong) NSMutableArray *columnHeights;//记录每列的高度

@end

@implementation KYSWaterFallCollectionViewLayout

- (NSMutableArray *)columnHeights{
    if (nil == _columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (nil == _attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)dealloc{
    self.heightBlock = nil;
}

#pragma mark - 覆写方法
//数据源更新时会调用
- (void)prepareLayout{
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
    
    if (self.columnCount <= 0.0) {
        self.columnCount=4;
    }
    if (self.rowMargin <= 0.0) {
        self.rowMargin=12.0;
    }
    if (self.columnMargin <= 0.0) {
        self.columnMargin=12.0;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(self.edgeInsets, UIEdgeInsetsZero) ) {
        self.edgeInsets=(UIEdgeInsets){12.0, 12.0, 12.0, 12.0};
    }
    
    [self.columnHeights removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清空item布局属性数组
    [self.attrsArray removeAllObjects];
    //计算所有cell的attrs
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [self.attrsArray addObject:attrs];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"layoutAttributesForItemAtIndexPath:");
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat width = (collectionViewWidth-self.edgeInsets.left-self.edgeInsets.right-(self.columnCount-1)*self.columnMargin)/self.columnCount;
    
    //找出最小高度的列
    __block NSUInteger minColumn = 0;
    __block CGFloat minHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull height, NSUInteger index, BOOL * _Nonnull stop) {
        if (minHeight > [height doubleValue]) {
            minHeight = [height doubleValue];
            minColumn = index;
        }
    }];
    
    //计算cell位置
    CGFloat x = self.edgeInsets.left + minColumn * (self.columnMargin + width);
    CGFloat y = minHeight + [self rowMargin];
    //计算高度
    CGFloat height=64.0;
    if (self.heightBlock) {
        height = self.heightBlock(indexPath.item, width);
    }
    //设置cell的frame
    attrs.frame = CGRectMake(x, y, width, height);
    //更新高度数组
    self.columnHeights[minColumn] = @(y + height);
    
    return attrs;
}

- (CGSize)collectionViewContentSize{
    __block CGFloat maxY = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull height, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([height doubleValue] > maxY) {
            maxY = [height doubleValue];
        }
    }];
    return CGSizeMake(0, maxY + [self edgeInsets].bottom);
}


////计算出所有cell的frame
////和创建UICollectionViewLayoutAttributes 对象好像没太大区别（个数都一样），还不用用到再计算
//- (NSDictionary *)getAttributeFrames{
//    //保存所有的frame
//    NSMutableDictionary *attrsFramesDic=[[NSMutableDictionary alloc] init];
//    NSMutableArray *colummHeightArray=[[NSMutableArray alloc] init];
//    for (int i = 0; i < self.columnCount; i++) {
//        [colummHeightArray addObject:@(self.edgeInsets.top)];
//    }
//    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
//    CGFloat width = (collectionViewWidth-self.edgeInsets.left-self.edgeInsets.right-(self.columnCount-1)*self.columnMargin)/self.columnCount;
//
//    //计算所有cell的attrs
//    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i < count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//
//        //得到最小的height及对应的column
//        __block NSUInteger minColumn = 0;
//        __block CGFloat minHeight = MAXFLOAT;
//        [colummHeightArray enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull height, NSUInteger index, BOOL * _Nonnull stop) {
//            if (minHeight > [height doubleValue]) {
//                minHeight = [height doubleValue];
//                minColumn = index;
//            }
//        }];
//        //计算对应indexPath的frame
//        CGFloat x = self.edgeInsets.left + minColumn * (self.columnMargin + width);
//        CGFloat y = minHeight + self.rowMargin;
//        CGFloat height = [self.delegate waterFallLayout:self heightForItemAtIndex:indexPath.item width:width];
//        CGRect frame = CGRectMake(x, y, width, height);
//        NSValue *frameValue = [NSValue valueWithCGRect:frame];
//
//        //存入attrsFramesDic
//        [attrsFramesDic setObject:frameValue forKey:[indexPath kys_itemKey]];
//
//        //更新记录高度数组
//        colummHeightArray[minColumn] = @(y + height);
//    }
//
//    return [attrsFramesDic copy];
//}

@end
