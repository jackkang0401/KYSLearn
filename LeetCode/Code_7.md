# Code_7


## 1.矩形区域不超过 K 的最大数值和（Leetcode 363）

```

// C++
// 1.DP+暴力（超时）

class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>>& matrix, int k) {
        /*
            dp[i1][j1][i2][j2]：表示从左上角(i1, j1) 到 右下角(i2, j2)的矩形的数值和
            状态转移方程为： 
                dp[i1][j1][i2][j2] = dp[i1][j1][i2-1][j2] + dp[i1][j1][i2][j2-1] - dp[i1][j1][i2-1][j2-1] + matrix[i2-1][j2-1]
        */
        if (matrix.size() == 0 || matrix[0].size() == 0) return 0;
        int n = matrix.size();
        int m = matrix[0].size();
        int max = INT_MIN;
        vector<vector<vector<vector<int>>>> dp(n+1, vector<vector<vector<int>>>(m+1, vector<vector<int>>(n+1, vector<int>(m+1, 0))));
        for (int i1 = 1; i1 <= n; i1++) {
            for (int j1 = 1; j1 <= m; j1++) {
                for (int i2 = i1; i2 <= n; i2++) {
                    for (int j2 = j1; j2 <= m; j2++) {
                        dp[i1][j1][i2][j2] = dp[i1][j1][i2-1][j2] + dp[i1][j1][i2][j2-1] - dp[i1][j1][i2-1][j2-1] + matrix[i2-1][j2-1];
                        if (dp[i1][j1][i2][j2] <= k && dp[i1][j1][i2][j2] > max) {
                            max = dp[i1][j1][i2][j2];
                        }
                    }
                }
            }
        }
        return max;
    }
};

```

```
// C++
// 2.DP+暴力+状态压缩（超时）

class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>>& matrix, int k) {
        /*
            dp[i1][j1][i2][j2]：表示从左上角(i1, j1) 到 右下角(i2, j2)的矩形的数值和
            状态转移方程为： 
                dp[i1][j1][i2][j2] = dp[i1][j1][i2-1][j2] + dp[i1][j1][i2][j2-1] - dp[i1][j1][i2-1][j2-1] + matrix[i2-1][j2-1]

            从上述代码发现，每次更换左上角 (i, j) 之后，之前记录的值都没用过，尝试每次更换左上角时就重复利用 dp，所以，状态转移方程为： 
                dp[i2][j2] = dp[i2-1][j2] + dp[i2][j2-1] - dp[i2-1][j2-1] + matrix[i2-1][j2-1]
        */
        if (matrix.size() == 0 || matrix[0].size() == 0) return 0;
        int n = matrix.size();
        int m = matrix[0].size();
        int max = INT_MIN;
        for (int i1 = 1; i1 <= n; i1++) {
            for (int j1 = 1; j1 <= m; j1++) {
                vector<vector<int>> dp(n+1, vector<int>(m+1, 0));               // 在这申请空间，省去初始化流程
                for (int i2 = i1; i2 <= n; i2++) {
                    for (int j2 = j1; j2 <= m; j2++) {
                        dp[i2][j2] = dp[i2-1][j2] + dp[i2][j2-1] - dp[i2-1][j2-1] + matrix[i2-1][j2-1];
                        if (dp[i2][j2] <= k && dp[i2][j2] > max) {
                            max = dp[i2][j2];
                        }
                    }
                }
            }
        }
        return max;
    }
};

```

