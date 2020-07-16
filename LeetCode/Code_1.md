# Code_1

## 1. 二叉树的最近公共祖先（Leetcode 236）

```
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

```

## 2.丑数（剑指 Offer 49 ）


```
// C

int nthUglyNumber(int n){
    int u2 = 0,u3 = 0,u5 = 0;
    int u[n];
    u[0] = 1;
    for (int i = 1; i < n; i++){
        int v2 = u[u2]*2;
        int v3 = u[u3]*3;
        int v5 = u[u5]*5;
        int min = v2 < v3 ? v2 : v3;
        u[i] = min < v5 ? min : v5;
        if (u[i] == v2) u2++;
        if (u[i] == v3) u3++;
        if (u[i] == v5) u5++;
    }
    return u[n-1];
}

```

## 3.前 K 个高频元素（Leetcode 347）


``` 
// C ++

#include <stdio.h>
#include <stack>
#include <vector>
#include <unordered_map>
#include <queue>
#include <utility>
#include <algorithm>

class TopKFrequentSolution {
public:
    std::vector<int> topKFrequent(std::vector<int>& nums, int k) {
        std::unordered_map<int,int> record;
        for (int i = 0; i < nums.size(); i++){
            record[nums[i]] ++;
        }
        std::priority_queue<std::pair<int,int>,std::vector<std::pair<int,int>>,std::greater<std::pair<int,int>>> minHeap;
        for (auto iter = record.begin(); iter!=record.end(); iter++){
            if(minHeap.size() == k){
                if(minHeap.top().first < iter->second){
                    minHeap.pop();
                    minHeap.push(std::make_pair(iter->second,iter->first));
                }
            } else {
                minHeap.push(std::make_pair(iter->second,iter->first));
            }
        }
        std::vector<int> result;
        while(minHeap.size()) {
            result.push_back(minHeap.top().second);
            minHeap.pop();
        }
        reverse(result.begin(),result.end());
        return result;
    }
};

```


## 4.盛最多水的容器（Leetcode 11）

```
int maxArea(int* height, int heightSize){
    int i = 0, j = heightSize-1;
    int h =  height[i]<height[j] ? height[i] : height[j];
    int max = h*(j-i);
    while (i < j){
        height[i]<height[j] ? i++ : j--;
        int h =  height[i]<height[j] ? height[i] : height[j];
        int area = h * (j-i);
        max = max > area ? max : area;
    }
    return max;
}

```


## 5.两两交换链表中的节点（Leetcode 24）

```
// C

/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */


struct ListNode* swapPairs(struct ListNode* first){
    if (NULL == first) return NULL;
    struct ListNode *head = (struct ListNode *)malloc(sizeof(struct ListNode));
    head->next = first;

    struct ListNode *pre = head; 
    struct ListNode *current = head->next;
    while (current && current->next) {
        struct ListNode *next = current->next;

        pre->next = next;
        current->next = next->next;
        next->next = current;

        pre = current;
        current = current->next;
    }
    return head->next;
}

```

## 5.括号生成（Leetcode 22）


```
// C

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
 
char **generateParenthesis(int n, int *returnSize) {
    char *s = (char *)calloc((2 * n + 1), sizeof(char));
    char **result = (char **)malloc(catalan(n) * sizeof(char *));
    *returnSize = 0;
    generate(0, 0, n, s, result, returnSize);
    return result;
}

void generate(int left, int right, int n, char *s, char **result, int *returnSize) {
    if (left == n && right == n) {
        result[(*returnSize)] = (char *)calloc((2*n+1), sizeof(char));
        strcpy(result[(*returnSize)++], s);
        return;
    }
    int index = left + right;
    if (left < n) {
        s[index] = '(';
        generate(left+1, right, n, s, result, returnSize);
    }
    if (right < left) {
        s[index] = ')';
        generate(left, right+1, n, s, result, returnSize);
    }
}

int catalan(int n) {
  int i, j, h[n + 1];
  h[0] = h[1] = 1;
  for (i = 2; i <= n; i++) {
    h[i] = 0;
    for (j = 0; j < i; j++)
      h[i] = h[i] + h[j] * h[i - j - 1];
  }
  return h[n];
}


```

## 6.全排列（Leetcode 46）

