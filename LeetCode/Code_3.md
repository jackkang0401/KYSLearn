# Code_3


## 1.单词接龙（Leetcode 127）

```
// C++
// BFS

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        if (0 ==beginWord.size()) return 0;

        // 建立映射
        bool hasEndWord = false;
        unordered_map<string, vector<string>> wordMap;
        for (auto word : wordList) {
            if (word == endWord) hasEndWord = true;
            string key = word;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = key[i];
                key[i] = '*'; 
                wordMap[key].push_back(word);
                key[i] = c;
            }
        }

        if (false == hasEndWord) return 0;

        // BFS 能先到就先到，这样得到的转换长度才是最短的
        queue<pair<string,int>> q;
        q.push(make_pair(beginWord, 1));
        set<string> visitedSet;          // 记录已遍历字符串，避免重复遍历
        visitedSet.insert(beginWord);
        while(!q.empty()) {
            pair<string,int> wordPair = q.front();
            q.pop();
            string word = wordPair.first;
            int level = wordPair.second;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = word[i];
                word[i] = '*';
                for (auto w : wordMap[word]) {
                    if (w == endWord) return level + 1;
                    if (visitedSet.find(w) != visitedSet.end()) continue;
                    q.push(make_pair(w, level + 1));
                    visitedSet.insert(w);
                }
                word[i] = c;
            }
        }
        return 0;
    }
};

```

```
// C++
// DBFS

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        if (0 == beginWord.size()) return 0;

        // 建立映射
        bool hasEndWord = false;
        unordered_map<string, vector<string>> wordMap;
        for (auto word : wordList) {
            if (word == endWord) hasEndWord = true;
            string key = word;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = key[i];
                key[i] = '*';
                wordMap[key].push_back(word);
                key[i] = c;
            }
        }

        if (false == hasEndWord) return 0;

        // DBFS
        queue<pair<string, int>> beginQ;
        beginQ.push(make_pair(beginWord, 1));
        unordered_map<string, int> beginVis;        // 记录 begin 已遍历字符串，避免重复遍历
        beginVis[beginWord] = 1;

        queue<pair<string,int>> endQ;
        endQ.push(make_pair(endWord, 1));
        unordered_map<string,int> endVis;           // 记录 end 已遍历字符串，避免重复遍历
        endVis[endWord] = 1;

        // 两边同时走
        while(!beginQ.empty() && !endQ.empty()) {
            int beginAns = visitWord(beginQ, beginVis, endVis, wordMap);
            if (beginAns > -1) return beginAns;
            int endAns = visitWord(endQ, endVis, beginVis, wordMap);
            if (endAns > -1) return endAns;
        }
        return 0;
    }

private:
    int visitWord(queue<pair<string, int>>& q, unordered_map<string, int>& visited, unordered_map<string, int>& otherVis, unordered_map<string, vector<string>>& wordMap) {
        pair<string, int> wordPair = q.front();
        q.pop();
        string word = wordPair.first;
        int level = wordPair.second;
        for (int i = 0, size = word.size(); i < size; i++) {
            char c = word[i];
            word[i] = '*';
            for (auto w : wordMap[word]) {
                if (otherVis.find(w) != otherVis.end()) return level + otherVis[w];
                if (visited.find(w) != visited.end()) continue;
                q.push(make_pair(w, level+1));
                visited[w] = level+1;
            }
            word[i] = c;
        }
        return -1;
    }
};

```

## 2.搜索插入位置（Leetcode 35）

```
// C++
// 二分查找

class Solution {
public:
    int searchInsert(vector<int>& nums, int target) {
        int n = nums.size();
        int left = 0, right = n - 1;
        // 其实就是找第一个大于等于 target 的下标（看等于时停在哪）
        while (left <= right) {
            int mid = (right + left) >> 1;
            if (target > nums[mid]) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return left; // right+1
    }
};

```

