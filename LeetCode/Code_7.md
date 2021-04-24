# Code_7


## 1.矩形区域不超过 K 的最大数值和（Leetcode 363）

```

// C++
// 1.DP + 暴力（超时）

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
// 2.DP + 暴力 + 状态压缩（超时）

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
// 3.二维抽象成一维 + 最大子序和 + 暴力 O(n^2m^2) 应考虑 n、m 大小情况

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
// 4.二维抽象成一维 + 最大子序和 + 有序集合（二分）O(n^2mlogm) 应考虑 n、m 大小情况

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
