//
//  KYSBinaryTreeTraverse.cpp
//  KYSBitTreeTraverse
//
//  Created by Liu Zhao on 2016/11/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#include "KYSBinaryTreeTraverse.hpp"

//前序遍历创建二叉树,‘*’代表空结点
int CreateBinaryTree(BinaryTree &T){
    char value;
    scanf("%c",&value);
    if (value<'0'||value>'9') {
        if ('*' != value) {
            printf("非法输入：%c\n",value);
            return 0;
        }
    }
    if ('*'==value) {
        T=NULL;
    }else{
        T=(BinaryTree)malloc(sizeof(BinaryNode));
        T->value=value;
        CreateBinaryTree(T->lChild);
        CreateBinaryTree(T->rChild);
    }
    return 1;
}

//前序遍历
//递归实现
void PreorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        printf("%c ",T->value);
        PreorderRecursionTraversal(T->lChild);
        PreorderRecursionTraversal(T->rChild);
    }
}

//中序遍历
//递归实现
void InorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        InorderRecursionTraversal(T->lChild);
        printf("%c ",T->value);
        InorderRecursionTraversal(T->rChild);
    }
}

//后序遍历
//递归实现
void PostorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        PostorderRecursionTraversal(T->lChild);
        PostorderRecursionTraversal(T->rChild);
        printf("%c ",T->value);
        
    }
}