```
// C

/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */

void dfs(int* nums, int numsSize, int *used, int *path, int current, int **result, int* returnSize, int** returnColumnSizes) {
    if (current == numsSize) {
        result[*returnSize] = (int *)malloc(sizeof(int) * numsSize); 
        memcpy(result[*returnSize], path, sizeof(int) * numsSize);
        (*returnColumnSizes)[*returnSize] = numsSize;
        (*returnSize) ++;
        return;
    }
    for (int i = 0; i < numsSize; i++) {
        if (0 == used[i]) {
            used[i] = 1;
            path[current] = nums[i];
            dfs(nums, numsSize, used, path, current+1, result, returnSize, returnColumnSizes);
            used[i] = 0;
        }
    }   
}

int** permute(int* nums, int numsSize, int* returnSize, int** returnColumnSizes){
    if (NULL == nums) return NULL;

    // 计算总数
    int total = 1;
    for (int i = 2; i <= numsSize; i++) {
        total *= i;
    }

    // 初始化入参
    int path[numsSize];
    int used[numsSize];
    memset(used, 0, sizeof(int) * numsSize);
    int **result = (int **)malloc(sizeof(int *) * total);
    *returnSize = 0;
    *returnColumnSizes = (int *)malloc(sizeof(int) * total); 

    // 进入函数
    dfs(nums, numsSize, used, path, 0, result, returnSize, returnColumnSizes);

    return result;
}

```


## 7.全排列 II（Leetcode 47）

```
// C

/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */

int comp(const void*a, const void*b) {
    return *(int*)a-*(int*)b;
}

void dfs(int* nums, int numsSize, int *used, int *path, int current, int **result, int* returnSize, int** returnColumnSizes) {
    if (current == numsSize) {
        result[*returnSize] = (int *)malloc(sizeof(int) * numsSize); 
        memcpy(result[*returnSize], path, sizeof(int) * numsSize);
        (*returnColumnSizes)[*returnSize] = numsSize;
        (*returnSize) ++;
        return;
    }
    for (int i = 0; i < numsSize; i++) {
        if (i > 0 && nums[i] == nums[i-1] && 0 == used[i-1]) continue;
        if (0 == used[i]) {
            used[i] = 1;
            path[current] = nums[i];
            dfs(nums, numsSize, used, path, current+1, result, returnSize, returnColumnSizes);
            used[i] = 0;
        }
    }   
}

int** permuteUnique(int* nums, int numsSize, int* returnSize, int** returnColumnSizes){
    if (NULL == nums) return NULL;

    // 排序
    qsort(nums, numsSize, sizeof(int), comp);

    // 计算总数
    int total = 1;
    for (int i = 2; i <= numsSize; i++) {
        total *= i;
    }

    // 初始化入参
    int path[numsSize];
    int used[numsSize];
    memset(used, 0, sizeof(int) * numsSize);
    int **result = (int **)malloc(sizeof(int *) * total);
    *returnSize = 0;
    *returnColumnSizes = (int *)malloc(sizeof(int) * total); 

    // 进入函数
    dfs(nums, numsSize, used, path, 0, result, returnSize, returnColumnSizes);

    return result;
}

```

## 8.二叉树中序遍历（Leetcode 94）

```
// C++

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        stack<TreeNode *> stack;
        vector<int> result;
        TreeNode *p = root;
        while (p || !stack.empty()){
            if (p){
                stack.push(p);
                p = p->left;
            } else {
                p = stack.top();
                result.push_back(p->val);
                stack.pop();
                p = p->right;
            }
        }
        return result;
    }
};

```

## 9.从前序与中序遍历序列构造二叉树（Leetcode 105）

```
// C

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

struct TreeNode* buildTree(int* preorder, int preorderSize, int* inorder, int inorderSize) {
    // 结束条件
    if (0 == preorderSize || 0 == inorderSize) return NULL;
    if (NULL == preorder || NULL == inorder) return NULL;
    if (preorderSize != inorderSize) return NULL;

    // 计算左右子树个数
    int rootVal = preorder[0];
    int leftNum = 0;
    for (; leftNum < inorderSize; leftNum ++) {
        if (rootVal == inorder[leftNum]) break;
    }
    int rightNum = inorderSize - leftNum - 1;

    // 初始化节点
    struct TreeNode *rootNode = (struct TreeNode *)malloc(sizeof(struct TreeNode));
    memset(rootNode, 0, sizeof(struct TreeNode));

    // 递归
    rootNode->val = rootVal;
    rootNode->left = buildTree(preorder+1, leftNum, inorder, leftNum);
    rootNode->right = buildTree(preorder+(leftNum+1), rightNum, inorder+(leftNum+1), rightNum);
    
    return rootNode;
}
```