## 3.二叉树的后序遍历（Leetcode 145）

```
// C++
// 后续遍历

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
 
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        if (nullptr == root) return vector<int>();
        vector<int> result;
        stack<TreeNode *> stack;
        stack.push(root);
        while(!stack.empty()) {
            TreeNode* node = stack.top();
            stack.pop();
            result.insert(result.begin(), node->val);
            if (nullptr != node->left) {
                stack.push(node->left);
            }
            if (nullptr != node->right) {
                stack.push(node->right);
            }
        }
        return result;
    }
};

```

## 4.最长回文子串（Leetcode 5）

```
// C++
// 1. DP 超时

class Solution {
public:
    string longestPalindrome(string s) {
        int size = s.size();
        if (size < 2) return s;
        int maxSize = 1, begin = 0;
        // dp[i][j] 表示子串 s[i..j] 是否为回文子串（包含 i、j）
        vector<vector<bool>> dp(size, vector(size, false));
        for (int i = 0; i < size; i++) {
            dp[i][i] = true;
        }
        for (int j = 1; j < size; j++) {
            for (int i = 0; i < j; i++) {
                if (s[i] != s[j]) {
                    dp[i][j] = false;
                } else {
                    // 长度小于等于 3，可直接设置为 true
                    dp[i][j] = ((j-i)+1 <= 3) ? true : dp[i+1][j-1];
                }
                if (true == dp[i][j] && (j-i+1) > maxSize) {
                    maxSize = j-i+1;            // 长度（直径）
                    begin = i;                  // 左端点
                }
            }
        }
        return s.substr(begin, maxSize);
    }
};

```

```
// C++
// 2. 中心扩展法

class Solution {
public:
    string longestPalindrome(string s) {
        int size = s.size();
        if (size < 2) return s;
        int begin = 0;
        int maxSize = 1;
        for(int i = 0, count = size*2; i < count; i++){
            // 长度分别为奇数（s[i]）、偶数（中心为空）的回文子串
            int left = i / 2;
            int right = left + i % 2;
            // 向外扩张
            int currentBegin = 0;
            int currentSize = 0;
            while(left >= 0 && right < size && s[left] == s[right]){
                currentBegin = left;
                currentSize = right - left + 1;
                left--;
                right++;
            }
            // 如果大于，进行更新
            if (currentSize > maxSize) {
                maxSize = currentSize;
                begin = currentBegin;
            }
        }
        return s.substr(begin, maxSize);
    }
};

```

```
// C++
// 3. Manacher

class Solution {
public:
    string longestPalindrome(string s) {
        int n = s.size();
        if (n < 2) return s;
        // 插入字符串
        string str = "$#";
        for (char c: s) {
            str += c;
            str += '#';
        }
        str += '!';
        n = str.size() - 1;

        vector<int> radius = vector<int>(n);    // 位置 i 对应的最大回文串半径
        int maxRightI = 0, maxRight = 0;        // 前 i 个位置对应所有回文串中的最大右端点及位置
        int maxRadiusI = 0;                     // 最大半径位置
        for (int i = 1; i < n; i++) {
            radius[i] = (i <= maxRight) ? min(maxRight-i+1, radius[2*maxRightI-i]) : 1;
            while (str[i+radius[i]] == str[i-radius[i]]) radius[i]++;   // 继续向外扩张
            int curRight = i+radius[i]-1;                               // 右端点  
            if (curRight > maxRight) {                                             
                maxRightI = i;
                maxRight = curRight;
            }
            if (radius[i] > radius[maxRadiusI]) maxRadiusI = i;         // 记录最大半径位置   
        }

        // 生成最大回文子串
        int begin = maxRadiusI - radius[maxRadiusI] + 1;
        int end = maxRadiusI + radius[maxRadiusI] - 1;
        string result;
        for (int i = begin; i < end; i++) {
            if (str[i] == '#' || str[i] == '$' || str[i] == '!') continue;
            result.push_back(str[i]);
        }
        return result;
    }
};

```

