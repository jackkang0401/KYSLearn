//
//  Header.h
//  KYSTreeTest
//
//  Created by yongshuai.kang on 2020/7/1.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#ifndef BinaryTreeBase_hpp
#define BinaryTreeBase_hpp

#include <stdio.h>
#include <stdlib.h>
#include <stack>
#include <iostream>


typedef struct BinaryNode{
    int value;
    struct BinaryNode *lChild;
    struct BinaryNode *rChild;
}BinaryNode,*BinaryTree;

BinaryNode* newNode(int value);

void deallocNode(BinaryNode **p);


/*
          1
         /
        2
       / \
      3   4
         / \
        5   6
         \
          7
 int index = 0;
 int array[] = {1,2,3,0,0,4,5,0,6,0,0,7,0,0,0};
 printf("前序序列 123004506007000 创建二叉树");
 CreateBinaryTree(T, array, &index, 15);
*/
// 前序遍历创建二叉树，0 代表空结点
int createBinaryTree(BinaryTree &T, int *array, int *index, int length);

// 前序遍历
// 递归实现
void preorderRecursionTraversal(BinaryTree T);

// 非递归实现
void preorderTraversal(BinaryTree T);


// 中序遍历
// 递归实现
void inorderRecursionTraversal(BinaryTree T);

// 非递归实现
void inorderTraversal(BinaryTree T);

// 后序遍历
// 递归实现
void postorderRecursionTraversal(BinaryTree T);


void postorderTraversal(BinaryTree T);

#endif /* BinaryTreeBase_hpp */
