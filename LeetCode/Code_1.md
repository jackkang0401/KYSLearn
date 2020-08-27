# Code_1

## 1. 二叉树的最近公共祖先（Leetcode 236）

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
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if (nullptr == root) return nullptr;
        TreeNode* ans;
        dfs(root, p, q, ans);
        return ans;
    }
private:
    bool dfs(TreeNode* root, TreeNode* p, TreeNode* q, TreeNode* &ans) {
        if (nullptr == root) return false;
        bool lson = dfs(root->left, p, q, ans);
        bool rson = dfs(root->right, p, q, ans);
        /*
            1.当前节点左右子树包含 p 与 q
            2.当前节点为 p 或 q，并且左子树或右子树包含另一节点
        */
        if ((lson && rson) || ((root->val == p->val || root->val == q->val) && (lson || rson))) ans = root;
        /*
            1.当前节点左右子树包含 p 或 q
            2.当前节点为 p 或 q
        */
        return (lson || rson) || (root->val == p->val || root->val == q->val);
    }
};


```

```
// 非递归

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
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if (nullptr == root) return nullptr;
        // 建立父指针映射
        father_map[root] = nullptr;
        dfs(root);
        // 遍历 p 及父节点放入 visited
        while (nullptr != p) {
            visited.insert(p);
            p = father_map[p];
        }
        // 遍历 q 及父节点，若 visited 内存在该节点，说明此节点为最近公共祖先
        while (nullptr != q) {
            if(visited.find(q) != visited.end()) return q;
            q = father_map[q];
        }
        return nullptr;
    }

private:
    unordered_map<TreeNode*, TreeNode*> father_map;
    unordered_set<TreeNode *> visited;
    // 建立父指针映射
    void dfs(TreeNode* root) {
        if (nullptr != root->left) {
            father_map[root->left] = root;
            dfs(root->left);
        }
        if (nullptr != root->right) {
            father_map[root->right] = root;
            dfs(root->right);
        }
    }
};

```

## 2.丑数（Leetcode264、剑指 Offer 49）


```
// C

