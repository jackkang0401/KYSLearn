//
//  KYSExampleViewController.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/2.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSExampleViewController.h"
#import "KYSImageCollectionViewCell.h"

@interface KYSExampleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *images;

@end

@implementation KYSExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.images = [[NSMutableArray alloc] init];
    for (int i = 1; i<=12; i++) {
        [self.images addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    if (self.viewLayout) {
        self.collectionView.collectionViewLayout=self.viewLayout;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KYSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYSImageCollectionViewCell" forIndexPath:indexPath];
    cell.imageName = self.images[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.images removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end