```
// C++
// 3.二维抽象成一维+最大子序和+暴力 O(n^2m^2) 应考虑 n、m 大小情况

class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>>& matrix, int k) {
        int ans = INT_MIN;
        int n = matrix.size(), m = matrix[0].size();
        for (int i = 0; i < n; ++i) {                   // 上边界（行）
            vector<int> sumCol(m, 0);                   // 记录上边界到下边界每一列的值                              
            for (int j = i; j < n; ++j) {               // 下边界（行）
                // 计算当前第 i 行到第 j 行中每一列的和
                for (int c = 0; c < m; ++c) {
                    sumCol[c] += matrix[j][c];
                }

                // 优化 如果这个数组的最大子序和小于等于 k，说明最大和就为 rollMax，直接更新 ans 
                int rollMax = maxSubArray(sumCol);
                if (rollMax <= k) {
                    ans = max(ans, rollMax); 
                    continue;                           // 进入下次循环
                }
                // 暴力
                for (int l = 0; l < m; l++) {
                    int s = 0;
                    for (int r = l; r < m; r++) {
                        s += sumCol[r];
                        if (s > ans && s <= k) ans = s;
                        if (ans == k) return k;
                    }
                }
            }
        }
        return ans;
    }

private:
    // 最大子序和（Leetcode 53）
    int maxSubArray(vector<int>& nums) {
        /*
         dp(i)：[0..i](包含 0 和 i)中，以第 i 个数为结尾的连续子数组的最大和的值
         DP方程：dp[i] = max(dp[i-1], 0) + nums[i]
        */
        int pre = nums[0];
        int maxValue = pre;
        for (int i = 1, size = nums.size(); i < size; i++) {
            pre = max(pre, 0) + nums[i];
            maxValue = max(pre, maxValue);          // 记录最大值
        }
        return maxValue;
    }
};

```

```
// C++
// 4.二维抽象成一维+最大子序和+有序集合（二分）O(n^2mlogm) 应考虑 n、m 大小情况

class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>>& matrix, int k) {
        int ans = INT_MIN;
        int n = matrix.size(), m = matrix[0].size();
        for (int i = 0; i < n; ++i) {                   // 上边界（行）
            vector<int> sumCol(m, 0);                   // 记录上边界到下边界每一列的值                              
            for (int j = i; j < n; ++j) {               // 下边界（行）
                // 计算当前第 i 行到第 j 行中每一列的和
                for (int c = 0; c < m; ++c) {
                    sumCol[c] += matrix[j][c];
                }

                // 优化 如果这个数组的最大子序和小于等于 k，说明最大和就为 rollMax，直接更新 ans 
                int rollMax = maxSubArray(sumCol);
                if (rollMax <= k) {
                    ans = max(ans, rollMax); 
                    continue;                           // 进入下次循环
                }
                /*
                    问题变为：在一维数组 sumCol 中求解和不超过 K 的最大连续子数组之和

                    1.定义 S 为一维数组的前 i（0<=i<n） 项和的有序集合（也可以是数组）
                    2.求得的集合满足添加 S[r]-S[l] <= k，即 S[l] >= S[r]-k
                    3.通过枚举 r 便可以在 O(logn) 的时间内二分找到满足条件（S[l] >= S[r]-k）的 S[l]
                */
                set<int> S{0};
                int r = 0;
                for (int v : sumCol) {
                    r += v;
                    auto lb = S.lower_bound(r - k);     // 查找非递减序列中第一个 >= r-k 的数字
                    if (lb != S.end()) {
                        ans = max(ans, r - *lb);        // 更新满足条件结果(尽可能大)
                        if (k == ans) return ans;       
                    }
                    S.insert(r);                        // 当前 r 加入 S
                }
            }
        }
        return ans;
    }
    
private:
    // 最大子序和（Leetcode 53）
    int maxSubArray(vector<int>& nums) {
        /*
         dp(i)：[0..i](包含 0 和 i)中，以第 i 个数为结尾的连续子数组的最大和的值
         DP方程：dp[i] = max(dp[i-1], 0) + nums[i]
        */
        int pre = nums[0];
        int maxValue = pre;
        for (int i = 1, size = nums.size(); i < size; i++) {
            pre = max(pre, 0) + nums[i];
            maxValue = max(pre, maxValue);          // 记录最大值
        }
        return maxValue;
    }
};

```

## 2.分割数组的最大值（Leetcode 410）


