//
//  KYSMainViewController.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/3.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSMainViewController.h"
#import "KYSExampleViewController.h"
#import "KYSLineCollectionViewFlowLayout.h"
#import "KYSStackCollectionViewLayout.h"
#import "KYSDecorationTestView.h"
#import "KYSCircleCollectionViewLayout.h"
#import "KYSLineCollectionViewLayout.h"
#import "KYSRotaryCollectionViewLayout.h"
#import "KYSCoverFlowCollectionViewLayout.h"
#import "KYSCarouselCollectionViewLayout.h"
#import "KYSCarouselAutoCollectionViewLayout.h"
#import "KYSWaterFallCollectionViewLayout.h"

@interface KYSMainViewController ()

@end

@implementation KYSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    NSLog(@"%@",segue.identifier);
    
    if ([@"KYSLineCollectionViewFlowLayout" isEqualToString:segue.identifier]) {
        KYSLineCollectionViewFlowLayout *layout=[[KYSLineCollectionViewFlowLayout alloc] init];
        layout.itemSize=CGSizeMake(150, 150);
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if ([@"KYSStackCollectionViewLayout" isEqualToString:segue.identifier]) {
        KYSStackCollectionViewLayout *layout=[[KYSStackCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(200, 200);
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.maxVisableItems=5;
        
        [layout setDecorationViewWithClass:[KYSDecorationTestView class] config:^(UICollectionView *collectionView, UICollectionViewLayoutAttributes *attrs) {
            attrs.size = CGSizeMake(300, 300);
            //
            NSLog(@"%@",NSStringFromCGRect(collectionView.frame));
            //值竟然不同？
            NSLog(@"%@",NSStringFromCGPoint(collectionView.center));
            CGPoint center=CGPointMake(CGRectGetWidth(collectionView.frame)*0.5, CGRectGetHeight(collectionView.frame)*0.5);
            NSLog(@"%@",NSStringFromCGPoint(center));
            attrs.center =center;
            //设置小一点，要不可能再在cell上边
            attrs.zIndex = -1000;
        }];
        
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSCircleCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSCircleCollectionViewLayout *layout=[[KYSCircleCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(70, 70);
        layout.radius=130;
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSLineCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSLineCollectionViewLayout *layout=[[KYSLineCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(170, 200);
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSRotaryCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSRotaryCollectionViewLayout *layout=[[KYSRotaryCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(200, 100);
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSCoverFlowCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSCoverFlowCollectionViewLayout *layout=[[KYSCoverFlowCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(200, 100);
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSCarouselCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSCarouselCollectionViewLayout *layout=[[KYSCarouselCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(200, 100);
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSCarouselAutoCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSCarouselAutoCollectionViewLayout *layout=[[KYSCarouselAutoCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake(200, 100);
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }else if([@"KYSWaterFallCollectionViewLayout" isEqualToString:segue.identifier]){
        KYSWaterFallCollectionViewLayout *layout=[[KYSWaterFallCollectionViewLayout alloc] init];
        layout.columnCount=2;
        layout.heightBlock = ^CGFloat(NSInteger index, CGFloat width) {
            return arc4random()%200+100.0;
        };
        KYSExampleViewController *VC=segue.destinationViewController;
        VC.viewLayout=layout;
    }
}

@end
