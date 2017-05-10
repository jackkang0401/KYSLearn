//
//  KYSBaseCollectionViewLayout.h
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYSBaseCollectionViewLayout : UICollectionViewLayout

@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic,assign) CGSize itemSize;

//获取方法
@property (nonatomic,readonly)BOOL isHorizontal;
@property (nonatomic,readonly)CGFloat viewWidth;        //水平方向取宽度，否则取高度
@property (nonatomic,readonly)CGFloat viewHeight;       //水平方向取高度，否则取宽度
@property (nonatomic,readonly)CGFloat contentOffsetX;   //水平方向取X，否则取宽度Y
@property (nonatomic,readonly)CGFloat contentOffsetY;   //水平方向取Y，否则取宽度X
@property (nonatomic,readonly)CGFloat itemHeight;       //水平方向取高度，否则取宽度
@property (nonatomic,readonly)CGFloat itemWidth;        //水平方向取宽度，否则取高度
@property (nonatomic,readonly)NSInteger itemCount;      //cell数量

//最边上的也可以划到中间位置
- (void)makeSideItemCanScrollCenter;

//计算线性布局的滑动区域
- (CGSize)calculateCollectionViewContentSize;

- (CGPoint)getAttributesCenterWithIndexPath:(NSIndexPath *)indexPath centerX:(CGFloat)centerX;

@end
