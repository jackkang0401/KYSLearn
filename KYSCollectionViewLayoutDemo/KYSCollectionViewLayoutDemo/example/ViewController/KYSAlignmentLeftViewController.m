//
//  KYSAlignmentLeftViewController.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSAlignmentLeftViewController.h"
#import "ABChooseSkillCollectionViewCell.h"
#import "KYSAlignmentLeftCollectionViewFlowLayout.h"
#import "NSString+KYSAddition.h"
#import "ABChooseSkillsCollectionReusableView.h"

#define KYS_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define KYS_WIDTH_RATE KYS_SCREEN_WIDTH/375.0

#define KYS_SPACE ((int)(12*KYS_WIDTH_RATE))

@interface KYSAlignmentLeftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation KYSAlignmentLeftViewController

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray=@[@{@"name":@"办公/企业应用",
                       @"abilities":@[@"word",@"excel",@"powerpoint", @"outlook",@"用友",@"SAP",@"office for mac",@"visio",@"金蝶"]},
                     @{@"name":@"数据库",
                       @"abilities":@[@"access",@"mysql",@"sqlserver",@"oracle",@"db2"]},
                     @{@"name":@"操作系统",
                       @"abilities":@[@"linux/unix",@"个人windows",@"服务器windows",@"macos",@"IOS刷机",@"Android救砖",@"shell"]},
                     @{@"name":@"应用软件",
                       @"abilities":@[@"photoshop",@"axure",@"flash",@"premiere",@"coreldraw",@"3dmax"]},
                     @{@"name":@"硬件",
                       @"abilities":@[@"台式机硬件",@"笔记本硬件",@"服务器硬件"]}
                     ];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    KYSAlignmentLeftCollectionViewFlowLayout *layout = [[KYSAlignmentLeftCollectionViewFlowLayout alloc] init];
    //layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing=KYS_SPACE;
    layout.minimumInteritemSpacing=KYS_SPACE;
    _collectionView.collectionViewLayout=layout;
    
    [_collectionView registerClass:[ABChooseSkillsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ABChooseSkillsCollectionReusableView"];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray[section][@"abilities"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ABChooseSkillCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:
                                           @"ABChooseSkillCollectionViewCell" forIndexPath:indexPath];
    NSString *title = self.dataArray[indexPath.section][@"abilities"][indexPath.row];
    [cell setTitle:title];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section>=4) {
        //一行一个
        return CGSizeMake(KYS_SCREEN_WIDTH-2*KYS_SPACE, 32*KYS_WIDTH_RATE);
    }
    
    NSString *title = self.dataArray[indexPath.section][@"abilities"][indexPath.row];
    //int width = [label.text widthForFont:label.font]+2*KYS_TEXT_MARGIN;//此时label.text还没赋值
    int width = (int)([title widthForFont:[UIFont systemFontOfSize:KYS_SCREEN_WIDTH>320?14:13]]+2*KYS_SPACE);
    NSLog(@"%d",width);
    if (width>((int)(KYS_SCREEN_WIDTH-2*KYS_SPACE))){
        width=(int)(KYS_SCREEN_WIDTH-2*KYS_SPACE);
        NSLog(@"调整:%d",width);
    }
    return  CGSizeMake(width, 32*KYS_WIDTH_RATE);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 35);//宽默认
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return KYS_SPACE;
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return KYS_SPACE;
}

//设置整个分区相对上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(KYS_SPACE, KYS_SPACE, KYS_SPACE, KYS_SPACE);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        ABChooseSkillsCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ABChooseSkillsCollectionReusableView" forIndexPath:indexPath];//需要zhuce
        header.titleLabel.text = self.dataArray[indexPath.section][@"name"];
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

@end
