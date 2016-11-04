//
//  KYSBinaryTreeTraverse.cpp
//  KYSBitTreeTraverse
//
//  Created by Liu Zhao on 2016/11/2.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#include "KYSBinaryTreeTraverse.hpp"

//前序遍历创建二叉树,‘*’代表空结点
int CreateBinaryTree(BinaryTree &T, char *charArray, int *index, int length){
    if (*index>=length) {
        return 0;
    }
    char value =charArray[*index];
    printf("%c",value);
    if ('*'==value) {
        T=NULL;
    }else{
        T=(BinaryTree)malloc(sizeof(BinaryNode));
        T->value=value;
        *index=*index+1;
        CreateBinaryTree(T->lChild, charArray, index, length);
        *index=*index+1;
        CreateBinaryTree(T->rChild, charArray, index, length);
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

//非递归实现
void PreorderTraversal(BinaryTree T){
    std::stack<BinaryTree> stack;
    BinaryTree p=T;
    while (NULL!=p || !stack.empty()) {
        if (NULL != p) {
            stack.push(p);
            printf("%c ",p->value);
            p=p->lChild;
        }else{
            p=stack.top();
            stack.pop();
            p=p->rChild;
        }
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

//非递归实现
void InorderTraversal(BinaryTree T){
    std::stack<BinaryTree> stack;
    BinaryTree p=T;
    while (NULL!=p || !stack.empty()) {
        if (NULL != p) {
            stack.push(p);
            p=p->lChild;
        }else{
            p=stack.top();
            printf("%c ",p->value);
            stack.pop();
            p=p->rChild;
        }
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

//非递归实现(完全想不到思路，参考网上的)
typedef struct BinaryAuxiliaryNode{
    BinaryNode *node;
    char flag;
}BinaryAuxiliaryNode,*BinaryAuxiliaryTree;


void PostorderTraversal(BinaryTree T){
    std::stack<BinaryAuxiliaryTree> stack;
    BinaryTree p=T;
    BinaryAuxiliaryTree aTree;
    while (NULL!=p || !stack.empty()) {
        //遍历左子树
        while (NULL != p) {
            aTree=(BinaryAuxiliaryTree)malloc(sizeof(BinaryAuxiliaryNode));
            aTree->node=p;
            //访问过左子树
            aTree->flag='L';
            stack.push(aTree);
            p=p->lChild;
        }
        //左右子树访问完毕，访问根结点
        while (!stack.empty() && stack.top()->flag=='R') {
            aTree=stack.top();
            stack.pop();
            printf("%c ",aTree->node->value);
        }
        //遍历右子树
        if (!stack.empty()) {
            aTree=stack.top();
            //访问过右子树
            aTree->flag='R';
            p=aTree->node;
            p=p->rChild;
        }
    }
    
}




