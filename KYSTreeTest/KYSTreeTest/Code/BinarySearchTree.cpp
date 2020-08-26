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
        if (val == current->val) return current;
        current = (val < current->val) ? current->left : current->right;
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
        if (val == current->val) return; // 出现相同值
        parent = current;
        current = (val < current->val) ? current->left : current->right;
    }
    BinaryNode *childNode = newNode(val);
    (val < parent->val) ? (parent->left = childNode) : (parent->right = childNode);
}

// 删除元素
/*
三种情况
1. 左右子树都为空（叶子节点）
2. 左右子树其中一个为空
3. 左右子树都不为空，降级为 2 或 1
*/
void deleteBSTree(BinaryTree *T, int val){
    if (NULL == *T) return;
    
    // 查找待删除节点
    BinaryNode *deleteNode = *T;
    BinaryNode *parent = NULL;        // 记录待删除节点的父节点
    while (NULL != deleteNode) {
        if (val == deleteNode->val) break;
        parent = deleteNode;
        deleteNode = (val < deleteNode->val) ? deleteNode->left : deleteNode->right;
    }
    
    // 未找到删除节点
    if (NULL == deleteNode) return;
    
    // 1.无左右子树  2.无左子树或右子树
    if (NULL == deleteNode->left || NULL == deleteNode->right) {
        // 待删除节点为根节点
        if (NULL == parent) {
            // 如果都为空，其实 *T = NULL
            *T = (NULL == deleteNode->left) ? deleteNode->right : deleteNode->left;
            deallocNode(&deleteNode);
            return;
        }
        // 父节点新的子节点, 如果左右子节点都为 NULL，child 为 NULL
        BinaryNode *child = (NULL == deleteNode->left) ? deleteNode->right : deleteNode->left;
        (parent->left == deleteNode) ? (parent->left = child) : (parent->right = child);
        deallocNode(&deleteNode);
    }
    // 3.左右子树都有
    else {
        // 寻找右子树最小值，找到的待删除节点
        BinaryNode *pMinParent = deleteNode;
        BinaryNode *pMin = deleteNode->right;
        while (pMin->left) {
            pMinParent = pMin;
            pMin = pMin->left;
        }
        deleteNode->val = pMin->val;
        // 情况只能是：1. 无叶子节点，2. 只有一个右子树，无左子树
        BinaryNode *child = (NULL == pMin->left) ? pMin->right : pMin->left;
        (pMinParent->left == pMin) ? (pMinParent->left = child) : (pMinParent->right = child);
        deallocNode(&pMin);
    }
}