```
// C++
// 1.DP

class Solution {
public:
    int splitArray(vector<int>& nums, int m) {
        /*
             dp[i][k]：表示将前缀区间 [0,i] 分成 k 段的各自和的最大值的最小值。那么，前缀区间 [0,j]（j<i）
            被分成 k-1 段各自和的最大值的最小值为 dp[j][k-1]
             
             每个分割至少要有 1 个元素
             
             状态转移方程：（sub[i]-sub[k] 为区间 [k+1, i] 的和，）
                dp[i][j] = min(dp[i][j], max(dp[k][j-1], sub[i]-sub[k]))
        */

        int n = nums.size();
        vector<vector<int>> dp(n+1, vector<int>(m+1, INT_MAX));
        vector<int> sub(n+1, 0);                        // 用于计算 nums 中区间 [j+1,i] 的数值和
        for (int i = 0; i < n; i++) {
            sub[i+1] = sub[i] + nums[i];
        }
        dp[0][0] = 0;
        for (int i = 1; i <= n; i++) {                  // 当前待分割的数据前缀区间 [0,i] 
            for (int k = 1; k <= min(i, m); k++) {      // 分割数
                for (int j = k-1; j < i; j++) {         // 枚举 i 之前各个区间的 k-1 个分割，取最小值 
                    // sub[i]-sub[k] 为区间 [k+1, i] 的和
                    dp[i][k] = min(dp[i][k], max(dp[j][k-1], sub[i]-sub[j])); 
                }
            }
        }
        return dp[n][m];
    }
};

```

```
// C++
// 2.二分查找+贪心

class Solution {
public:
    int splitArray(vector<int>& nums, int m) {
        int maxValue = 0;                       // 下界为数组 nums 中所有元素的最大值
        int sum = 0;                            // 上界为数组 nums 中所有元素的和
        for (int num : nums) {
            maxValue = max(maxValue, num);
            sum += num;                     
        }

        // 使用「二分查找」确定一个恰当的「子数组各自的和的最大值」，使得它对应的「子数组的分割数」等于 m
        int left = maxValue;
        int right = sum;
        while (left <= right) {
            int mid = left + (right-left) / 2;
            int splits = split(nums, mid);      // 计算当前分割数
            if (splits > m) {   
                left = mid + 1; // 分割数超过 m，说明当前选择的「子数组各自的和的最大值」太小，需要调大
            } else {
                /*
                     如果分割数为 m 不能放弃搜索，因为要使得「子数组各自的和的最大值」最小化，还应继续尝试
                    缩小这个值，最后一个一个符合条件的值即为所求值
                     注意 二分查找如果结束条件为 while (left = right) 此时调整范围需写为 right = mid
                */
                right = mid - 1;    // 分割数未超过 m，说明当前选择的「子数组各自的和的最大值」太大，需要调小
            }
        }
        return left;
    }

    // 按连续子数组和的最大值不超过 maxIntervalSum 进行划分，可以分割的非空的连续子数组的个数
    int split(vector<int>& nums, int maxIntervalSum) {
        int splits = 1;                                     // 至少是一个分割
        int curIntervalSum = 0;                             // 当前区间的和
        for (int num : nums) {
            if (curIntervalSum+num > maxIntervalSum) {      // 如果超过最大和
                curIntervalSum = 0; 
                splits++;                                   // 分割数 +1                                  
            }
            curIntervalSum += num;
        }
        return splits;
    }
};

```

## 3.学生出勤记录 II（Leetcode 552）

```
// C++
// 1.DFS (超时)

class Solution {
public:
    int checkRecord(int n) {
        if (n <= 0) return 0;
        if (n == 1) return 3;
        int mod = 1000000007;
        int result = 0;
        dfs("", n, result);
        return result;
    }

private:
    void dfs(string s, int n, int &result) {
        if (n == 0 && checkRecord(s)) {
            result++;
            return;
        }
        dfs(s+'A', n-1, result);
        dfs(s+'P', n-1, result);
        dfs(s+'L', n-1, result);
    }
    bool checkRecord(string &s) {
        int size = s.size();
        if (size <= 0) return false;
        int countA = 0;
        for (int i = 0; i<size; i++) {
            if ( s[i] == 'A' ) {
                countA++;
                if (countA >= 2) {
                    return false;
                } 
            } else if ( s[i] == 'L') {
                if (i < (size-2) && s[i+1] == 'L' && s[i+2] == 'L') {
                    return false;
                }
            }
        }
        return true;
    }
};

```

