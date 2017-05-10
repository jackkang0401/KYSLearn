//
//  KYSBaseCollectionViewFlowLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/2.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSBaseCollectionViewFlowLayout.h"

@implementation KYSBaseCollectionViewFlowLayout

#pragma mark - data
- (BOOL)isHorizontal{
    return UICollectionViewScrollDirectionHorizontal==self.scrollDirection;
}

- (CGFloat)viewHeight{
    return self.isHorizontal?CGRectGetHeight(self.collectionView.frame):CGRectGetWidth(self.collectionView.frame);
}

- (CGFloat)viewWidth{
    return self.isHorizontal?CGRectGetWidth(self.collectionView.frame):CGRectGetHeight(self.collectionView.frame);
}

- (CGFloat)contentOffsetX{
    return self.isHorizontal?self.collectionView.contentOffset.x:self.collectionView.contentOffset.y;
}

- (CGFloat)contentOffsetY{
    return self.isHorizontal?self.collectionView.contentOffset.y:self.collectionView.contentOffset.x;
}

- (CGFloat)itemHeight{
    return self.isHorizontal?self.itemSize.height:self.itemSize.width;
}

- (CGFloat)itemWidth{
    return self.isHorizontal?self.itemSize.width:self.itemSize.height;
}

//最边上的也可以划到中间位置
- (void)makeSideItemCanScrollCenter{
    //设置内边距
    CGFloat inset = (self.viewWidth-self.itemWidth)*0.5;
    if (self.isHorizontal) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    }else{
        self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
    }
}

//滑动停止时cell处在中间位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat proposedContentOffsetXY = self.isHorizontal?proposedContentOffset.x:proposedContentOffset.y;
    CGFloat horizontalCenter = proposedContentOffsetXY + (self.viewWidth*0.5);
    
    CGSize size=self.collectionView.bounds.size;
    CGRect targetRect = {proposedContentOffsetXY, 0.0, size.width, size.height};
    if (!self.isHorizontal) {
        targetRect = (CGRect){0.0, proposedContentOffsetXY, size.width, size.height};
    }
    
    //找出距离中心位置距离最小的值
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = self.isHorizontal?layoutAttributes.center.x:layoutAttributes.center.y;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    if (self.isHorizontal) {
        proposedContentOffset.x=proposedContentOffset.x + offsetAdjustment;
    }else{
        proposedContentOffset.y=proposedContentOffset.y + offsetAdjustment;
    }
    return proposedContentOffset;
}

@end
