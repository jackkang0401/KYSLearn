//
//  KYSStackCollectionViewLayout.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSStackCollectionViewLayout.h"

@interface KYSStackCollectionViewLayout()

@property(nonatomic,strong)Class viewClass;
@property(nonatomic,copy)KYSConfigBlock configBlock;
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation KYSStackCollectionViewLayout

- (NSMutableArray *)attrsArray{
    if (nil == _attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)setDecorationViewWithClass:(Class)viewClass config:(KYSConfigBlock)config{
    self.viewClass = viewClass;
    self.configBlock = config;
}

- (void)dealloc{
    self.configBlock=nil;
}

//数据源更新，这个方法就会调用
- (void)prepareLayout{
    [super prepareLayout];
    
    NSLog(@"prepareLayout");
    
    //不传入配置block不会注册DecorationView
    if (self.viewClass&&self.configBlock) {
        [self registerClass:self.viewClass forDecorationViewOfKind:@"DecorationView1"];
    }
    
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
    
    if (self.viewClass&&self.configBlock) {
        @autoreleasepool {
            //加入布局（可以通过block，加入布局）
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.attrsArray addObject:[self layoutAttributesForDecorationViewOfKind:@"DecorationView1" atIndexPath:indexPath]];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSLog(@"layoutAttributesForElementsInRect:");
    
    return self.attrsArray;
    
//    NSMutableArray *array = [NSMutableArray array];
//    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i<count; i++) {
//        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:path];
//        [array addObject:attrs];
//    }
//    NSMutableArray *mArray=[NSMutableArray arrayWithArray:array];
//    if (self.viewClass&&self.configBlock) {
//        //加入布局（可以通过block，加入布局）
//        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        [mArray addObject:[self layoutAttributesForDecorationViewOfKind:@"DecorationView1" atIndexPath:indexPath]];
//    }
//    return mArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.center = CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, CGRectGetHeight(self.collectionView.frame)*0.5);
    attrs.size=self.itemSize;
    attrs.zIndex = - indexPath.item;//item值大的在下边
    
    if (0==indexPath.item) {
        return attrs;
    }
    if (indexPath.item >= self.maxVisableItems) {
        attrs.hidden = YES;
        return attrs;
    }
    attrs.transform = [self getTransfrmWithIndex:indexPath.item];
    return attrs;
}

//布局DecorationView
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"layoutAttributesForDecorationViewOfKind:");
    UICollectionViewLayoutAttributes* attrs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    if (self.viewClass&&self.configBlock) {
        self.configBlock(self.collectionView,attrs);
    }
    return attrs;
}

//覆写父类
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}


- (CGAffineTransform)getTransfrmWithIndex:(NSInteger)index{
    if (0==index) {
        return CGAffineTransformMakeRotation(0.0);
    }
    //NSLog(@"%@",@(index));
    NSInteger numberOfItems=[self.collectionView numberOfItemsInSection:0];
    NSInteger visableCount=numberOfItems>=self.maxVisableItems?self.maxVisableItems:numberOfItems;
    //练个相邻的照片的偏移角度
    CGFloat angle=M_PI_2/visableCount;
    CGFloat indexAngle=0;
    //计算对应index的偏移
    if (KYSLayoutAnimationTypeRotate==self.layoutAnimationType) {
        indexAngle=angle*index;
    }else if(KYSLayoutAnimationTypeSymmetry==self.layoutAnimationType){
        indexAngle=angle*((index+1)>>1);//左移一位
        //按位与判断奇偶
        if (index&1) {
            indexAngle=-indexAngle;
        }
    }
    //NSLog(@"%@",@(indexAngle));
    return CGAffineTransformMakeRotation(indexAngle);
}

@end
