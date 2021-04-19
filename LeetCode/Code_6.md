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
// 自定义排序规则

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
