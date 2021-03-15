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