## 5.不同路径（Leetcode 62）


```

// C++
// 1

class Solution {
public:
    int uniquePaths(int m, int n) {
        vector<vector<int>> dp = vector(n, vector(m, 0)); // dp[i][j] 是到达 (i,j) 的路径总数
        for (int i = 0; i < n; i++) dp[i][0] = 1;
        for (int j = 0; j < m; j++) dp[0][j] = 1;
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < m; j++) {
                dp[i][j] = dp[i-1][j] + dp[i][j-1];
            }
        }
        return dp[n-1][m-1];
    }
};

```

```

// C++
// 2.优化 空间复杂度 O(2n)

class Solution {
public:
    int uniquePaths(int m, int n) {
        vector<int> pre = vector(m, 1); 
        vector<int> cur = vector(m, 1); 
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < m; j++) {   // cur 每次 0 位置已初始化 1
                cur[j] = cur[j-1] + pre[j]; // cur[j-1]：左，pre[j]：上
            }
            pre.assign(cur.begin(), cur.end());
        }
        return pre[m-1];
    }
};

```

```

// C++
// 3.优化 空间复杂度 O(n)

class Solution {
public:
    int uniquePaths(int m, int n) { 
        vector<int> cur = vector(m, 1); 
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < m; j++) {   // cur 每次 0 位置已初始化 1
                cur[j] += cur[j-1];         // cur[j-1]：左，cur[j]：上
            }
        }
        return cur[m-1];
    }
};

```

## 6.不同路径II（Leetcode 63）


```
// C++

class Solution {
public:
    int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
        int n = obstacleGrid.size(), m = obstacleGrid[0].size();
        if (0 == n || 0 == m) return 0;
        vector<int> cur = vector(m, 0); 
        cur[0] = (0 == obstacleGrid[0][0]) ? 1 : 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (obstacleGrid[i][j] == 1) {
                    cur[j] = 0;
                    continue;
                }
                if (j-1 >= 0) {
                    cur[j] += cur[j-1];// cur[j-1]：左，cur[j]：上
                }
            }
        }
        return cur[m-1];
    }
};

```


## 7.不同路径III（Leetcode 980）


```
// C++
// 1

class Solution {
public:
    int uniquePathsIII(vector<vector<int>>& grid) {
        int ans = 0;
        int row = grid.size(), col = grid[0].size();
        int x = 0, y = 0, cnt = 0;
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                if (2 == grid[i][j] || 0 == grid[i][j]) {
                    cnt ++;         // 记录所有可走位置数量
                } else if (grid[i][j] == 1) {
                    x = i, y = j;
                }
            }
        }
        dfs(x, y, row, col, cnt, grid, ans);
        return ans;
    }

private:
    void dfs(int x, int y, int row, int col, int cnt, vector<vector<int>> &grid, int &ans) {
        if(grid[x][y] == 2) {
            if(0 == cnt) ans++;     // 经过所有的0 才算一条合法路径
            return;                 
        }
        int cur = grid[x][y];       // 保存当前值
        grid[x][y] = 3;             // 标记为已遍历
        int dx[4] = {1, 0, -1, 0}, dy[4] = {0, 1, 0, -1};
        for(int i = 0; i < 4; i++) {
            int a = x + dx[i];
            int b = y + dy[i];
            if((a >= 0 && a < row) && (b >= 0 && b < col)) {
                if(-1 == grid[a][b] || 3 == grid[a][b]) continue;
                dfs(a, b, row, col, cnt - 1, grid, ans);
            }
        }
        grid[x][y] = cur;           // 恢复值
    }
};

```

