# Code

## 1. 二叉树的最近公共祖先（Leetcode 236）

'''
// C
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q) {
    if(root == NULL) return NULL;
    if(root == p || root == q) return root;
            
    struct TreeNode* left =  lowestCommonAncestor(root->left, p, q);
    struct TreeNode* right = lowestCommonAncestor(root->right, p, q);
       
    if(left == NULL) return right;
    if(right == NULL) return left;      
    if(left && right) return root; // p 和 q 在两侧

    return NULL; 
}

'''
