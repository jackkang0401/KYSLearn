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