```

// C++
// 2. 消耗极大的空间、时间，仅提供思路，不建议使用

class Solution {
public:
    int uniquePathsIII(vector<vector<int>>& grid) {
        int row = grid.size(), col = grid[0].size();
        int x = 0, y = 0, cnt = 0;
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j++) {
                if (2 == grid[i][j] || 0 == grid[i][j]) {
                    cnt |= (1 << (i * col + j)); // 记录所有可走位置（包含结束位置）
                } else if (grid[i][j] == 1) {
                    x = i, y = j;
                }
            }
        }
        /*
            memo(x,y,cnt) 为从 (x,y) 开始行走，还没有遍历的无障碍方格集合为 cnt 的路径的数量
            并通过记忆化状态 (x,y,cnt) 缓存的结果来避免重复搜索
        */
        vector<vector<vector<int>>> memo = vector(row, vector(col, vector(1 << (row*col), -1)));
        return dfs(x, y, row, col, cnt, memo, grid);
    }

private:
    int dfs(int x, int y, int row, int col, int cnt, vector<vector<vector<int>>> &memo, vector<vector<int>>& grid) {
        if (memo[x][y][cnt] != -1) return memo[x][y][cnt];
        if(2 == grid[x][y]) return (0 == cnt) ? 1 : 0;      // 到达结束位置
        
        int ans = 0;
        int dx[4] = {1, 0, -1, 0}, dy[4] = {0, 1, 0, -1};
        for(int i = 0; i < 4; i++) {
            int a = x + dx[i];
            int b = y + dy[i];
            if((a >= 0 && a < row) && (b >= 0 && b < col)) {
                int cur = 1 << (a * col + b);
                if (cnt & cur) {
                    ans += dfs(a, b, row, col, cnt ^ cur, memo, grid);
                }
            }
        }
        memo[x][y][cnt] = ans;
        return ans;
    }
};

```

## 8.青蛙过河（Leetcode 403）

```
// C++
// 1.DP

class Solution {
public:
    bool canCross(vector<int>& stones) {
        int size = stones.size();
        /*
            key 表示石头的位置，value 是一个包含 jumpSize 的集合，
            jumpSize 为跳到 key 位置需要的跳跃距离
        */
        unordered_map<int, set<int>> map;
        map[0].insert(0);
        for(int i = 0; i < size; i++) {
            // 获取到达 stones[i] 的所有跳跃距离
            for(int k : map[stones[i]]) { 
                // 计算当前可跳距离
                for (int jumpSize = k - 1; jumpSize <= k + 1; jumpSize++) {
                    if (jumpSize > 0) {
                        // stones[i]：石头位置，stones[i]+jumpSize：落点位置（可能为水里）
                        // 记录可跳到的位置及其对应距离
                        map[stones[i]+jumpSize].insert(jumpSize); 
                    }
                }
            }
        }
        return map[stones[size-1]].size() > 0;
    }
};

```

```

// C++
// 2. DP 比方法 1 慢些

class Solution {
public:
    bool canCross(vector<int>& stones) {
        int size = stones.size();
        if(stones[1] != 1) return false;                                    // 第一步只能跳 1 单元格
        vector<vector<bool>> dp = vector(size, vector(size+1, false));      // dp[i][k] 表示能否由 i 前面的某一个石头 j 通过跳 k 步到达 i
        dp[0][0] = true;
        for(int i = 1; i < size; i++){
            for(int j = 0; j < i; j++){                                     // 遍历之前的所有石头位置
                int k = stones[i] - stones[j];                              // 计算 j 跳到 i，需要的跳跃距离 k
                if(k <= i){
                    dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];    // 跳到 j 的所有可能跳跃距离为 k-1、k、k+1（看看有没有能通过跳 k-1、k、k+1 距离到达 j 的）
                    if(i == size-1 && dp[i][k]) return true;                // 当前位置是最后的位置，且可跳到
                }
            }
        }
        return false;
    }
};

```

## 9.最长公共子序列（Leetcode 1143）

