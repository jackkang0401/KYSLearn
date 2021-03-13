# Code_5


## 1.验证回文字符串 Ⅱ（Leetcode 680）

```

// C++
// 贪心

class Solution {
public:
    bool validPalindrome(string s) {
        int low = 0, high = s.size() - 1;
        while (low < high) {
            char c1 = s[low], c2 = s[high];
            if (c1 == c2) {
                ++low;
                --high;
            } else {
                return checkPalindrome(s, low, high - 1) || checkPalindrome(s, low + 1, high);
            }
        }
        return true;
    }

private:
    bool checkPalindrome(const string &s, int low, int high) {
        for (int i = low, j = high; i < j; ++i, --j) {
            if (s[i] != s[j]) {
                return false;
            }
        }
        return true;
    }
};

```


## 2.有效的字母异位词（Leetcode 242）


```

// C++
// hash 表（也可排序比较，耗时较长）

class Solution {
public:
    bool isAnagram(string s, string t) {
        if (s.length() != t.length()) return false;
        vector<int> hashTable(26, 0);
        for (auto &c : s) {
            hashTable[c-'a'] ++;
        }
        for (auto &c : t) {
            hashTable[c-'a'] --;
            if (hashTable[c-'a'] < 0) return false;
        }
        return true;
    }
};

```

## 3.字母异位词分组（Leetcode 49）


```

// C++
// hash 表

class Solution {
public:
    vector<vector<string>> groupAnagrams(vector<string>& strs) {
        unordered_map<string, vector<string>> resultMap;
        for (string s : strs) {
            vector<int> hashTable(26, 0);
            int length = s.length();
            for (auto &c : s) {
                hashTable[c-'a'] ++;
            }
            string key = "key_";
            for (int i = 0; i < 26; i++) {
                if (hashTable[i] > 0) {
                    key += ('a'+i);
                    key += to_string(hashTable[i]);
                }
            }
            resultMap[key].push_back(s);
        }
        vector<vector<string>> result;
        for (unordered_map<string, vector<string>>::iterator it = resultMap.begin(); it != resultMap.end(); it++ ) {
            result.push_back(it->second);
        }
        return result;
    }
};


```


## 4.找到字符串中所有字母异位词（Leetcode 438）


```

// C++
// 1. 滑动窗口+数组

class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        int n = s.length(), m = p.length();
        vector<int> result;
        if (n < m) return result;
        vector<int> sHashTable(26, 0);
        vector<int> pHashTable(26, 0);
        for (int i = 0; i < m; i++ ) {
            sHashTable[s[i]-'a'] ++;
            pHashTable[p[i]-'a'] ++;
        }
        if (pHashTable == sHashTable) result.push_back(0);
        for (int i = m; i < n; i++) {
            sHashTable[s[i-m]-'a'] --;
            sHashTable[s[i]-'a'] ++;
            if (pHashTable == sHashTable) result.push_back(i-m+1);
        }
        return result;
    }
};


```


```

// C++
// 2. 滑动窗口+双指针

class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        int n = s.length(), m = p.length();
        vector<int> result;
        if (n < m) return result;

        vector<int> pHashTable(26, 0);
        for (int i = 0; i < m; i++ ) {
            pHashTable[p[i]-'a'] ++;
        }
        
        vector<int> sHashTable(26, 0);
        int left = 0;
        for (int right = 0; right < n; right++) {
            int curRight = s[right] - 'a';
            sHashTable[curRight] ++;
            while(sHashTable[curRight] > pHashTable[curRight]) {
                int curLeft = s[left] - 'a';
                sHashTable[curLeft] --;
                left ++;
            }
            if (right-left+1 == m) result.push_back(left);
        }
        return result;
    }
};



```



## 5.仅仅反转字母（Leetcode 917）


```

// C++
// 1. 双指针

class Solution {
public:
    string reverseOnlyLetters(string S) {
        int begin = 0, end = S.length()-1;
        while(begin < end) {
            if(false == isalpha(S[begin])) {
                begin++;
            }
            if(false == isalpha(S[end])) { 
                end--;
            }
            if(isalpha(S[begin]) && isalpha(S[end])) {
                swap(S[begin++], S[end--]);
            }
        }
        return S;
    }
};


```

```
// C++
// 2. 栈

class Solution {
public:
    string reverseOnlyLetters(string S) {
        stack<char> strStack;
        for (auto &c : S) {
            if (isalpha(c)) strStack.push(c);
        } 

        string result = string();
        for (auto &c : S) {
            if (isalpha(c)) {
                char cur = strStack.top();
                result += cur;
                strStack.pop();
            } else {
                result += c;
            }
        } 
        return result;
    }
};

```