```
// C++
// 2.DP (超限)

class Solution {
public:
    int checkRecord(int n) {
        /*
            状态定义：
                i：字符数
                a：'A' 的数量，值为 0，1
                l: 字符串中结尾 ‘L’ 的数量，值为 0，1，2
                dp[i][a][l]：表示 i 个字符，a 个 'A'，l 个以 ‘L’ 结尾状态下的所有可被视为可奖励的出勤记录的数量

            状态转移方程：
                dp[i][0][0] = dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2] (末尾都加 ‘P’)
                dp[i][0][1] = dp[i-1][0][0] (末尾加 ‘L’)  
                dp[i][0][2] = dp[i-1][0][1] (末尾加 ‘L’) 
                dp[i][1][0] = dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2] + dp[i-1][1][0] + dp[i-1][1][1] + dp[i-1][1][2] (前三个末尾加 ‘A’，后 3 个末尾加‘P’)
                dp[i][1][1] = dp[i-1][1][0] (末尾加 ‘L’)  
                dp[i][1][2] = dp[i-1][1][1] (末尾加 ‘L’) 
        */
        if (n <= 0) return 0;
        if (n == 1) return 3;
        int mod = 1000000007;
        vector<vector<vector<int>>> dp(n+1, vector<vector<int>>(2, vector<int>(3, 0)));
        // 初始化（1 个字符）
        dp[1][0][0] = 1;        // 'P'
        dp[1][0][1] = 1;        // 'L'
        dp[1][1][0] = 1;        // 'A'  
        for(int i = 2; i <= n; i++) {
            //dp[i][0][0] = (dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2]) % mod;
            // 每一次都单独加算并对 mod 取模，处理 int 越界问题
            dp[i][0][0] = 0;
            for (int l = 0; l < 3; l++) {
                dp[i][0][0] = (dp[i][0][0] + dp[i-1][0][l]) % mod;
            }
            dp[i][0][1] = dp[i-1][0][0];
            dp[i][0][2] = dp[i-1][0][1];
            //dp[i][1][0] = (dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2] + dp[i-1][1][0] + dp[i-1][1][1] + dp[i-1][1][2]) % mod;
            // 每一次都单独加算并对 mod 取模，处理 int 越界问题
            dp[i][1][0] = dp[i][0][0];
            for (int l = 0; l < 3; l++) {
                dp[i][1][0] = (dp[i][1][0] + dp[i-1][1][l]) % mod;
            }
            dp[i][1][1] = dp[i-1][1][0];
            dp[i][1][2] = dp[i-1][1][1];
        }

        int result = 0;
        for (int a = 0; a < 2; a++) {
            for (int l = 0; l < 3; l++) {
                result = (result + dp[n][a][l]) % mod;
            }
        }
        return result;
    }
};

```

```
// C++
// 3.DP 空间优化

class Solution {
public:
    int checkRecord(int n) {
        if (n <= 0) return 0;
        if (n == 1) return 3;
        int mod = 1000000007;
        vector<vector<int>> dp(2, vector<int>(3, 0));
        // 初始化（1 个字符）
        dp[0][0] = 1;           // 'P'
        dp[0][1] = 1;           // 'L'
        dp[1][0] = 1;           // 'A'  
        // 空间可重复利用，不用循环每次都申请空间（需要注意某些位置需要重置原有值的），如果每次循环都申请空间会超出时间限制
        vector<vector<int>> newDp(2, vector<int>(3, 0));
        for(int i = 2; i <= n; i++) {
            // 每一次都单独加算并对 mod 取模，处理 int 越界问题
            newDp[0][0] = 0;
            for (int l = 0; l < 3; l++) {
                newDp[0][0] = (newDp[0][0] + dp[0][l]) % mod;
            }
            newDp[0][1] = dp[0][0];
            newDp[0][2] = dp[0][1];
            // 每一次都单独加算并对 mod 取模，处理 int 越界问题
            newDp[1][0] = newDp[0][0];
            for (int l = 0; l < 3; l++) {
                newDp[1][0] = (newDp[1][0] + dp[1][l]) % mod;
            }
            newDp[1][1] = dp[1][0];
            newDp[1][2] = dp[1][1];
            dp = newDp;
        }

        int result = 0;
        for (int a = 0; a < 2; a++) {
            for (int l = 0; l < 3; l++) {
                result = (result + dp[a][l]) % mod;
            }
        }
        return result;
    }
};

```


## 4.最小覆盖子串（Leetcode 76）

