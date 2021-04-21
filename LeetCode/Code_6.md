# Code_6


## 1.任务调度器（Leetcode 621）

```

// C++
// 构造

class Solution {
public:
    int leastInterval(vector<char>& tasks, int n) {
        int len = tasks.size();
        vector<int> taskCountVector(26, 0);
        for(char c : tasks) {
            taskCountVector[c-'A']++;                   // 统计各个任务数量
        }
        int maxSameTaskCount = 0;                       // 记录不同种类的任务中，任务数量最多的任务数  
        int count = 0;                                  // 数量最多的任务有多少种               
        for (auto taskCount : taskCountVector) {
            if (taskCount > maxSameTaskCount) {
                maxSameTaskCount = taskCount;
                count = 1;
            } else if (taskCount == maxSameTaskCount){
                count++;
            }
        }
        return max(len, count+(n+1)*(maxSameTaskCount-1) );
    }
};

```


## 2.数组的相对排序（Leetcode 1122）


```

// C++
// 1. 自定义排序规则

class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        unordered_map<int, int> rank;
        for (int i = 0; i < arr2.size(); ++i) {
            rank[arr2[i]] = i;
        }

        /*
            1.如果 x 和 y 都出现在哈希表中，那么比较它们对应的 rank 值
            2.如果 x 和 y 都没有出现在哈希表中，那么比较它们本身
            3.对于剩余的情况，出现在哈希表中的那个元素较小，排在前边
        */
        sort(arr1.begin(), arr1.end(), [&](int x, int y) {
            if (rank.count(x)) {
                return rank.count(y) ? rank[x] < rank[y] : true;
            } else {
                return rank.count(y) ? false : x < y;
            }
        });
        return arr1;
    }
};

```

```

// C++
// 2. 计数排序

class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        // 计算最大值，优化 frequency 空间
        int upper = *max_element(arr1.begin(), arr1.end());
        // 记录各个值的频次
        vector<int> frequency(upper+1);
        for (int x : arr1) {
            ++frequency[x];
        }
        // 将 arr2 中的值根据频次插入到结果
        vector<int> ans;
        for (int x : arr2) {
            for (int i = 0; i < frequency[x]; i++) {
                ans.push_back(x);
            }
            frequency[x] = 0;
        }
        // 将不在 arr2 中的值根据频次插入到结果
        for (int x = 0; x <= upper; ++x) {
            for (int i = 0; i < frequency[x]; i++) {
                ans.push_back(x);
            }
        }
        return ans;
    }
};

```


## 3.合并区间（Leetcode 56）

```

// C++
// 排序

class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {
        if (intervals.size() == 0) {
            return {};
        }
        // 按照区间的左端点排序
        sort(intervals.begin(), intervals.end(), [&](vector<int> x, vector<int> y) {
            return x[0] < y[0];
        });
        vector<vector<int>> merged;
        for (int i = 0; i < intervals.size(); ++i) {
            int l = intervals[i][0];
            int r = intervals[i][1];
            if (!merged.size() || merged.back()[1] < l) {           // 当前区间的左端点在 merged 中最后一个区间的右端点之后
                merged.push_back({l, r});       
            } else {
                merged.back()[1] = max(merged.back()[1], r);        // 合并，取右端点较大值
            }
        }
        return merged;
    }
};

```

## 4.翻转对（Leetcode 493）