## 6.翻转字符串里的单词（Leetcode 151）


```

// C++

class Solution {
public:
    string reverseWords(string s) {
        reverse(s.begin(), s.end());                                // 反转整个字符串
        int n = s.size();
        int idx = 0;
        for (int start = 0; start < n; ++start) {
            if (s[start] != ' ') {
                if (idx != 0) s[idx++] = ' ';                       // 填一个空白字符后，将 idx 移动到下一个单词的开头
                int end = start;        
                while (end < n && s[end] != ' ') {                  // 循环遍历至当前单词的末尾
                    s[idx++] = s[end++];                            // 向前移动单词            
                }
                reverse(s.begin()+idx-(end-start), s.begin()+idx);  // 反转整个单词
                start = end;                                        // 更新 start 向后移动，去找下一个单词
            }
        }
        s.erase(s.begin()+idx, s.end());                            // 删除后边的字符
        return s;
    }
};


```


## 7.最长公共前缀（Leetcode 14）


```

// C++
// 纵向扫描

class Solution {
public:
    string longestCommonPrefix(vector<string>& strs) {
        if (!strs.size()) {
            return "";
        }
        int length = strs[0].size();                                // 第一个字符长度
        int count = strs.size();
        for (int i = 0; i < length; ++i) {
            char c = strs[0][i];
            for (int j = 1; j < count; ++j) {
                if (i == strs[j].size() || strs[j][i] != c) {       // 超出当前字符串长度或当前位置字符不等
                    return strs[0].substr(0, i);
                }
            }
        }
        return strs[0];                                             // 第一个字符串最短
    }
};


```


## 8.字符串转换整数 (atoi)（Leetcode 8）


```

// C++
// 自动机

class Automaton {
public:
    int sign = 1;
    long ans = 0;

    string get(char c) {
        state = table[state][get_col(c)];
        if (state == "in_number") {
            ans = ans*10 + c-'0';
            ans = sign == 1 ? min(ans, (long)INT_MAX) : min(ans, -(long)INT_MIN);
        } else if (state == "signed") {
            sign = c == '+' ? 1 : -1;
        }
        return state;
    }

private:
    // 定义状态
    string state = "start";
    unordered_map<string, vector<string>> table = {
        {
            "start", {"start", "signed", "in_number", "end"}
        },
        {
            "signed", {"end", "end", "in_number", "end"}
        },
        {
            "in_number", {"end", "end", "in_number", "end"}
        },
        {
            "end", {"end", "end", "end", "end"}
        }
    };

    // 获取对应状态下标
    int get_col(char c) {
        if (isspace(c)) {
            return 0;               // 空格
        }
        if (c == '+' or c == '-') { 
            return 1;               // 符号
        }
        if (isdigit(c)) {
            return 2;               // 数字
        }
        return 3;                   // 其他
    }
};

class Solution {
public:
    int myAtoi(string s) {
        Automaton automaton;
        for (char c : s) {
          string state = automaton.get(c);
          if (state == "end") break;
        }
        return automaton.sign * automaton.ans;
    }
};


```


## 9.字符串中的第一个唯一字符（Leetcode 387）


```

// C++
// 1. 哈希表-存储频数

class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<char, int> frequencyMap;
        for (char ch: s) {
            frequencyMap[ch] ++;
        }
        for (int i = 0, size = s.size(); i < size; ++i) {
            if (frequencyMap[s[i]] == 1) {
                return i;
            }
        }
        return -1;
    }
};

```

```
// C++
// 2. 哈希表-存储索引

class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<char, int> positionMap;
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (positionMap.count(s[i])) {
                positionMap[s[i]] = -1;
            } else {
                positionMap[s[i]] = i;
            }
        }
        int first = n;
        for (auto [_, pos]: positionMap) {
            if (pos == -1) continue;
            first = min(pos, first);
        }
        if (first == n) {
            return -1;
        }
        return first;
    }
};

```

```
// C++
// 3. 哈希表-存储索引 + 队列

class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<char, int> positionMap;
        queue<pair<char, int>> q;
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (0 == positionMap.count(s[i])) {
                positionMap[s[i]] = i;          // 标记为只出现一次（存放索引）
                q.emplace(s[i], i);             // 字符未出现过，将字符与索引作为一个二元组放入队尾
            } else {
                positionMap[s[i]] = -1;         // 标记为出现多次
                while (!q.empty() && positionMap[q.front().first] == -1) {
                    q.pop();                    // 队列头部元素不是只出现一次（值为 -1），弹出队列
                }
            }
        }
        return q.empty() ? -1 : q.front().second;
    }
};

```


