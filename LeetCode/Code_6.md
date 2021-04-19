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