```
// C++
// DP

class Solution {
public:
    int longestCommonSubsequence(string text1, string text2) {
        int m = text1.size(), n = text2.size();
        vector<vector<int>> dp = vector(m+1, vector(n+1, 0));
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (text1[i-1] == text2[j-1]) {
                    dp[i][j] = dp[i-1][j-1] + 1;
                } else {
                    dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
                }
            }
        }
        return dp[m][n];
    }
};

```

## 10.爬楼梯（Leetcode 70）


```

// C++
// 1.DP

class Solution {
public:
    int climbStairs(int n) {
        /*  
            dp(x)：到达 x+1 的方法总数
            dp(x) = dp(x-1) + dp(x-2)
            dp[0] = 1
            dp[1] = 2;
        */
        if (n <= 2) return n;  
        int p = 1, q = 2; // p 上上个，q 上个
        for (int i = 2; i < n; i++) {
            int k = p + q;
            p = q;
            q = k;
        }
        return q;
    }
};

```

```

// C++
// 2.DP

class Solution {
public:
    int climbStairs(int n) { 
        int p = 0, q = 0, k = 1; 
        /* 
                 i = 0    i = 1    i = 2
        0,0,1 -> 0,1,1 -> 1,1,2 -> 1,2,3 -> ... 
        */    
        for (int i = 0; i < n; i++) {
            p = q;
            q = k;
            k = p + q;
        }
        return k;
    }
};

```

## 11.使用最小花费爬楼梯（Leetcode 746）


```
// C++
// DP

class Solution {
public:
    int minCostClimbingStairs(vector<int>& cost) {
        // dp[i] = cost[i] + min(dp[i-1], dp[i-2])
        int p = 0, q = 0;
        for (int i = 0, size = cost.size(); i < size; i++) {
            int k = cost[i] + min(p, q);
            p = q;
            q = k;
        }
        return min(p, q);
    }
};

```

## 12.三角形最小路径和（Leetcode 120）


```
// C++
// 1.DP

class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        /*  
                 j
             i  [2]
                [3,4]
                [6,5,7]
                [4,1,8,3]
            
            DP方程：dp[i][j] = triangle[i][j] + min(dp[i-1][j-1], dp[i-1][j]);
        */
        int size = triangle.size();
        vector<vector<int>> dp(size, vector<int>(size));
        dp[0][0] = triangle[0][0];
        // 上 -> 下 DP
        for(int i = 1; i < size; i++) {
            dp[i][0] = dp[i-1][0] + triangle[i][0];
            for (int j = 1; j < i; j++) {
                dp[i][j] = min(dp[i-1][j-1], dp[i-1][j]) + triangle[i][j];
            }
            dp[i][i] = dp[i-1][i-1] + triangle[i][i];
        }
        return *min_element(dp[size-1].begin(), dp[size-1].end());
    }
};

```



```

// C++
// 2.DP 空间优化 O(n)

class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        int size = triangle.size();
        vector<int> dp(size, 0);
        dp[0] = triangle[0][0];
        // 上 -> 下 DP
        for (int i = 1; i < size; ++i) {
            dp[i] = dp[i - 1] + triangle[i][i];
            for (int j = i - 1; j > 0; --j) {   // 需要从后往前，否则旧值会被替换掉
                dp[j] = min(dp[j-1], dp[j]) + triangle[i][j];
            }
            dp[0] += triangle[i][0];
        }
        return *min_element(dp.begin(), dp.end());
    }
};


```

```

// C++
// 2.DP 空间优化 O(n)，下 -> 上

class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        int size = triangle.size();
        vector<int> dp(size, 0);
        dp.assign(triangle[size-1].begin(), triangle[size-1].end());
        // 下 -> 上 DP
        for (int i = size-2; i >= 0; i--) {
            for (int j = 0; j <= i; j++) { 
                dp[j] = triangle[i][j] + min(dp[j], dp[j+1]);
            }
        }
        return dp[0];
    }
};


```

