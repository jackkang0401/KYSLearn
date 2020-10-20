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

        // BFS
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
// 1.DP

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
                    /*  
                        s[i] == s[j] 
                        ((j - 1) - (i + 1) + 1 < 2) => (j - i < 3) 
                        表示只有一个字符或空串，可直接设置 dp[i][j] = true
                    */
                    dp[i][j] = (j - i < 3) ? true : dp[i+1][j-1];
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
// 2.中心扩展法

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
// 3.Manacher

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
            for (int j = 1; j < m; j++) {
                cur[j] = cur[j-1] + pre[j];
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
            for (int j = 1; j < m; j++) {
                cur[j] += cur[j-1];
            }
        }
        return cur[m-1];
    }
};

```

## 6.不同路径II（Leetcode 63）


```

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
                if (j-1 >= 0 && 0 == obstacleGrid[i][j-1]) {
                    cur[j] += cur[j-1];
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
            代表可以通过大小为 jumpSize 的一跳到达当前位置
        */
        unordered_map<int, set<int>> map;
        map[0].insert(0);
        for(int i = 0; i < size; i++) {
            for(int k : map[stones[i]]) { 
                for (int jumpSize = k - 1; jumpSize <= k + 1; jumpSize++) {
                    if (jumpSize > 0) {
                        // stones[i]：石头位置，stones[i]+jumpSize：落点位置（可能为水里）
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
        if(stones[1] != 1) return false; // 第一步只能跳 1 单元格
        // dp[i][k] 表示能否由前面的某一个石头 j 通过跳 k 步到达当前这个石头 i，j 的范围是 [1, i - 1]
        vector<vector<bool>> dp = vector(size, vector(size+1, false));
        dp[0][0] = true;
        for(int i = 1; i < size; i++){
            for(int j = 0; j < i; j++){
                int k = stones[i] - stones[j];
                if(k <= i){
                    dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];
                    if(i == size-1 && dp[i][k]) return true;
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
// 1.

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
// 2.

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