## 10.最后一个单词的长度（Leetcode 58）


```
// C++

class Solution {
public:
    int lengthOfLastWord(string s) {
        int lastLength = 0;
        int currentLength = 0;
        for (auto c : s) {
            if (' ' == c) {
                if (currentLength != 0 ) {
                    lastLength = currentLength; // 记录上一个单词的长度，处理末尾全是空格问题
                }
                currentLength = 0;
            } else {
                currentLength ++;
            }
        }
        // 如果当前单词长度大于 0，去当前单词长度，否则，取上一个单词长度
        return currentLength > 0 ? currentLength : lastLength; 
    }
};

```

## 11.最长有效括号（Leetcode 32）


```
// C++
// 1. DP

class Solution {
public:
    int longestValidParentheses(string s) {
        /*
            dp[i]：表示以下标 i 字符结尾的最长有效括号的长度
        */
        int maxLength = 0, n = s.length();
        vector<int> dp(n, 0);
        for (int i = 1; i < n; i++) {
            if (s[i] == ')') {
                if (s[i - 1] == '(') {
                    dp[i] = (i-2 >= 0 ? dp[i-2] : 0) + 2;
                } else if (i-dp[i-1] > 0 && s[i-dp[i-1]-1] == '(') {
                    dp[i] = dp[i-1] + ((i-dp[i-1]-2) >= 0 ? dp[i-dp[i-1]-2] : 0) + 2;
                }
                maxLength = max(maxLength, dp[i]);
            }
        }
        return maxLength;
    }
};

```

```
// C++
// 2. 栈

class Solution {
public:
    int longestValidParentheses(string s) {
        int maxLength = 0;
        stack<int> stk;
        stk.push(-1);                       // 放入一个值为 -1 的元素，初始化「最后一个没有被匹配的右括号的下标」
        for (int i = 0, length = s.length(); i < length; i++) {
            if (s[i] == '(') {
                stk.push(i);
            } else {
                stk.pop();
                if (stk.empty()) {
                    stk.push(i);            // 当前的右括号为没有被匹配的右括号，更新「最后一个没有被匹配的右括号的下标」
                } else {
                    maxLength = max(maxLength, i-stk.top());
                }
            }
        }
        return maxLength;
    }
};

```

```
// C++
// 3. 遍历

class Solution {
public:
    int longestValidParentheses(string s) {
        int left = 0, right = 0, maxlength = 0;
        int length = s.length();
        // 从左往右遍历
        for (int i = 0; i < length; i++) {
            if (s[i] == '(') {
                left++;
            } else {
                right++;
            }
            if (left == right) {
                maxlength = max(maxlength, 2 * right);  // 计算并更新当前有效字符串的长度
            } else if (right > left) {
                left = right = 0;                       // 计数置 0
            }
        }
        // 处理 "(()" 情况（left 一直大于 right），从右往左遍历，判断条件反过来即可
        left = right = 0;
        for (int i = length-1; i >= 0; i--) {
            if (s[i] == '(') {
                left++;
            } else {
                right++;
            }
            if (left == right) {
                maxlength = max(maxlength, 2 * left);
            } else if (left > right) {
                left = right = 0;
            }
        }
        return maxlength;
    }
};

```


## 12.赛车（Leetcode 818）

```

// C++
// 1. DP

class Solution {
public:
    int racecar(int target) {
        /*
            dp[i]：走距离 i 需要的最小步数
        */
        if (target <= 0) return 0;
        vector<int> dp(target+1, INT_MAX);
        dp[0] = 0;
        for (int i = 1; i <= target; i++) {
            for (int k = 1; (1<<k)-1 < 2*i; k++) {          // 向前走 k 个 A 指令
                int s = (1<<k) - 1;                         // k 个 A 指令到达位置
                if (s == i) {                               // 可直接到达
                    dp[i] = k;
                } else if (s > i) {                         // 越过 i: 往回走
                    dp[i] = min(dp[i], k + 1 + dp[s-i]);    // +1 代表 R
                } else {                                    // 没越过 i: 往回走，再往前走
                    for (int back = 0; back < k; back++) {
                        int distabce = i - s + (1<<back)-1;
                        dp[i] = min(dp[i], k + 1 + back + 1 + dp[distabce]);
                    }
                }
            }
        }
        return dp[target];
    }
};

```