## 13.最大子序和（Leetcode 53）


```

// C++
// DP

class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        /*
         dp(i) 代表以第 i 个数结尾的「连续子数组的最大和」/Users/kangyongshuai/Desktop/KYSJianshuDemo/LeetCode/Code_3.md
         DP方程：dp[i] = max(dp[i-1], 0) + nums[i]
        */
        int pre = nums[0];
        int maxValue = pre;
        for (int i = 1, size = nums.size(); i < size; i++) {
            pre = max(pre, 0) + nums[i];
            maxValue = max(pre, maxValue); // 记录最大值
        }
        return maxValue;
    }
};


```

## 14.乘积最大子数组（Leetcode 152）


```

// C++
// DP


class Solution {
public:
    int maxProduct(vector<int>& nums) {
        /*
            maxDP(i)：以第 i 个数为结尾的乘积最大连续子数组的值
            minDP(i)：以第 i 个数为结尾的乘积最小连续子数组的值

            maxDP(i) = max(maxDP[i-1]*nums[i], minDP[i-1]*nums[i], nums[i])
            minDP[i] = min(minDP[i-1]*nums[i], maxDP[i-1]*nums[i], nums[i])

            可以考虑把
                1. nums[i] 与 maxDP 第 i-1 个元素结尾的乘积
                2. nums[i] 与 nimDP 第 i-1 个元素结尾的乘积
                3. num[i]
            三者取大写入 maxDP(i)，三者取小写入 minDP(i)
        */

        vector <int> maxDP(nums), minDP(nums);
        for (int i = 1; i < nums.size(); ++i) {
            maxDP[i] = max(maxDP[i-1]*nums[i], max(minDP[i-1]*nums[i], nums[i])); // 取最大
            minDP[i] = min(minDP[i-1]*nums[i], min(maxDP[i-1]*nums[i], nums[i])); // 取最小
        }
        return *max_element(maxDP.begin(), maxDP.end());
    }
};


```

```

// C++
// DP 空间优化

class Solution {
public:
    int maxProduct(vector<int>& nums) {
        int maxPre = nums[0], minPre = nums[0]; // 记录上一个最大，最小值
        int ans = nums[0];                      // 记录最大值
        for (int i = 1, size = nums.size(); i < size; i++) {
            int mx = maxPre, mn = minPre;
            maxPre = max(mx*nums[i], max(mn*nums[i], nums[i]));
            minPre = min(mn*nums[i], min(mx*nums[i], nums[i]));
            ans = max(maxPre, ans);
        }
        return ans;
    }
};

```

## 15.零钱兑换（Leetcode 322）


```

// C++
// 1. dfs 超时

class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        int size = coins.size();
        if (0 == size) return -1;
        int minValue = amount+1;    // 初始值 size+1，结果不可能比它大
        dfs(coins, amount, 0, minValue);
        return minValue > amount ? -1 : minValue;
    }

    void dfs(vector<int>& coins, int amount, int count, int& minValue) {
        if (amount < 0) return;
        if (0 == amount) minValue = count < minValue ? count : minValue;
        for (int i = 0, size = coins.size(); i < size; i++) {
            dfs(coins, amount-coins[i], count+1, minValue);
        }
    }
};

```

```
// C++
// 2. DP

class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        // dp(i) 为组成金额 i 所需最少的硬币数量
        vector<int> dp(amount+1, amount+1);
        dp[0] = 0;
        for (int i = 1; i <= amount; ++i) {
            for (int j = 0, size = coins.size(); j < size; j++) {
                if (coins[j] <= i) {
                    dp[i] = min(dp[i], dp[i-coins[j]]+1);
                }
            }
        }
        return dp[amount]>amount ? -1 : dp[amount];
    }
};

```

## 16.零钱兑换 II（Leetcode 518）