```
// C++
// 归并排序

class Solution {
public:
    int reversePairs(vector<int>& nums) {
        if (nums.size() == 0) return 0;
        return reversePairsRecursive(nums, 0, nums.size() - 1);
    }

private:
    int reversePairsRecursive(vector<int>& nums, int left, int right) {
        if (left == right) {
            return 0;
        } 
        int mid = (left+right) / 2;
        int n1 = reversePairsRecursive(nums, left, mid);
        int n2 = reversePairsRecursive(nums, mid+1, right);
        int count = n1 + n2;

        // 统计下标对的数量
        int i = left, j = mid + 1;
        while (i <= mid) {
            while (j<=right && (long long)nums[i]>2*(long long)nums[j]) { 
                j++;
            }
            count += (j-mid-1);
            i++;
        }

        // 合并已排序数组
        vector<int> sorted(right-left+1);
        int p1 = left, p2 = mid + 1, p = 0;
        while (p1<=mid && p2<=right) {
            (nums[p1] < nums[p2]) ? sorted[p++] = nums[p1++] : sorted[p++] = nums[p2++];
        }
        while (p1 <= mid) sorted[p++] = nums[p1++];
        while (p2 <= right) sorted[p++] = nums[p2++];

        for (int i = 0, sortedSize = sorted.size(); i < sortedSize; i++) {
            nums[left + i] = sorted[i];
        }
        return count;
    }
};

```


## 5.买卖股票的最佳时机（Leetcode 121）

```

// C++

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int minPrice = 10000, maxProfit = 0;
        for (int price : prices) {
            maxProfit = max(maxProfit, price-minPrice);     // 当前价格减去历史最低价格后更新最大收益
            minPrice = min(price, minPrice);                // 记录历史最低价格
        }
        return maxProfit;
    }
};

```

## 6.买卖股票的最佳时机 II（Leetcode 122）

```
// C
// 1.贪心

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

```
// C++
// 2.DP（股票 6 道通用解法）

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        /*
            因为这里 k 可以看作正无穷大，所以 k 和 k - 1 可以看成是相同的，可得到如下状态转移方程：
                dp[i][k][1] = max(dp[i-1][k][1], dp[i-1][k-1][0]-prices[i]) = max(dp[i-1][k][1], dp[i-1][k][0]-prices[i])
                dp[i][k][0] = max(dp[i-1][k][0], dp[i-1][k][1]+prices[i])
            
            去除 k 项可简化为：
                dp[i][1] = max(dp[i-1][1], dp[i-1][0]-prices[i])
                dp[i][0] = max(dp[i-1][0], dp[i-1][1]+prices[i])
        */
        int size = prices.size();
        if (size == 0) return 0;
        vector<vector<int>> dp(size, vector<int>(2, 0));
        dp[0][1] = -prices[0];
        for(int i = 1; i < size; i++) {
            dp[i][1] = max(dp[i-1][1], dp[i-1][0]-prices[i]);
            dp[i][0] = max(dp[i-1][0], dp[i-1][1]+prices[i]);
        }
        return dp[size-1][0];
    }
};