```

// C++
// 2. DP 记录 k 个 A 指令到达位置（省去一个往上迭代 k 个 A 指令到达的位置）

class Solution {
public:
    int racecar(int target) {
        /*
            dp[i]：走距离 i 需要的最小步数
        */
        if (target <= 0) return 0;
        vector<int> dp(target+2, INT_MAX);
        dp[0] = 0; dp[1] = 1; dp[2] = 4;
        int k = 2;                                          // 记录 A 指令个数
        int s = (1<<k) - 1;                                 // 记录 k 个 A 指令到达的位置 s
        for (int i = 3; i <= target; i++) {
            if (i == s) {
                dp[i] = k++;                                // k 后移（增加一条 A 指令）         
                s = (1<<k) - 1;
            } else {
                // 1.越过 i: 前进 k 个 -> 回退
                dp[i] = k + 1 + dp[s-i];                    // 此时 k 个指令 A 对应移动距离 s 越过 i 

                // 2.未越过 i: 前进 k-1 个 -> 回退 -> 回退 back 个 -> 前进
                for (int back = 0; back < (k-1); back++) {  // k-1 个指令 A 一定没越过 i
                    int distance = i + ((1<<back)-1) - ((1<<(k-1))-1);
                    dp[i] = min(dp[i], (k-1)+1+back+1+dp[distance]);
                }
            }
        }
        return dp[target];
    }
};

```



## 13.柱状图中最大的矩形（Leetcode 84）

```

// C++
// 1. 暴力 + 全部遍历（超时）

class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int n = heights.size();
        int result = 0;
        for (int left = 0; left < n; ++left) {              // 左边界
            int minHeight = INT_MAX;
            for (int right = left; right < n; ++right) {    // 右边界
                minHeight = min(minHeight, heights[right]);
                result = max(result, (right-left+1) * minHeight);
            }
        }
        return result;
    }
};

```


```

// C++
// 2. 暴力 + 确定上下边界（超时）

class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        /*
              我们可以使用一重循环枚举某一根柱子，将其固定为矩形的高度 height。
            随后我们从这跟柱子开始向两侧延伸，直到遇到高度小于 height 的柱子，
            就确定了矩形的左右边界，便可计算出当前面积
        */
        int n = heights.size();
        int result = 0;
        for (int mid = 0; mid < n; ++mid) {
            int height = heights[mid];                          // 固定高
            int left = mid, right = mid;
            while (left-1 >= 0 && heights[left-1] >= height) {  // 确定左边界
                --left;
            }
            while (right+1 < n && heights[right+1] >= height) { // 确定右边界
                ++right;
            }
            result = max(result, (right-left+1) * height);        // 计算面积
        }
        return result;
    }
};

```


```

// C++
// 3. 单调栈

class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int n = heights.size();
        vector<int> left(n), right(n);
        // 确定左边界
        stack<int> leftStack;           // 单调递减栈
        for (int i = 0; i < n; ++i) {
            while (!leftStack.empty() && heights[leftStack.top()] >= heights[i]) {
                leftStack.pop();
            }
            left[i] = (leftStack.empty() ? -1 : leftStack.top());
            leftStack.push(i);
        }
        // 确定右边界
        stack<int> rightStack;          // 单调递减栈
        for (int i = n - 1; i >= 0; --i) {
            while (!rightStack.empty() && heights[rightStack.top()] >= heights[i]) {
                rightStack.pop();
            }
            right[i] = (rightStack.empty() ? n : rightStack.top());
            rightStack.push(i);
        }
        // 计算最大面积
        int result = 0;
        for (int i = 0; i < n; ++i) {
            result = max(result, (right[i]-left[i]-1) * heights[i]);
        }
        return result;
    }
};

```

```

// C++
// 4. 单调栈 + 常数优化

class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int n = heights.size();
        vector<int> left(n), right(n, n);
        // 确定左右边界
        stack<int> leftStack;               // 单调递减栈
        for (int i = 0; i < n; ++i) {
            while (!leftStack.empty() && heights[leftStack.top()] >= heights[i]) {
                right[leftStack.top()] = i;
                leftStack.pop();
            }
            left[i] = (leftStack.empty() ? -1 : leftStack.top());
            leftStack.push(i);
        }
        // 计算最大面积
        int result = 0;
        for (int i = 0; i < n; ++i) {
            result = max(result, (right[i]-left[i]-1) * heights[i]);
        }
        return result;
    }
};

```


## 14.最大矩形（Leetcode 85）

