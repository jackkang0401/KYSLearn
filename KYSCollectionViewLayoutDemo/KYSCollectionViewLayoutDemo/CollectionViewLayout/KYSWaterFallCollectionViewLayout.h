//
//  KYSWaterFallCollectionViewLayout.h
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/10.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^KYSCollectionViewLayoutHeightBlock)(NSInteger index,CGFloat width);

@interface KYSWaterFallCollectionViewLayout : UICollectionViewLayout

@property(nonatomic,assign)NSInteger columnCount;
@property(nonatomic,assign)NSInteger columnMargin;
@property(nonatomic,assign)NSInteger rowMargin;
@property(nonatomic,assign)UIEdgeInsets edgeInsets;

@property(nonatomic,copy)KYSCollectionViewLayoutHeightBlock heightBlock;

@end
