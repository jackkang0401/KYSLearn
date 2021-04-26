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
            被分成 k-1 段各自和的最大值的最小值为 dp[j][k-1]。
             即，第一维是区间 [0,i] 的 k 个分割，第二维是分割的区间 [0,i]。

             由于区间 [0,j] 一定要分成 k-1 个非空连续子数组；j 的意义是：第 k-1 个分割的最后一个元素的下标；
            下标 k-1 的前面（不包括 k-1），一共有 k-1 个元素（这一条只要是下标从 0 开始均成立）；故 j 的枚举
            从 k-2 开始，到 i-1 结束，因为第 k 个分割至少要有 1 个元素

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
                for (int j = 0; j < i; j++) {           // 枚举 i 之前各个区间的 k-1 个分割，取最小值 
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
                i：字符串中字符数
                a：'A' 的数量，值为 0，1
                l: 字符串中结尾 ‘L’ 的数量，值为 0，1，2
                dp[i][a][l]：表示 i 个字符，a 个 'A'，l 个以 ‘L’ 结尾状态下的所有可被视为可奖励的出勤记录的数量

            状态转移方程：
                dp[i][0][0] = dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2] (末尾都加 ‘P’)
                dp[i][0][1] = dp[i-1][0][0] (末尾加 ‘L’)  
                dp[i][0][2] = dp[i-1][0][1] (末尾加 ‘L’) 
                dp[i][1][0] = dp[i-1][0][0] + dp[i-1][0][1] + dp[i-1][0][2]+dp[i-1][1][0] + dp[i-1][1][1] + dp[i-1][1][2] (前三个末尾加 ‘A’，后 3 个末尾加‘P’)
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
            if (hashMapT.find(p[r].first) != hashMapT.end()) {
                hashMapS[p[r].first]++;
            }
            while (check(hashMapT, hashMapS) && l <= r) {
                int currentLength = p[r].second - p[l].second + 1;  // 利用下标计算 s 涵盖 t 的长度
                if (currentLength < minLength) {
                    minLength = currentLength;
                    minIndex = p[l].second;
                }
                if (hashMapT.find(p[l].first) != hashMapT.end()) {
                    --hashMapS[p[l].first];
                }
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