```

// C++
// 1. DP

class Solution {
public:
    int change(int amount, vector<int>& coins) {
        /*
            1.分治，子问题，最优子结构
            2.定义状态：dp[i][j]：硬币列表前 i 个硬币能够凑成总金额为 j 的组合数
            3.DP方程：
                dp[i][j]= dp[i-1][j] (j-coins[i-1] < 0)
                dp[i][j] = dp[i-1][j] + dp[i][j-coins[i-1]] (j-coins[i-1] >= 0)
        */
        int size = coins.size();
        vector<vector<int>> dp(size+1, vector(amount+1, 0));
        for (int i = 0; i <= size; i++) {
            dp[i][0] = 1;
        }

        for (int i = 1; i <= size; i++ ) {
            for (int j = 1; j <= amount; j++) {
                if (j-coins[i-1] < 0) {
                    // 当选择的第 i 个硬币的金额比想凑的金额大时，只能选择不装
                    dp[i][j] = dp[i-1][j];
                } else {
                    // dp[i][j] 是共有多少种凑法，所以 dp[i][j] = 不装 + 装
                    dp[i][j] = dp[i-1][j] + dp[i][j-coins[i-1]];
                }
            }
        }
        return dp[size][amount];
    }
};


```

```
// C++
// 2. DP 空间优化

class Solution {
public:
    int change(int amount, vector<int>& coins) {
        vector<int> dp(amount+1, 0);
        dp[0] = 1;      // amount == 0，则组合数为 1
        for (int i = 0, size = coins.size(); i < size; i++) {
            for (int j = coins[i]; j <= amount; j++) {
                dp[j] += dp[j-coins[i]];
            }
        }
        return dp[amount];
    }
};


```

## 17.打家劫舍（Leetcode 198）


```

// C++
// 1. DP

class Solution {
public:
    int rob(vector<int>& nums) {
        /* 
            dp[i][j]: i 表示第一个位置，j 为 0 表示不偷，j 为 1 表示偷
                dp[i][0] = max(dp[i-1][0], dp[i-1][1])
                dp[i][1] = dp[i-1][0] + nums[i]
        */

        int size = nums.size();
        if (0 == size ) return 0;
        vector<vector<int>> dp(size, vector(2, 0));
        dp[0][0] = 0;
        dp[0][1] = nums[0];

        for (int i = 1; i < size; i++) {
            dp[i][0] = max(dp[i-1][0], dp[i-1][1]);
            dp[i][1] = dp[i-1][0] + nums[i];
        }

        return max(dp[size-1][0], dp[size-1][1]);
    }
};


```


```

// C++
// 2. DP 另一种状态定义

class Solution {
public:
    int rob(vector<int>& nums) {
        /* 
            dp[i]: 0~i 能偷到的最高金额
                dp[i] = max(dp[i-1], dp[i-2] + nums[i])
        */

        int size = nums.size();
        if (size < 2) return 0 == size ? 0 : nums[0];
        vector<int> dp(size, 0);
        dp[0] = nums[0];
        dp[1] = max(nums[0], nums[1]);

        for (int i = 2; i < size; i++) {
            dp[i] = max(dp[i-1], dp[i-2]+nums[i]); // i 偷与不偷取大的
        }

        return dp[size-1];
    }
};


```


```

// C++
// 3. DP 方法 2 的基础上空间优化

class Solution {
public:
    int rob(vector<int>& nums) {
        int pre1 = 0, pre2 = 0; // pre1 上一个，pre2 上上个
        for (int i = 0, size = nums.size(); i < size; i++) {
            int now = max(pre1, pre2+nums[i]);
            pre2 = pre1;
            pre1 = now;
        }
        return pre1;
    }
};

```

## 18.打家劫舍 II（Leetcode 213）