```

## 7.买卖股票的最佳时机 III（Leetcode 123）

```
// C++
// 1.DP

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        /*
            一、DP 数组以及下标的含义
                一天有五个状态：
                    0.没有操作
                    1.第一次买入
                    2.第一次卖出
                    3.第二次买入
                    4.第二次卖出
                dp[i][j]: 表示第 i 天状态 j 获取的最大利润（i 为第 i 天，j 为 [0,4] 五个状态）

            二、DP 方程
                dp[i][1] 表示的是第 i 天买入股票的状态，并不是说一定要第 i 天买入股票，也可能是之前某天买的股票
                
                达到 dp[i][1] (第 i 天处在第一次买入状态)，有两个具体操作：
                    操作一：第 i 天买入股票，那么dp[i][1] = dp[i-1][0] - prices[i]
                    操作二：第 i 天没有操作，而是沿用前一天买入的状态，即：dp[i][1] = dp[i-1][1]
                取较大值，所以 dp[i][1] = max(dp[i-1][0] - prices[i], dp[i-1][1])

                达到 dp[i][2] (第 i 天处在第一次卖出状态)，也有两个操作：
                    操作一：第 i 天卖出股票，那么dp[i][2] = dp[i - 1][1] + prices[i]
                    操作二：第 i 天没有操作，沿用前一天卖出股票的状态，即：dp[i][2] = dp[i-1][2]
                取较大值，所以 dp[i][2] = max(dp[i-1][1] + prices[i], dp[i-1][2])

                同理可推出剩下状态部分：
                    dp[i][3] = max(dp[i-1][3], dp[i-1][2] - prices[i]);
                    dp[i][4] = max(dp[i-1][4], dp[i-1][3] + prices[i]);

            三、初始状态
                初始拥有现金为 0 即可
                第 0 天无操作，dp[0][0] = 0;
                第 0 天第一次买入的操作，dp[0][1] = 0-prices[0];
                第 0 天第一次卖出的操作，dp[0][2] = 0;（第 0 天不可能卖，之前也不可能存在买）
                第 0 天第二次买入的操作，dp[0][3] = 0-prices[0];（存在买就减去即可）
                第 0 天第二次卖出的操作，dp[0][4] = 0;（第 0 天不可能卖，跟不用说第二次卖，之前也不可能存在买）
        */


        if (prices.size() == 0) return 0;
        vector<vector<int>> dp(prices.size(), vector<int>(5, 0));
        dp[0][1] = -prices[0];
        dp[0][3] = -prices[0];
        for (int i = 1; i < prices.size(); i++) {
            dp[i][0] = dp[i - 1][0];
            dp[i][1] = max(dp[i - 1][1], dp[i - 1][0] - prices[i]);
            dp[i][2] = max(dp[i - 1][2], dp[i - 1][1] + prices[i]);
            dp[i][3] = max(dp[i - 1][3], dp[i - 1][2] - prices[i]);
            dp[i][4] = max(dp[i - 1][4], dp[i - 1][3] + prices[i]);
        }
        return dp[prices.size() - 1][4];
    }
};

```

```
// C++
// 2.DP 空间优化

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if (prices.size() == 0) return 0;
        vector<int> dp(5, 0);
        dp[1] = -prices[0];
        dp[3] = -prices[0];
        for (int i = 1; i < prices.size(); i++) {
            dp[1] = max(dp[1], dp[0]-prices[i]);
            dp[2] = max(dp[2], dp[1]+prices[i]);
            dp[3] = max(dp[3], dp[2]-prices[i]);
            dp[4] = max(dp[4], dp[3]+prices[i]);
        }
        return dp[4];
    }
};

```

```
// C++
// 3.DP（股票 6 道通用解法）

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int size = prices.size();
        if (size == 0) return 0;
        int k = 2;
        vector<vector<vector<int>>> dp(size, vector<vector<int>>(k+1, vector<int>(2, 0)));
        // 初始化
        for (int i = 1; i <= k; i++) {
            dp[0][i][1] = -prices[0];
        }
        for (int i = 1; i < size; i++) {
            for (int j = 1; j <= k; j++) {
                dp[i][j][1] = max(dp[i-1][j][1], dp[i-1][j-1][0]-prices[i]);
                dp[i][j][0] = max(dp[i-1][j][0], dp[i-1][j][1]+prices[i]); 
            }
        }
        return dp[size-1][k][0];
    }
};

```

```
// C++
// 4.DP 空间优化（股票 6 道通用解法）

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int size = prices.size();
        if (size == 0) return 0;
        int k = 2;
        vector<vector<int>> dp(k+1, vector<int>(2, 0));
        // 初始化
        for (int i = 1; i <= k; i++) {
            dp[i][1] = -prices[0];
        }
        for (int i = 1; i < size; i++) {
            for (int j = 1; j <= k; j++) {
                dp[j][1] = max(dp[j][1], dp[j-1][0]-prices[i]);
                dp[j][0] = max(dp[j][0], dp[j][1]+prices[i]); 
            }
        }
        return dp[k][0];
    }
};

```


## 8.买卖股票的最佳时机 IV（Leetcode 188）


```
// C++
// 1.DP（股票 6 道通用解法）

