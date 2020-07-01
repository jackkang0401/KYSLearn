//
//  KYSBinarySearchTreeViewController.m
//  KYSTreeTest
//
//  Created by yongshuai.kang on 2020/7/1.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#import "KYSBinarySearchTreeViewController.h"
#include "BinarySearchTree.hpp"


@interface KYSBinarySearchTreeViewController ()

@end

@implementation KYSBinarySearchTreeViewController

- (NSArray *)baseDataArray{
    return @[
        @{@"title":@"查   找",},
        @{@"title":@"前序遍历",},
        @{@"title":@"中序遍历",},
        @{@"title":@"后序遍历",},
        @{@"title":@"插   入",},
        @{@"title":@"删   除",},
    ];
}


BinaryTree T = NULL;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    T = NULL;
}


#pragma mark - Action

- (void)clickIndex:(NSInteger)index content:(NSString *)content{
    if ([@[@0,@4,@5] containsObject:@(index)] && (nil == content || 0 == content.length)) {
        return;
    }
    int value = [content intValue];
    if (1 == index) {
        printf("\n 前序遍历：\n");
        preorderRecursionTraversal(T);
    } else if (2 == index) {
        printf("\n 中序遍历：\n");
        inorderRecursionTraversal(T);
    } else if (3 == index) {
        printf("\n 后序遍历：\n");
        postorderRecursionTraversal(T);
    } else if (4 == index) {
        printf("\n 插入：%d \n",value);
        insertBSTree(&T, value);
    } else if (5 == index) {
        printf("\n 删除：%d \n",value);
        deleteBSTree(&T, value);
    }
}

@end
