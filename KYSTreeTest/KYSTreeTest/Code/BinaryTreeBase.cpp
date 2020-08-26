//
//  BinaryTreeBase.cpp
//  KYSTreeTest
//
//  Created by yongshuai.kang on 2020/7/1.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#include "BinaryTreeBase.hpp"

BinaryNode* newNode(int val) {
    BinaryNode *p = (BinaryNode *)malloc(sizeof(BinaryNode));
    p->val = val;
    p->left = NULL;
    p->right = NULL;
    return p;
}

void deallocNode(BinaryNode **p){
    if (NULL == *p) {
        return;
    }
    free(*p);
    *p = NULL;
}


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
int createBinaryTree(BinaryTree &T, int *array, int *index, int length){
    if (*index >= length) {
        return 0;
    }
    int val = array[*index];
    printf("%d",val);
    if (0 == val) {
        T = NULL;
    }else{
        T = (BinaryTree)malloc(sizeof(BinaryNode));
        T->val = val;
        *index = *index+1;
        createBinaryTree(T->left, array, index, length);
        *index = *index+1;
        createBinaryTree(T->right, array, index, length);
    }
    return 1;
}

// 前序遍历
// 递归实现
void preorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        printf("%d ",T->val);
        preorderRecursionTraversal(T->left);
        preorderRecursionTraversal(T->right);
    }
}

// 非递归实现
void preorderTraversal(BinaryTree T){
    std::stack<BinaryTree> stack;
    BinaryTree p = T;
    while (p || !stack.empty()) {
        if (p) {
            stack.push(p);
            printf("%d ",p->val);
            p = p->left;
        }else{
            p = stack.top();
            stack.pop();
            p = p->right;
        }
    }
}


// 中序遍历
// 递归实现
void inorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        inorderRecursionTraversal(T->left);
        printf("%d ",T->val);
        inorderRecursionTraversal(T->right);
    }
}

// 非递归实现
void inorderTraversal(BinaryTree T){
    std::stack<BinaryTree> stack;
    BinaryTree p=T;
    while (p || !stack.empty()) {
        if (p) {
            stack.push(p);
            p = p->left;
        } else {
            p = stack.top();
            printf("%d ",p->val);
            stack.pop();
            p = p->right;
        }
    }
}

// 后序遍历
// 递归实现
void postorderRecursionTraversal(BinaryTree T){
    if (NULL != T) {
        postorderRecursionTraversal(T->left);
        postorderRecursionTraversal(T->right);
        printf("%d ",T->val);
    }
}

// 非递归实现(完全想不到思路，参考网上的)
typedef struct BinaryAuxiliaryNode{
    BinaryNode *node;
    char flag;
}BinaryAuxiliaryNode,*BinaryAuxiliaryTree;


void postorderTraversal(BinaryTree T){
    std::stack<BinaryAuxiliaryTree> stack;
    BinaryTree p = T;
    BinaryAuxiliaryTree aTree;
    while (NULL!=p || !stack.empty()) {
        //遍历左子树
        while (NULL != p) {
            aTree = (BinaryAuxiliaryTree)malloc(sizeof(BinaryAuxiliaryNode));
            aTree->node = p;
            //访问过左子树
            aTree->flag = 'L';
            stack.push(aTree);
            p = p->left;
        }
        //左右子树访问完毕，访问根结点
        while (!stack.empty() && stack.top()->flag == 'R') {
            aTree = stack.top();
            stack.pop();
            printf("%d ",aTree->node->val);
        }
        //遍历右子树
        if (!stack.empty()) {
            aTree = stack.top();
            //访问过右子树
            aTree->flag = 'R';
            p = aTree->node;
            p = p->right;
        }
    }
    
}