```

// C++
// 1. 柱状图 + 全部遍历

class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        if (n == 0) {
            return 0;
        }
        int m = matrix[0].size();

        // 计算出矩阵的每个元素的左边连续 1 的数量
        vector<vector<int>> left(n, vector<int>(m, 0));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j-1]) + 1;
                }
            }
        }

        // 将输入转化成了一系列的柱状图(每一列为一个柱状图)，计算每个柱状图最大面积           
        int result = 0;
        for (int j = 0; j < m; j++) {               // 对于每一列，使用基于柱状图的算法
            for (int i = 0; i < n; i++) {           // 下边界
                if (matrix[i][j] == '0') {
                    continue;
                }
                // 枚举以该点为右下角的全 1 矩形
                int width = left[i][j];
                int area = width;
                for (int k = i - 1; k >= 0; k--) {  // 上边界
                    width = min(width, left[k][j]);
                    area = max(area, (i-k+1) * width);
                }
                result = max(result, area);
            }
        }
        return result;
    }
};

```


```

// C++
// 2. 柱状图 + 确定上下边界

class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        if (n == 0) {
            return 0;
        }
        int m = matrix[0].size();

        // 计算出矩阵的每个元素的左边连续 1 的数量
        vector<vector<int>> left(n, vector<int>(m, 0));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j-1]) + 1;
                }
            }
        }

        // 将输入转化成了一系列的柱状图(每一列为一个柱状图)，计算每个柱状图最大面积          
        int result = 0;
        for (int j = 0; j < m; j++) {               // 对于每一列，使用基于柱状图的算法
            for (int mid = 0; mid < n; mid++) {
                if (matrix[mid][j] == '0') {
                    continue;
                }
                // 枚举以该点为右下角的全 1 矩形
                int width = left[mid][j];
                int top = mid, bottom = mid;
                while (top-1 >= 0 && left[top-1][j] >= width) {     // 确定上边界
                    --top;
                }
                while (bottom+1 < n && left[bottom+1][j] >= width) {// 确定下边界
                    ++bottom;
                }
                result = max(result, (bottom-top+1)*width);
            }
        }
        return result;
    }
};

```

```

// C++
// 2. 柱状图 + 单调栈

class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        if (n == 0) {
            return 0;
        }
        int m = matrix[0].size();

        // 计算出矩阵的每个元素的左边连续 1 的数量
        vector<vector<int>> left(n, vector<int>(m, 0));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j-1]) + 1;
                }
            }
        }

        // 将输入转化成了一系列的柱状图(每一列为一个柱状图)，计算每个柱状图最大面积
        int result = 0;
        for (int j = 0; j < m; j++) {           // 对于每一列，使用基于柱状图的算法
            vector<int> up(n, 0), down(n, 0);

            // 确定上边界
            stack<int> topStack;
            for (int i = 0; i < n; i++) {
                while (!topStack.empty() && left[topStack.top()][j] >= left[i][j]) {
                    topStack.pop();
                }
                up[i] = topStack.empty() ? -1 : topStack.top();
                topStack.push(i);
            }

            // 确定下边界
            stack<int> bottomStack;
            for (int i = n - 1; i >= 0; i--) {
                while (!bottomStack.empty() && left[bottomStack.top()][j] >= left[i][j]) {
                    bottomStack.pop();
                }
                down[i] = bottomStack.empty() ? n : bottomStack.top();
                bottomStack.push(i);
            }

            // 计算最大面积
            for (int i = 0; i < n; i++) {
                result = max(result, (down[i]-up[i]-1) * left[i][j]);
            }
        }
        return result;
    }
};


```

```

// C++
// 4. 柱状图 + 单调栈 + 常数优化

class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int n = matrix.size();
        if (n == 0) {
            return 0;
        }
        int m = matrix[0].size();

        // 计算出矩阵的每个元素的左边连续 1 的数量
        vector<vector<int>> left(n, vector<int>(m, 0));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (matrix[i][j] == '1') {
                    left[i][j] = (j == 0 ? 0: left[i][j-1]) + 1;
                }
            }
        }

        // 将输入转化成了一系列的柱状图(每一列为一个柱状图)，计算每个柱状图最大面积
        int result = 0;
        for (int j = 0; j < m; j++) {               // 对于每一列，使用基于柱状图的算法
            vector<int> up(n, 0), down(n, n);

            // 确定上下边界
            stack<int> topStack;
            for (int i = 0; i < n; i++) {
                while (!topStack.empty() && left[topStack.top()][j] >= left[i][j]) {
                    down[topStack.top()] = i;
                    topStack.pop();
                }
                up[i] = topStack.empty() ? -1 : topStack.top();
                topStack.push(i);
            }

            // 计算最大面积
            for (int i = 0; i < n; i++) {
                result = max(result, (down[i]-up[i]-1) * left[i][j]);
            }
        }
        return result;
    }
};

```
