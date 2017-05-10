//
//  KYSLineCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/4.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSLineCollectionViewLayout.h"

@interface KYSLineCollectionViewLayout ()

@end

@implementation KYSLineCollectionViewLayout

//第一次布局和布局失败时会调用，子类要调super
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.maxVisableItems < 1) {
        self.maxVisableItems = 5;
    }
    //设置内边距（最边上的也可以划到中间位置）
    [self makeSideItemCanScrollCenter];
}

//collectionView的的滚动范围
- (CGSize)collectionViewContentSize {
    return [self calculateCollectionViewContentSize];
}

//返回rect范围内所有元素的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //处在中心的cell的index
    NSInteger index = (self.contentOffsetX+self.viewWidth*0.5)/self.itemWidth;
    //可以理解为中心位置的两侧各有几个cell
    NSInteger count = (self.maxVisableItems-1)>>1;
    //rect范围内第一个cell的index
    NSInteger minIndex = MAX(0, (index - count));
    //rect范围内的最后一个cell的index
    NSInteger maxIndex = MIN((self.itemCount-1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

//返回indexPath对应的cell的布局属性，设置动画
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = self.itemSize;
    
    //collectionView此时滑动区域的中心位置
    CGFloat contentOffsetCenterX = self.contentOffsetX + self.viewWidth*0.5;
    //当前cell的中心位置
    CGFloat attrsCenterX = self.itemWidth*indexPath.row + self.itemWidth*0.5;
    //值越小，层级越低
    attrs.zIndex = -ABS(attrsCenterX - contentOffsetCenterX);
    //滑动区域的中心与cell中心距离
    CGFloat delta = contentOffsetCenterX - attrsCenterX;
    
    //下边的2行没太懂，应该是让滑动过程中变化更加好看一些
    CGFloat ratio =  - delta / (self.itemWidth * 2.0);
    CGFloat scale = 1 - ABS(delta) / (self.viewWidth) * cos(ratio * M_PI_4);
    //也可以用transform3D实现变换
    attrs.transform = CGAffineTransformMakeScale(scale, scale);
    
    attrs.center=[self getAttributesCenterWithIndexPath:indexPath centerX:attrsCenterX];
    
    return attrs;
}

@end