```
// C++
// 1.双指针

class Solution {
public:
    string minWindow(string s, string t) {

        if(s.size()<=0 || t.size()<= 0) return ""; 
        // 生成 t 的 hash 表
        unordered_map <char, int> hashMapT;
        for (auto &c: t) {
            hashMapT[c]++;
        }

        int l = 0, r = 0;
        int minIndex = -1, minLength = INT_MAX;     // 记录最小覆盖的下标与长度
        int sizeS = s.size();

        unordered_map <char, int> hashMapS;
        while (r < sizeS) {
            if (hashMapT.find(s[r]) != hashMapT.end()) {
                hashMapS[s[r]]++;
            }
            while (check(hashMapT, hashMapS) && l <= r) {
                int currentLength = r - l + 1;
                if (currentLength < minLength) {
                    minLength = currentLength;
                    minIndex = l;
                }
                if (hashMapT.find(s[l]) != hashMapT.end()) {
                    --hashMapS[s[l]];
                }
                l++;                                // 左边指针后移
            }
            r++;                                    // 右边指针后移
        }

        return minIndex == -1 ? "" : s.substr(minIndex, minLength);
    }

private:
    // hashMapT 中每一个 key 在 hashMapS 中的值都大于等于在 hashMapT 中的值，返回 true，否则返回 false
    bool check(unordered_map <char, int> &hashMapT, unordered_map <char, int> &hashMapS) {
        for (auto &p: hashMapT) {
            if (hashMapS[p.first] < p.second) { 
                return false;
            }
        }
        return true;
    }
};

```

```
// C++
// 2.双指针+预处理 s

class Solution {
public:
    string minWindow(string s, string t) {

        if(s.size()<=0 || t.size()<= 0) return ""; 
        // 生成 t 的 hash 表
        unordered_map <char, int> hashMapT;
        for (auto &c: t) {
            hashMapT[c]++;
        }
        // 去除 t 中没出现的字符，并记录剩余字符索引
        vector<pair<char, int>> p;
        for (int i = 0, size = s.size(); i < size; i++) {
            if (hashMapT.find(s[i]) != hashMapT.end()) {
                p.push_back(make_pair(s[i], i));
            }
        }

        int l = 0, r = 0;
        int minIndex = -1, minLength = INT_MAX;                     // 记录最小覆盖的下标与长度
        int sizeP = p.size();

        unordered_map <char, int> hashMapS;
        while (r < sizeP) {
            hashMapS[p[r].first]++;                                 // p[r].first 一定在 t 中 
            while (check(hashMapT, hashMapS) && l <= r) {
                int currentLength = p[r].second - p[l].second + 1;  // 利用下标计算 s 涵盖 t 的长度
                if (currentLength < minLength) {
                    minLength = currentLength;
                    minIndex = p[l].second;
                }
                --hashMapS[p[l].first];
                l++;                                                // 左边指针后移
            }
            r++;                                                    // 右边指针后移
        }

        return minIndex == -1 ? "" : s.substr(minIndex, minLength);
    }

private:
    // hashMapT 中每一个 key 在 hashMapS 中的值都大于等于在 hashMapT 中的值，返回 true，否则返回 false
    bool check(unordered_map <char, int> &hashMapT, unordered_map <char, int> &hashMapS) {
        for (auto &p: hashMapT) {
            if (hashMapS[p.first] < p.second) { 
                return false;
            }
        }
        return true;
    }
};


```

## 5.戳气球（Leetcode 312）

