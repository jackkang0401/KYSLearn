//
//  BinarySearchTree.c
//  KYSBinaryTreeTest
//
//  Created by yongshuai.kang on 2020/6/30.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#include "BinarySearchTree.hpp"

// 查找元素
BinaryNode *searchBSTree(BinaryTree T, int val) {
    BinaryNode *current = T;
    while (NULL != current) {
        if (val == current->value) {
            return current;
        }
        if (val < current->value) {
            current = current->lChild;
        } else if (val > current->value) {
            current = current->rChild;
        }
    }
    return NULL;
}

// 插入元素
void insertBSTree(BinaryTree *T, int val) {
    if (NULL == *T) {
        *T = newNode(val);
        return;
    }
    BinaryNode *current = *T;
    BinaryNode *parent = NULL;
    while (NULL != current) {
        parent = current;
        if (val == current->value) {
            printf("duplicate value %d/n",val);
            return;
        }
        current = (val < current->value) ? current->lChild : current->rChild;
    }
    BinaryNode *childNode = newNode(val);
    (val < parent->value) ? (parent->lChild = childNode) : (parent->rChild = childNode);
}

// 删除元素
/*
三种情况
1. 左右子树都为空（叶子节点）
2. 左右子树其中一个为空
3. 左右子树都不为空，降级为 2 或 1
*/
void deleteBSTree(BinaryTree *T, int val){
    if (NULL == *T) {
        return;
    }
    
    // 查找待删除节点
    BinaryNode *deleteNode = *T;
    BinaryNode *parent = NULL;        // 记录待删除节点的父节点
    while (NULL != deleteNode) {
        if (val == deleteNode->value) {
            break;
        }
        parent = deleteNode;
        deleteNode = (val < deleteNode->value) ? deleteNode->lChild : deleteNode->rChild;
    }
    
    // 未找到删除节点
    if (NULL == deleteNode) {
        return;
    }
    
    // 1.无左右子树  2.无左子树或右子树
    if (NULL == deleteNode->lChild || NULL == deleteNode->rChild) {
        // 待删除节点为根节点
        if (NULL == parent) {
            // 如果都为空，其实 *T = NULL
            *T = (NULL == deleteNode->lChild) ? deleteNode->rChild : deleteNode->lChild;
            deallocNode(&deleteNode);
            return;
        }
        // 父节点新的子节点, 如果左右子节点都为 NULL，child 为 NULL
        BinaryNode *child = (NULL == deleteNode->lChild) ? deleteNode->rChild :deleteNode->lChild ;
        (parent->lChild == deleteNode) ? (parent->lChild = child) : (parent->rChild = child);
        deallocNode(&deleteNode);
    }
    // 3.左右子树都有
    else {
        // 寻找右子树最小值，找到的待删除节点
        BinaryNode *pMinParent = deleteNode;
        BinaryNode *pMin = deleteNode->rChild;
        while (pMin->lChild) {
            pMinParent = pMin;
            pMin = pMin->lChild;
        }
        deleteNode->value = pMin->value;
        // 情况只能是：1. 无叶子节点，2. 只有一个右子树，无左子树
        BinaryNode *child = (NULL == pMin->lChild) ? pMin->rChild :pMin->lChild ;
        (pMinParent->lChild == pMin) ? (pMinParent->lChild = child) : (pMinParent->rChild = child);
        deallocNode(&pMin);
    }
}