```
// C++
// DP

class Solution {
public:
    int rob(vector<int>& nums) {
        /*
            可转换为 Leetcode 198 
                1.不偷第一个
                2.不偷最后一个
        */

        int size = nums.size();
        if (size < 2) return 0 == size ? 0 : nums[0];

        // 不偷第一个
        int pre1 = 0, pre2 = 0; // pre1 上一个，pre2 上上个
        for (int i = 1; i < size; i++) {
            int now = max(pre1, pre2+nums[i]);
            pre2 = pre1;
            pre1 = now;
        }

        int maxValue= pre1;

        // 不偷最后一个
        pre1 = 0, pre2 = 0; // pre1 上一个，pre2 上上个
        for (int i = 0; i < size-1; i++) {
            int now = max(pre1, pre2+nums[i]);
            pre2 = pre1;
            pre1 = now;
        }

        return max(maxValue, pre1);
    }
};


```

## 19.打家劫舍 III（Leetcode 337）


```

// C++
// 1. DP

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
    unordered_map <TreeNode*, int> f, g;
    
    // 后续遍历生成结果
    void dfs(TreeNode* o) {
        if (!o) return;
        dfs(o->left);
        dfs(o->right);
        f[o] = o->val + g[o->left] + g[o->right];                           // o 选中
        g[o] = max(f[o->left], g[o->left]) + max(f[o->right], g[o->right]); // o 不选中
    }

    int rob(TreeNode* o) {

        /*
            我们可以用 f(o)表示选择 o 节点的情况下，o 节点的子树上被选择的节点的最大权值和；
            g(o) 表示不选择 o 节点的情况下，o 节点的子树上被选择的节点的最大权值和；
            l 和 r 分别代表 o 的左右孩子。

            1. 当 o 被选中时，o 的左右孩子都不能被选中，故 o 被选中情况下子树上被选中点的最大权值和
            为 l 和 r 不被选中的最大权值和相加，即 f(o) = g(l) + g(r)
            2. 当 o 不被选中时，o 的左右孩子可以被选中，也可以不被选中。对于 o 的的孩子 x，它对 o 
            的贡献是 x 被选中和不被选中情况下权值和的较大值。故 g(o) = max(f(l),g(l)) + max(f(r),g(r))
        */

        dfs(o);
        return max(f[o], g[o]);
    }
};


```

## 20.完全平方数（Leetcode 279）


```

// C++
// 2. DP 空间优化

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */

struct SubtreeStatus {
    int selected;
    int notSelected;
};

class Solution {
public:
    unordered_map <TreeNode*, int> f, g;

    // 后续遍历生成结果
    SubtreeStatus dfs(TreeNode* o) {
        if (!o) return {0, 0};
        auto l = dfs(o->left);
        auto r = dfs(o->right);
        int selected = o->val + l.notSelected + r.notSelected;
        int notSelected = max(l.selected, l.notSelected) + max(r.selected, r.notSelected);
        return {selected, notSelected};
    }

    int rob(TreeNode* o) {

        /*
            无论是 f(o) 还是 g(o)，最终的值只和 f(l)、g(l)、f(r)、g(r) 有关，所以对于每个节点，
            我们只关心它的孩子节点的 f 和 g 是多少。我们可以设计一个结构，表示某个节点的 f 和 g 值，
            在每次递归返回的时候，都把当前节点对应的 f 和 g 返回给上一级，即可省去哈希映射的空间
        */

        auto rootStatus = dfs(o);
        return max(rootStatus.selected, rootStatus.notSelected);
    }
};


```


```
// C++
// DP

class Solution {
public:
    int numSquares(int n) {
        /*
            dp[i]：存放组成数字 i 需要的完全平方数最少的数量 
            DP方程：
                 dp[i] = min(dp[i], dp[i-j*j]+1);
        */
        vector<int> dp(n+1, 0);
        for (int i = 1; i<=n; i++) {
            dp[i] = i;
            for (int j = 1; j*j <= i; j++ ){
                dp[i] = min(dp[i], dp[i-j*j]+1);
            }
        }
        return dp[n];
    }
};


```
