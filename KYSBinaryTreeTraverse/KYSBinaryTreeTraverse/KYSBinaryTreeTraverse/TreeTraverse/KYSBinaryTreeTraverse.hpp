//
//  KYSBinaryTreeTraverse.hpp
//  KYSBitTreeTraverse
//
//  Created by Liu Zhao on 2016/11/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#ifndef KYSBinaryTreeTraverse_hpp
#define KYSBinaryTreeTraverse_hpp

#include <stdio.h>
#include <stack>
#include <iostream>

#endif /* KYSBinaryTreeTraverse_hpp */

typedef struct BinaryNode{
    char value;
    struct BinaryNode *lChild;
    struct BinaryNode *rChild;
}BinaryNode,*BinaryTree;

//前序遍历创建二叉树,‘*’代表空结点
int CreateBinaryTree(BinaryTree &T, char *charArray, int *index, int length);

//前序遍历
//递归实现
void PreorderRecursionTraversal(BinaryTree T);
//非递归实现
void PreorderTraversal(BinaryTree T);


//中序遍历
//递归实现
void InorderRecursionTraversal(BinaryTree T);
//非递归实现
void InorderTraversal(BinaryTree T);


//后序遍历
//递归实现
void PostorderRecursionTraversal(BinaryTree T);
//非递归实现(完全想不到思路，参考网上的)
void PostorderTraversal(BinaryTree T);