class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        /*
            一、DP 数组以及下标的含义
                
                一天有五个状态：
                    0.没有操作
                    1.买入
                    2.卖出

                一次交易包含：买->卖

                用户只能持有 0 份或 1 分股票且为全额购买
                dp[i][k][c]：i 表示天数；k 表示交易次数； c 表示持有 c 份股票，值为 [0,1]
                dp[i][k][0]：表示第 i 天结束，最多进行 k 次交易持有 0 份股票(已卖出)的情况下获得的最大收益
                dp[i][k][1]：表示第 i 天结束，最多进行 k 次交易持有 1 份股票(已买入)的情况下获得的最大收益
            
            二、DP 方程

                因为每次交易包含两次成对的操作，买入和卖出。只有买入操作会改变允许的最大交易次数

                对于 dp[i][k][1]，第 i 天进行的操作只能是休息(之前买过))或买入
                对于 dp[i][k][0]，第 i 天进行的操作只能是休息(之前卖过)或卖出

                dp[i][j][1] = max(dp[i-1][j][1], dp[i-1][j-1][0]-prices[i]);    // 持有 1 份(买过) 
                dp[i][j][0] = max(dp[i-1][j][0], dp[i-1][j][1]+prices[i]);      // 持有 0 份(已卖) 
        */
        int size = prices.size();
        if (size == 0) return 0;
        vector<vector<vector<int>>> dp(size, vector<vector<int>>(k+1, vector<int>(2, 0)));
        // 初始化
        for (int i = 1; i <= k; i++) {
            dp[0][i][1] = -prices[0];               // 买入一定要减去价格，第 0 天不存在卖
        }
        for (int i = 1; i < size; i++) {
            for (int j = 1; j <= k; j++) {
                dp[i][j][1] = max(dp[i-1][j][1], dp[i-1][j-1][0]-prices[i]);
                dp[i][j][0] = max(dp[i-1][j][0], dp[i-1][j][1]+prices[i]); 
            }
        }
        return dp[size-1][k][0];
    }
};

```

```
// C++
// 2.DP 空间优化（股票 6 道通用解法）

class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        int size = prices.size();
        if (size == 0) return 0;
        vector<vector<int>> dp(k+1, vector<int>(2, 0));
        // 初始化
        for (int i = 1; i <= k; i++) {
            dp[i][1] = -prices[0];               // 买入一定要减去价格，第 0 天不存在卖
        }
        for (int i = 1; i < size; i++) {
            for (int j = 1; j <= k; j++) {
                dp[j][1] = max(dp[j][1], dp[j-1][0]-prices[i]);
                dp[j][0] = max(dp[j][0], dp[j][1]+prices[i]); 
            }
        }
        return dp[k][0];
    }
};

```

## 9.最佳买卖股票时机含冷冻期（Leetcode 309）


```
// C++
// 1.DP

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        /*
            一、DP 数组以及下标的含义
                每天有三种状态
                    1.买入
                    2.卖出 （当天卖出，第二天处于冷冻期）
                    3.卖出 （之前某天卖出，第二天不处于冷冻期）
                dp[i][j]: 表示第 i 天状态 j 获取的最大利润（i 为第 i 天，j 为 [0,2] 表示三种状态）

            二、DP 方程
                dp[i][0] = max(dp[i-1][0], dp[i-1][2]-price[i]);
                dp[i][1] = dp[i-1][0] + prices[i];
                dp[i][2] = max(dp[i-1][1], dp[i-1][2]);

            三、初始状态
                dp[0][0] = -price[i];
                dp[0][1] = 0;
                dp[0][2] = 0;

        */
        int size = prices.size();
        if (size == 0) return 0;
        vector<vector<int>>dp (size, vector<int>(3, 0));
        dp[0][0] = -prices[0];
        for(int i = 1; i < size ; i++){
            dp[i][0] = max(dp[i-1][0], dp[i-1][2]-prices[i]);
            dp[i][1] = dp[i-1][0] + prices[i];          //当天卖出，第 i+1 天处于冷冻期
            dp[i][2] = max(dp[i-1][1], dp[i-1][2]);     //之前某天卖出，第 i+1 天不处于冷冻期
        }
        return max(dp[size-1][0],max(dp[size-1][1],dp[size-1][2]));
    }
};

