//
//  KYSStackCollectionViewLayout.h
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSBaseCollectionViewLayout.h"

typedef NS_ENUM(NSInteger,KYSLayoutAnimationType){
    KYSLayoutAnimationTypeRotate = 0,
    KYSLayoutAnimationTypeSymmetry = 1,
};

typedef void(^KYSConfigBlock)(UICollectionView *collectionView,UICollectionViewLayoutAttributes* attrs);

@interface KYSStackCollectionViewLayout : KYSBaseCollectionViewLayout

@property(nonatomic,assign)NSInteger maxVisableItems;
@property(nonatomic,assign)KYSLayoutAnimationType layoutAnimationType;

- (void)setDecorationViewWithClass:(Class)viewClass config:(KYSConfigBlock)config;

@end
