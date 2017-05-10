//
//  KYSRotaryCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/5.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSRotaryCollectionViewLayout.h"

@implementation KYSRotaryCollectionViewLayout

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
    NSInteger index = (self.contentOffsetX+self.viewWidth*0.5)/self.itemWidth;
    NSInteger count = (self.maxVisableItems-1)>>1;
    NSInteger minIndex = MAX(0, (index - count));
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
    
    CGFloat contentOffsetCenterX = self.contentOffsetX + self.viewWidth*0.5;
    CGFloat attrsCenterX = self.itemWidth*indexPath.row + self.itemWidth*0.5;
    attrs.zIndex = -ABS(attrsCenterX - contentOffsetCenterX);
    CGFloat delta = contentOffsetCenterX - attrsCenterX;

    CGFloat ratio =  - delta / (self.itemWidth * 2.0);
    CGFloat scale = 1 - ABS(delta) / (self.viewWidth) * cos(ratio * M_PI_4);
    attrs.transform = CGAffineTransformMakeScale(scale, scale);//缩放
    attrs.transform = CGAffineTransformRotate(attrs.transform, - ratio*M_PI_4);//旋转
    attrs.center=[self getAttributesCenterWithIndexPath:indexPath centerX:attrsCenterX+sin(ratio*M_PI_2)*self.itemWidth*0.5];
    
    return attrs;
}

@end
