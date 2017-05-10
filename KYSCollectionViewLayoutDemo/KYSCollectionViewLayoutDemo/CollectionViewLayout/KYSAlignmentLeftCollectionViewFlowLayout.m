//
//  KYSAlignmentLeftCollectionViewFlowLayout.m
//  KTSCollectionTest
//
//  Created by Liu Zhao on 16/3/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSAlignmentLeftCollectionViewFlowLayout.h"

@interface KYSAlignmentLeftCollectionViewFlowLayout()

@end


@implementation KYSAlignmentLeftCollectionViewFlowLayout

- (void)prepareLayout{
    // 必须要调用父类(父类也有一些准备操作)
    [super prepareLayout];
    
    //只支持竖直滑动
    self.scrollDirection=UICollectionViewScrollDirectionVertical;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 调用父类方法拿到默认的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    int width=self.minimumInteritemSpacing;
    NSInteger section=-1;
    for (int i=0;i<array.count;i++) {
        UICollectionViewLayoutAttributes *attrs=array[i];
        if (UICollectionElementCategoryCell==attrs.representedElementCategory) {
            //每个section换行
            if (section != attrs.indexPath.section) {
                width = self.minimumInteritemSpacing;
                section = attrs.indexPath.section;
            }
            int nextWidth = width+(attrs.size.width+self.minimumInteritemSpacing);
        
            if (nextWidth <= self.collectionView.frame.size.width) {
                attrs.center = CGPointMake(width+attrs.size.width/2, attrs.center.y);
                width = nextWidth;
            }else{
                //新一行
                width=self.minimumInteritemSpacing;
                i--;
            }
        }
    }
#pragma clang diagnostic pop
    return array;
}

//控制何时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}


@end
