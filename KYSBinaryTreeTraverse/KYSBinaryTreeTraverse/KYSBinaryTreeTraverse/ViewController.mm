//
//  ViewController.m
//  KYSBitTreeTraverse
//
//  Created by Liu Zhao on 2016/11/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "ViewController.h"

#include "KYSBinaryTreeTraverse.hpp"

@interface ViewController ()


@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/*binary tree
 
                      A
                     /
                    B
                   / \
                  C   D
                     / \
                    E   G
                     \
                      F
 
 */


BinaryTree T;
- (IBAction)createBtnAction:(id)sender {
    //A B C * * D E * F * * G * * *
    int index=0;
    char array[]={'A','B','C','*','*','D','E','*','F','*','*','G','*','*','*'};
    printf("\n创建二叉树：");
    CreateBinaryTree(T, array, &index, 15);
}

- (IBAction)traversalBtnAction:(UIButton *)btn{
    NSInteger taq=btn.tag;
    printf("\n%ld",(long)taq);
    if (0==taq) {
        printf("\n前序序列递归：");
        PreorderRecursionTraversal(T);
    }else if (1==taq) {
        printf("\n前序序列非递归：");
        PreorderTraversal(T);
    }else if (2==taq) {
        printf("\n中序序列递归：");
        InorderRecursionTraversal(T);
    }else if (3==taq) {
        printf("\n中序序列非递归：");
        InorderTraversal(T);
    }else if (4==taq) {
        printf("\n后序序列递归：");
        PostorderRecursionTraversal(T);
    }else if (5==taq) {
        printf("\n后序序列非递归：");
        PostorderTraversal(T);
    }
    
}


@end
