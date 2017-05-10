//
//  KYSBaseCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSBaseCollectionViewLayout.h"

@implementation KYSBaseCollectionViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - my method
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

- (NSInteger)itemCount{
    return [self.collectionView numberOfItemsInSection:0];
}

//最边上的也可以划到中间位置
- (void)makeSideItemCanScrollCenter{
    //设置内边距
    CGFloat inset = (self.viewWidth-self.itemWidth) * 0.5;
    if (self.isHorizontal) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    }else{
        self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
    }
}

- (CGSize)calculateCollectionViewContentSize{
    if (self.isHorizontal) {
        return CGSizeMake(self.itemCount*self.itemWidth, CGRectGetHeight(self.collectionView.frame));
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.itemCount*self.itemWidth);
}

- (CGPoint)getAttributesCenterWithIndexPath:(NSIndexPath *)indexPath centerX:(CGFloat)centerX{
    if (self.isHorizontal) {
        return  CGPointMake(centerX, CGRectGetHeight(self.collectionView.frame)*0.5);
    }
    return CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, centerX);
}


#pragma mark - super method
//第一次布局和布局失败时会调用，子类要调super
- (void)prepareLayout {
    [super prepareLayout];
    
}

//判定布局是否有效，无效会重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

//控制控制最后UICollectionView的最后的停留位置，需要做的吸附效果的逻辑代码在这里完成
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offset=self.isHorizontal ? proposedContentOffset.x : proposedContentOffset.y;
    //获取要停止时处在最中间的index
    CGFloat index = roundf((offset+self.viewWidth/2-self.itemWidth/2)/self.itemWidth);
    if (self.isHorizontal) {
        proposedContentOffset.x = self.itemWidth * index + self.itemWidth / 2 - self.viewWidth / 2;
    } else {
        proposedContentOffset.y = self.itemWidth * index + self.itemWidth / 2 - self.viewWidth / 2;
    }
    return proposedContentOffset;
}


@end