```
// C++
// 1.分治

class Solution {
public:
    int maxCoins(vector<int>& nums) {

        /*
            1.回溯法
             对于 [3,1,5,8] 的最大得分，第一次戳破气球有4种情况，假设首先戳破一个气球 5，则，问题变成了求 [3,1,8]的最大得分，
            问题规模减小一个元素。我们可以想到，采用递归的方法，减而治之，无球可戳后再回溯，当我们回溯完所有的戳法之后，就能找出
            最大得分。但是该回溯法的时间复杂度为 O(n!)，而气球个数的取值为 [0,500]，必然会超时。

            2.分治法
             对于 [3,1,5,8]，假设最后戳爆 5，则问题就被划分为如下图所示的两个子问题和一个 O(1) 的问题

                              [1,3,1,5,8,1]
                             ↙      ↓      ↘  
                     [1,3,1,5]   [1,5,1]   [5,8,1]

             其中，左右两端的元素表示不可戳，仅供计分的“虚拟气球”，而且其的值仅与位置有关。这里假设 f(start,end) 表示从第 start 
            到 end 个气球的最大得分，nums[i] 表示气球上的值，nums[start-1] 和 nums[end+1] 是“虚拟气球”，则有：

                f(start,end) = max(f(start,i-1) + nums[start-1]*nums[i]*nums[end+1] + f(i+1,end))
                
             其中 i 取值为 [start,end]
        */
        int size = nums.size();
        if (size == 0) return 0;
        int n = size + 2;
        vector<int> val(n, 1);
        for (int i = 1; i <= size; i++) {
            val[i] = nums[i-1];
        }
        vector<vector<int>> memo(n, vector<int>(n, -1));
        return solve(0, n-1, val, memo);
    }

private:
        int solve(int start, int end, vector<int> &val, vector<vector<int>> &memo) {
        // 小于等于 2 个元素
        if (end-start <= 1) {
            return 0;
        }
        // 如果已缓存直接返回结果
        if (memo[start][end] != -1) {
            return memo[start][end];
        }
        // 递归求得结果
        int maxCoin = 0;                        // 区间 [start, end] 能获得的最大硬币数
        for (int i = start+1; i < end; i++) {   // 迭代所有子情况
            // 计算当前情况能获得的最大硬币数
            int sum = solve(start,i,val,memo) + val[start]*val[i]*val[end] + solve(i,end,val,memo);   
            maxCoin = max(maxCoin, sum);        // 记录最大值
        }
        memo[start][end] = maxCoin;
        return maxCoin;
    }
};

```

```
// C++
// 2.DP

class Solution {
public:
    int maxCoins(vector<int>& nums) {
        /*
            DP
             可将「分治法」中的缓存表作为 DP 表，填表即可。通过从最小子问题开始进行简单尝试，可以发现长度为 2 的子问题的解仅依赖于
            长度为 1 子问题的解；长度为 3 的子问题的解仅依赖于长度为 2 的子问题的解......依次迭代即可得到最终结果
        */
        int size = nums.size();
        if (size == 0) return 0;
        int n = size + 2;
        vector<int> val(n, 1);
        for (int i = 1; i <= size; i++) {
            val[i] = nums[i-1];
        }
        vector<vector<int>> dp(n, vector<int>(n, 0));
        for (int start = n-3; start >= 0; start--) {        
            for (int end = start+2; end < n; end++) {       
                int maxCoin = 0;                                    // 区间 [start, end] 能获得的最大硬币数
                for (int i = start+1; i < end; i++) {               // 迭代所有子情况
                    int sum = dp[start][i] + val[start]*val[i]*val[end] + dp[i][end];
                    maxCoin = max(maxCoin, sum);
                }
                dp[start][end] = maxCoin;
            }
        }
        return dp[0][n-1];
    }
};

```


## 6.你能在你最喜欢的那天吃到你最喜欢的糖果吗？（Leetcode 1744）


```

// C++

class Solution {
public:
    vector<bool> canEat(vector<int>& candiesCount, vector<vector<int>>& queries) {
        int n = candiesCount.size();
        
        // 前缀和
        vector<long> sum(n);
        sum[0] = candiesCount[0];
        for (int i = 1; i < n; ++i) {
            sum[i] = sum[i - 1] + candiesCount[i];
        }
        
        vector<bool> ans;
        for (const auto& q: queries) {
            int favoriteType = q[0], favoriteDay = q[1], dailyCap = q[2];
            
            // 当前吃的糖果的数量范围
            long x1 = favoriteDay + 1;                                  // 下限        
            long y1 = (long)(favoriteDay + 1) * dailyCap;               // 上限

            // 第 favoriteType 种类型的糖果对应的编号范围
            long x2 = favoriteType == 0 ? 1 : sum[favoriteType - 1] + 1;// 下限
            long y2 = sum[favoriteType];                                // 上限
            
            ans.push_back(!(x1 > y2 || y1 < x2));
        }
        return ans;
    }
};


```


## 7.大餐计数（Leetcode 1711）