```

```
// C++
// 2.DP 空间优化

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int size = prices.size();
        if (size == 0) return 0;
        vector<int>dp(3, 0);
        dp[0] = -prices[0];
        for(int i = 1; i < size ; i++){
            vector<int>newDp(3, 0);
            newDp[0] = max(dp[0], dp[2]-prices[i]);
            newDp[1] = dp[0] + prices[i];    
            newDp[2] = max(dp[1], dp[2]);   
            dp = newDp;  
        }
        return max(dp[0],max(dp[1],dp[2]));
    }
};

```

## 10.买卖股票的最佳时机含手续费（Leetcode 714）

```
// C++
// 1.DP

class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        /*
            每天有二种状态
                1.买入
                2.卖出
            dp[i][j]: 表示第 i 天状态 j 获取的最大利润（i 为第 i 天，j 为 0 表示买入状态，j 为 1 表示卖出状态）

            DP 方程
                dp[i][0] = max(dp[i-1][0], dp[i-1][1]-prices[i]);           
                dp[i][1] = max(dp[i-1][1], dp[i-1][0]+prices[i]-fee);       

        */
        int size = prices.size();
        if (size == 0) return 0;
        vector<vector<int>> dp(size, vector<int>(2, 0));
        dp[0][0] = -prices[0];
        for (int i = 1; i < size; ++i) {
            dp[i][0] = max(dp[i-1][0], dp[i-1][1]-prices[i]);           // 处于买入状态
            dp[i][1] = max(dp[i-1][1], dp[i-1][0]+prices[i]-fee);       // 处于卖出状态
        }
        return dp[size-1][1];
    }
};

```

```
// C++
// 2.DP 空间优化

class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        int size = prices.size();
        if (size == 0) return 0;
        vector<int> dp(2, 0);
        dp[0] = -prices[0];
        for (int i = 1; i < size; ++i) {
            vector<int> newDp(2, 0);
            newDp[0] = max(dp[0], dp[1]-prices[i]);      
            newDp[1] = max(dp[1], dp[0]+prices[i]-fee);  
            dp = newDp;
        }
        return dp[1];
    }
};

```

```

// C++
// 3.贪心

class Solution {
public:
    int maxProfit(vector<int>& prices, int fee) {
        /*
            将手续费放在买入时进行计算，可得到一种基于贪心的方法
        
                1.如果当前的股票价格 prices[i] 加上手续费 fee 小于 buy，我们以 prices[i]+fee 的价格购买股票，
            因此 buy 更新为 prices[i]+fee

                2.如果当前的股票价格 prices[i] 大于 buy，那么我们直接卖出股票并且获得 prices[i]−buy 的收益。
            但实际上，我们此时卖出股票可能并不是全局最优的（例如下一天股票价格继续上升），因此我们可以提供一个反悔操
            作，看成当前手上拥有一支买入价格为 prices[i] 的股票，将 buy 更新为 prices[i]。这样一来，如果下一天
            股票价格继续上升，会获得 prices[i+1]−prices[i] 的收益，加上 prices[i]−buy 的收益，恰好就等于在这
            一天不进行任何操作，而在下一天卖出股票的收益

                3.对于其余的情况，prices[i] 落在区间 [buy−fee,buy] 内，它的价格没有低到我们放弃手上的股票去选
            择它，也没有高到我们可以通过卖出获得收益，因此我们不进行任何操作
        */

        int size = prices.size();
        if (size == 0) return 0;
        int buy = prices[0] + fee;
        int profit = 0;
        for (int i = 1; i < size; ++i) {
            if (prices[i]+fee < buy) {
                buy = prices[i] + fee;
            } else if (prices[i] > buy) {
                profit += prices[i] - buy;
                buy = prices[i];
            }
        }
        return profit;
    }
};

```
