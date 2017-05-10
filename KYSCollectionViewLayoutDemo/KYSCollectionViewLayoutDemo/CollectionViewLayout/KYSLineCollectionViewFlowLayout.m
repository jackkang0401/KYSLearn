//
//  KYSLineCollectionViewFlowLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSLineCollectionViewFlowLayout.h"

@interface KYSLineCollectionViewFlowLayout()


@end

@implementation KYSLineCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    //设置内边距（最边上的也可以划到中间位置）
    [self makeSideItemCanScrollCenter];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSLog(@"layoutAttributesForElementsInRect:");
    
    //通过父类获取rect范围内所有的布局
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //获得collectionView中心位置
    CGFloat centerXY = self.contentOffsetX + self.viewWidth*0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        //计算元素到中心的距离
        CGFloat layoutCenterXY=(self.isHorizontal?attrs.center.x:attrs.center.y);
        CGFloat delta = ABS(centerXY - layoutCenterXY);
        //cell大小与中心距离成反比，计算缩放比率
        CGFloat scale = 1.0 - delta / (self.viewWidth + self.itemWidth);
        //修改布局属性
        attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
        attrs.zIndex = 1;
    }
    return array;
}

//控制何时刷新布局
//返回YES会刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    NSLog(@"shouldInvalidateLayoutForBoundsChange:%@,%@",NSStringFromCGRect(self.collectionView.bounds),NSStringFromCGRect(newBounds));
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}



@end