```
// C++

class Solution {
public:
    int countPairs(vector<int>& deliciousness) {
        if (deliciousness.size() <=0 ) return 0;
        int maxVal = *max_element(deliciousness.begin(), deliciousness.end());
        int maxSum = maxVal * 2;
        int pairs = 0;
        unordered_map<int, int> mp;
        for (auto& val : deliciousness) {
            for (int sum = 1; sum <= maxSum; sum <<= 1) {
                int count = mp.count(sum - val) ? mp[sum - val] : 0;
                pairs = (pairs + count) % 1'000'000'007;
            }
            mp[val]++;
        }
        return pairs;
    }
};

```


## 8.二叉树中所有距离为 K 的结点（Leetcode 863）


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
    vector<int> distanceK(TreeNode* root, TreeNode* target, int k) {
        
        // 1.前序遍历，生成目标节点的堆栈
        stack<TreeNode *> stack;
        stack.push(root);
        dfs(root, target, stack);

        // 2.对相关节点 dfs，生成包含目标节点的列表
        vector<int> result;
        set<int> visited; 
        int distance = k;
        while(!stack.empty()) {
            TreeNode* p = stack.top();
            stack.pop();
            //result.push_back(p->val);
            dfs(p, 0, distance, visited, result);
            visited.insert(p->val);
            distance--;
        }
        return result;
    }

    bool dfs(TreeNode* p, TreeNode*& target, stack<TreeNode *>& stack) {
        if (p) {
            if (p->val == target->val) {
                return true;
            }
            if(p->left) {
                stack.push(p->left);
                if (dfs(p->left, target, stack)) return true;
                stack.pop();
            }

            if(p->right) {
                stack.push(p->right);
                if (dfs(p->right, target, stack)) return true;
                stack.pop();
            }
        }
        return false;
    }

    void dfs(TreeNode* root, int current, int distance, set<int>& visited, vector<int>& result) {
        if (root == nullptr || visited.find(root->val) != visited.end()) {
            return;
        }
        if(current == distance) {
            result.push_back(root->val);
            return;
        }
        dfs(root->left, current+1, distance, visited, result);
        dfs(root->right, current+1, distance, visited, result);
    }
};


```


## 9.二叉树寻路（Leetcode 1104）


```
// C++

class Solution {
public:
    vector<int> pathInZigZagTree(int label) {
        if (label < 1) return {};

        // 1.计算 k 所在行，起始行为 1
        int row = 0;                              
        while (((2<<row) - 1) < label) row++;           
        row++;

        // 2.计算并生成结果
        if ((row&1) == 0) label = getReverse(label, row);
        vector<int> path;
        while (row > 0) {
            path.push_back((row&1) == 0 ? getReverse(label, row) : label);
            row--;
            label >>= 1;                    // 移到下个位置        
        }
        reverse(path.begin(), path.end());
        return path;
    }

    int getReverse(int label, int row) {
        return (1 << row - 1) + (1 << row) - 1 - label;
    }
};

```


## 10.网络延迟时间（Leetcode 743）

```

// C++
// 1.Dijkstra 算法

class Solution {
public:
    int networkDelayTime(vector<vector<int>>& times, int n, int k) {
        int maxValue = 100 * 100;
        
        // 1. 建议不同节点的传递时间的映射关系
        vector<vector<int>> g(n, vector<int>(n, maxValue));
        for (auto &t : times) {
            g[t[0]-1][t[1]-1] = t[2];
        }

        // 2. Dijkstra 算法计算时间
        vector<int> dist(n, maxValue);
        dist[k - 1] = 0;
        vector<int> used(n);
        for (int i = 0; i < n; ++i) {
            // 从「未确定节点」中取一个与起点 k 距离最短的点，将它归类为「已确定节点」
            int x = -1;
            for (int y = 0; y < n; ++y) {
                if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                    x = y;
                }
            }
            // 「更新」从起点 k 到其他所有「未确定节点」的距离
            used[x] = true;
            for (int y = 0; y < n; ++y) {
                dist[y] = min(dist[y], dist[x] + g[x][y]);
            }
        }

        // 3. 取出最小值并返回结果
        int ans = *max_element(dist.begin(), dist.end());
        return ans == maxValue ? -1 : ans;
    }
};


```