int nthUglyNumber(int n){
    int u2 = 0, u3 = 0, u5 = 0; // 存放索引
    int dp[n];
    dp[0] = 1;
    for (int i = 1; i < n; i++) {
        int v2 = dp[u2] * 2;
        int v3 = dp[u3] * 3;
        int v5 = dp[u5] * 5;
        int min = v2 < v3 ? v2 : v3;
        dp[i] = min < v5 ? min : v5;
        // v2 v3 v5 中可能存在相等的情况
        if (dp[i] == v2) u2++;
        if (dp[i] == v3) u3++;
        if (dp[i] == v5) u5++;
    }
    return dp[n-1];
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

class Solution {
public:
    vector<int> topKFrequent(vector<int>& nums, int k) {
        unordered_map<int,int> record;
        for (int i = 0; i < nums.size(); i++){
            record[nums[i]] ++;
        }
        priority_queue<pair<int,int>,vector<pair<int,int>>,greater<pair<int,int>>> minHeap;
        for (auto iter = record.begin(); iter!=record.end(); iter++){
            if(minHeap.size() == k){
                if(iter->second > minHeap.top().first){
                    minHeap.pop();
                    minHeap.push(make_pair(iter->second,iter->first));
                }
            } else {
                minHeap.push(make_pair(iter->second,iter->first));
            }
        }
        vector<int> result;
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
// C

int maxArea(int* height, int heightSize){
    if (heightSize <= 1) return 0;
    int maxArea = 0, i = 0, j = heightSize - 1;
    while (i < j) {
        int area = (j-i) * (height[i] < height[j] ? height[i++] : height[j--]);
        maxArea = area > maxArea ? area : maxArea;
    }
    return maxArea;
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

## 6.括号生成（Leetcode 22）


```
// C

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */

int catelan(int n) {
    int i, j, h[n+1];
    h[0] = h[1] = 1;
    for (int i = 2; i <= n; i++) {
        h[i] = 0;
        for (int j = 0; j < i; j ++){
            h[i] = h[i] + h[j]*h[i-j-1];
        }
    }
    return h[n];
}

void dfs(char *s, int left, int right, int n, char **result, int *returnSize) {
    if (left == n && right == n) {
        result[*returnSize] = (char **)malloc(sizeof(int) * (2*n+1));
        memcpy(result[*returnSize], s, sizeof(char) * (2*n+1));
        (*returnSize) ++;
        return;
    }
    int index = left + right;
    if (left < n) {
        s[index] = '(';
        dfs(s, left+1, right, n, result, returnSize);
    }
    if (right < left) {
        s[index] = ')';
        dfs(s, left, right+1, n, result, returnSize);
    }
}

char ** generateParenthesis(int n, int* returnSize){
    if (0 == n) return NULL;
    int total = catelan(n);
    char *s = (char *)calloc((2 * n + 1), sizeof(char));
    char **result = (char **)malloc(sizeof(char *) * total);
    *returnSize = 0;
    dfs(s, 0, 0, n, result, returnSize);
    return result;
}

```

```
// C++

class Solution {
public:
    vector<string> generateParenthesis(int n) {
        vector<string> result;
        string s;
        dfs(n, 0, 0, s, result);
        return result;
    }

private:
    void dfs(int n, int left, int right, string& s, vector<string>& result) {
        if (n == left && n == right) {
            result.push_back(s);
            return;
        }
        if (left < n) {
            s.push_back('(');
            dfs(n, left+1, right, s, result);
            s.pop_back();
        }
        if (right < left) {
            s.push_back(')');
            dfs(n, left, right+1, s, result);
            s.pop_back();
        }
    }
};

```

## 7.全排列（Leetcode 46）

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
```
// C++

class Solution {
public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<bool> used(nums.size(), false);
        vector<int> path;
        vector<vector<int>> result;
        dfs(nums, used, path, result);
        return result;
    }

private:
    void dfs(vector<int> &nums, vector<bool> &used, vector<int> &path, vector<vector<int>> &result) {
        if (path.size() == nums.size()) {
            result.push_back(path);
            return;
        }
        for (int i = 0, numsSize = nums.size(); i < numsSize; i++) {
            if (false == used[i]) {
                used[i] = true;
                path.push_back(nums[i]);
                dfs(nums, used, path, result);
                path.pop_back();
                used[i] = false;
            }
        }        
    }
};

```

## 8.全排列 II（Leetcode 47）

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

```
// C++

class Solution {
public:
    vector<vector<int>> permuteUnique(vector<int>& nums) {
        vector<bool> used(nums.size(), false);
        vector<int> path;
        vector<vector<int>> result;
        sort(nums.begin(), nums.end());
        dfs(nums, used, path, result);
        return result;
    }

private:
    void dfs(vector<int> &nums, vector<bool> &used, vector<int> &path, vector<vector<int>> &result) {
        if (path.size() == nums.size()) {
            result.push_back(path);
            return;
        }
        for (int i = 0, numsSize = nums.size(); i < numsSize; i++) {
            if (i > 0 && nums[i] == nums[i-1] && 0 == used[i-1]) continue;
            if (false == used[i]) {
                used[i] = true;
                path.push_back(nums[i]);
                dfs(nums, used, path, result);
                path.pop_back();
                used[i] = false;
            }
        }        
    }
};

```

## 9.二叉树中序遍历（Leetcode 94）

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

## 10.从前序与中序遍历序列构造二叉树（Leetcode 105）

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

## 11.岛屿数量（Leetcode 200）

```
// C

void dfs(char** grid, int gridSize, int* gridColSize, int i, int j) {
    if(i<0 || i>=gridSize || j<0 || j>=gridColSize[i] || '1'!=grid[i][j]) return;
    grid[i][j] = '0';
    dfs(grid, gridSize, gridColSize, i+1, j);
    dfs(grid, gridSize, gridColSize, i-1, j);
    dfs(grid, gridSize, gridColSize, i, j+1);
    dfs(grid, gridSize, gridColSize, i, j-1);
}

int numIslands(char** grid, int gridSize, int* gridColSize){
    if(grid==NULL || gridSize == 0 || gridColSize==NULL) return 0;

    int count = 0;
    for(int i=0; i<gridSize; i++) {
        for(int j = 0; j<gridColSize[i]; j++) {
            if('1' == grid[i][j])
                count ++;
                dfs(grid, gridSize, gridColSize, i, j);
        }
    }
    return count;
}

```

## 12.二叉树的层序遍历（Leetcode 102）

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
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> result;
        if (!root) return result;
        queue<TreeNode *> q;            // 队列
        q.push(root);
        while (!q.empty()) {
            int currentLevelSize = q.size();
            vector<int> currentLevelNodes;
            for (int i = 0; i < currentLevelSize; i++) {
                auto node = q.front();
                q.pop();
                currentLevelNodes.push_back(node->val);
                if (node->left) q.push(node->left);
                if (node->right) q.push(node->right);
            }
            result.push_back(currentLevelNodes);
        }
        return result;
    }
};
```

## 13.买卖股票的最佳时机 II（Leetcode 122）

```
// C

int maxProfit(int* prices, int pricesSize){
    if (pricesSize<=1) return 0;
    int total = 0;
    for (int i=0; i<pricesSize-1; i++) {
        if (prices[i+1] > prices[i]) {
            total += (prices[i+1] - prices[i]);
        }
    }
    return total;
}

```

## 14.搜索旋转排序数组（Leetcode 33）

```
// C

int search(int* nums, int numsSize, int target){
    if (0 == numsSize) return -1;
    int low = 0;
    int high = numsSize - 1;
    while(low <= high) {
        int mid = (low + high) / 2;
        if (nums[mid] == target) return mid;
        if (nums[mid] >= nums[0]) {             // mid 在左边上升区域
            (target >= nums[0] && target < nums[mid]) ? (high = mid - 1) : (low = mid + 1);
        } else {                                // mid 在右边上升区域 
            (target > nums[mid] && target <= nums[numsSize-1]) ? (low = mid + 1) : (high = mid - 1);
        }
    }
    return -1;
}

```

```
// C++

class Solution {
public:
    int search(vector<int>& nums, int target) {
        int numsSize = nums.size();
        if (0 == numsSize) return -1;
        int low = 0;
        int high = numsSize - 1;
        while(low <= high) {
            int mid = (low + high) / 2;
            if (nums[mid] == target) return mid;
            if (nums[mid] >= nums[0]) {             // mid 在左边上升区域
                (target >= nums[0] && target < nums[mid]) ? (high = mid - 1) : (low = mid + 1);
            } else {                                // mid 在右边上升区域 
                (target > nums[mid] && target <= nums[numsSize-1]) ? (low = mid + 1) : (high = mid - 1);
            }
        }
        return -1;
    }
};

```

## 15.四数之和（Leetcode 18）


```
// C++

class Solution {
public:
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        vector<vector<int> > result; 
        int numSize = nums.size();
        if (numSize < 4) return result;      
        sort(nums.begin(), nums.end());                         // 排序
        for(int a = 0; a <= numSize-4; a++){
            if(a > 0 && nums[a] == nums[a-1]) continue;         // 跳过相同的 a
            for(int b = a+1; b <= numSize-3; b++){
                if(b > a+1 && nums[b] == nums[b-1]) continue;   // 跳过相同的 b
                int ab = nums[a] + nums[b];          
                int c = b + 1;
                int d = numSize - 1;
                while(c < d){
                    int abcd = ab + nums[c] + nums[d]; 
                    if (abcd == target) {
                        result.push_back({nums[a],nums[b],nums[c],nums[d]});
                        c++;
                        d--;
                        while(c < d && nums[c] == nums[c-1]) c++;
                        while(c < d && nums[d] == nums[d+1]) d--;
                    } else {
                       abcd < target ? c++ : d--;   // 小于 c 右移，大于 d 左移
                    } 
                }
            }
        }
        return result;
    }
};

```

## 16.跳跃游戏 II（Leetcode 45）

```
// C

int jump(int* nums, int numsSize){
    if (0 == numsSize || NULL == nums) return -1;
    int jumpCount = 0;
    int end = numsSize - 1;
    while (end > 0) {
        // 找到最远的可以到达该 end 的位置，（也就是第一个到达 end 的位置）
        for (int i = 0; i <= (end-1); i++) {// 这个过程可以用二分查找
            if (i + nums[i] >= end) { 
                end = i;
                jumpCount++;
                break;
            };
        }
    }
    return jumpCount;
}

```
## 17.最小路径和（Leetcode 64）

```
// C++

class Solution {
public:
    int minPathSum(vector<vector<int>>& grid) {
        if (grid.size() == 0 || grid[0].size() == 0) return -1;
        int m = grid.size();
        int n = grid[0].size();
        vector<vector<int>> dp = vector<vector<int>>(m, vector<int>(n));
        dp[0][0] = grid[0][0];
        for (int i = 1; i < m; i++) {
            dp[i][0] = grid[i][0] + dp[i-1][0];
        }
        for (int j = 1; j < n; j++) {
            dp[0][j] = grid[0][j] + dp[0][j-1];
        }
        for (int i = 1; i < m; i++) {
            for (int j = 1; j < n; j++) {
                dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1]);
            }
        }
        return dp[m-1][n-1];
    }
};

```
