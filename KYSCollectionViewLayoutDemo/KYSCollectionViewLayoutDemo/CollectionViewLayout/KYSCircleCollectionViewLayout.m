//
//  KYSCircleCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/4.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSCircleCollectionViewLayout.h"

@interface KYSCircleCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation KYSCircleCollectionViewLayout

- (NSMutableArray *)attrsArray{
    if (nil == _attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

//数据源更新，这个方法就会调用
- (void)prepareLayout{
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
    
    //提前计算好，不在layoutAttributesForElementsInRect:
    //因为layoutAttributesForElementsInRect:会调用多次，这样可以避免每次都创建UICollectionViewLayoutAttributes对象
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        @autoreleasepool {
            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:path];
            [self.attrsArray addObject:attrs];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSLog(@"layoutAttributesForElementsInRect:");
    
    return self.attrsArray;
//    NSMutableArray *array = [NSMutableArray array];
//    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i < count; i++) {
//        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:path];
//        [array addObject:attrs];
//    }
//    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = self.itemSize;
    CGFloat centerX = CGRectGetWidth(self.collectionView.frame) * 0.5;
    CGFloat centerY = CGRectGetHeight(self.collectionView.frame) * 0.5;
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    if (1==count) {
        attrs.center = CGPointMake(centerX, centerY);
    } else {
        CGFloat angle = 2.0*M_PI / count*indexPath.item;
        CGFloat attrsCenterX = centerX - self.radius*cos(angle);
        CGFloat attrsCenterY = centerY - self.radius*sin(angle);
        attrs.center = CGPointMake(attrsCenterX, attrsCenterY);
    }
    return attrs;
}

//覆写父类
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}

@end
