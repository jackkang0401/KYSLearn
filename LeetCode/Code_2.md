# Code_2


## 1.解码方法（Leetcode 91）

```
// C++

class Solution {
public:
    int numDecodings(string s) {
        int size = s.size();
        if (0 == size || '0' == s[0]) return 0; // 首位为 0，不可解码
        vector<int> dp(size+1);
        dp[0] = dp[1] = 1;                      // dp[n] 代表 s[0..n-1] 的解码方法总数
        for (int i = 1; i < size; i++) {
            if ('0' == s[i]) {                  // 当前位为 0，上一位必须是 1 或 2 才能解码
                if (!('1' == s[i-1] || '2' == s[i-1])) return 0;
                dp[i+1] = dp[i-1];
            } else if (s[i] <= '6') {
                dp[i+1] = dp[i] + (('1' == s[i-1] || '2' == s[i-1]) ? dp[i-1] : 0);
            } else {
                dp[i+1] = dp[i] + (('1' == s[i-1]) ? dp[i-1] : 0);
            }
        }
        return dp[size];
    }
};

```

## 2.回文子串（Leetcode 647）

```
// C++

// 1.中心扩展法

class Solution {
public:
    int countSubstrings(string s) {
        int length = s.length();
        int total = 0;
        for(int i = 0, count = length*2; i < count; i++){
            // 长度分别为奇数（s[i]）、偶数（中心为空）的回文子串
            int left = i / 2;
            int right = left + i % 2;
            // 向外扩张
            while(left >= 0 && right < length && s[left] == s[right]){
                left--;
                right++;
                total++;
            }
        }
        return total;
    }
};

```

```
// C++
// 2.Manacher

class Solution {
public:
    int countSubstrings(string s) {
        int n = s.size();
        if (n < 2) return n;
        // 插入字符串
        string str = "$#";
        for (char c: s) {
            str += c;
            str += '#';
        }
        str += '!';
        n = str.size() - 1;

        int total = 0;                          // 所有回文子串
        vector<int> radius = vector<int>(n);    // 位置 i 对应的最大回文串半径
        int maxI = 0, maxRight = 0;             // 前 i 个位置对应所有回文串中的最大右端点及位置
        for (int i = 1; i < n; i++) {
            radius[i] = (i <= maxRight) ? min(maxRight-i+1, radius[2*maxI-i]) : 1;
            while (str[i+radius[i]] == str[i-radius[i]]) radius[i]++;       // 继续向外扩张
            int curRight = i+radius[i]-1;                                   // 右端点  
            if (curRight > maxRight) {                                             
                maxI = i;
                maxRight = curRight;
            }
            total += (radius[i] / 2);        // (radius[i] - 1) / 2 上取整
        }
        return total;
    }
};


```

## 3.实现 Trie (前缀树)（Leetcode 208）

```
// C++

class Trie {

private:
    bool isEnd;
    Trie* links[26];
    
public:    
    // 初始化
    Trie() {
        isEnd = false;
        for (int i = 0; i < 26; i++) {
            links[i] = nullptr;
        }
    }

    // 析构
    ~Trie() {
        for (int i = 0; i < 26; i++) {
            if (links[i] == nullptr) continue;
            delete(links[i]);
            links[i] = nullptr;
        }
    }
    
    // 插入单词
    void insert(string word) {
        Trie *node = this;
        for (auto c : word) {
            int i = c - 'a';
            if (node->links[i] == nullptr) node->links[i] = new Trie();
            node = node->links[i];
        }
        node->isEnd = true;
    }
    
    // 查找单词
    bool search(string word) {
        Trie *node = this;
        for (auto c : word) {
            int i = c - 'a';
            if (node->links[i] == nullptr) return false;
            node = node->links[i];
        }
        return node->isEnd;
    }
    
    // 查找前缀
    bool startsWith(string prefix) {
        Trie *node = this;
        for (auto c : prefix) {
            int i = c - 'a';
            if (node->links[i] == nullptr) return false;
            node = node->links[i];
        }
        return true;
    }
};

/**
 * Your Trie object will be instantiated and called as such:
 * Trie* obj = new Trie();
 * obj->insert(word);
 * bool param_2 = obj->search(word);
 * bool param_3 = obj->startsWith(prefix);
 */
 
```

## 4.单词搜索 II（Leetcode 212）

```
class Trie {
private:
    bool isEnd;
    Trie* links[26];

public:
    // 初始化
    Trie() {
        isEnd = false;
        for (int i = 0; i < 26; i++) {
            links[i] = nullptr;
        }
    }

    // 析构
    ~Trie() {
        for (int i = 0; i < 26; i++) {
            if (nullptr == links[i]) continue;
            delete(links[i]);
            links[i] = nullptr;
        }
    }

    // 插入
    void insert(string word) {
        Trie *node = this;
        for (auto c : word) {
            int i = c - 'a';
            if (nullptr == node->links[i]) node->links[i] = new Trie();
            node = node->links[i];
        }
        node->isEnd = true; 
    }

    // 查找
    bool search(string word) {
        Trie *node = this;
        for (auto c : word) {
            int i = c - 'a';
            if (nullptr == node->links[i]) return false;
            node = node->links[i];
        }
        return node->isEnd; 
    }

    // 查找前缀
    bool searchPrefix(string prefix) {
        Trie *node = this;
        for (auto c : prefix) {
            int i = c - 'a';
            if (nullptr == node->links[i]) return false;
            node = node->links[i];
        }
        return true;
    } 

    // 查找 board
    void searchFormBoard(vector<string>& result, vector<vector<char>>& board) {
        for(int i = 0, rowSize = board.size(); i < rowSize; i++) {
            for (int j = 0, colSize = board[i].size(); j < colSize; j++) {
                string word;
                dfs(result, board, this, i, j, word);
            }
        }
    }

    // 遍历 board
    void dfs(vector<string>& result, vector<vector<char>>& board, Trie* node, int i, int j, string& word) {
        if (node->isEnd) {
            node->isEnd = false;
            result.push_back(word);
            return;
        }
        
        if (i < 0 || i >= board.size() || j < 0 || j >= board[i].size()) return;
        char c = board[i][j];
        if ('#' == c || nullptr == node->links[c - 'a']) return; // 1.当前字符已遍历 2.不存在下一个

        node = node->links[c - 'a'];
        word.push_back(c);
        board[i][j] = '#';              // 标记已遍历
        dfs(result, board, node, i+1, j, word);
        dfs(result, board, node, i-1, j, word);
        dfs(result, board, node, i, j+1, word);
        dfs(result, board, node, i, j-1, word);
        board[i][j] = c;
        word.pop_back();                // 恢复
    }
};

class Solution {
public:
    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        Trie trie;
        for (string& w : words) {
            trie.insert(w);
        }
        vector<string> result;
        trie.searchFormBoard(result, board);
        return result;
    }
};

```

## 5.解数独（Leetcode 37）

```
// C++

class Solution {
public:
    void solveSudoku(vector<vector<char>>& board) {
        if (0 == board.size() || 0 == board[0].size()) return;
        solve(board);
    }

private:
    // 递归填充数据（每次递归起点从头开始）
    // 求得一个解需要设有返回值，如果想获得所有解需要在达到最大数时记录结果
    bool solve(vector<vector<char>>& board) {
        for (int i = 0, rowSize = board.size(); i < rowSize; i++) {
            for (int j = 0, colSize = board[i].size(); j < colSize; j++) {
                if ('.' != board[i][j]) continue;
                for (char c = '1'; c <= '9'; c++) {
                    if (isValid(board, i, j, c)) {
                        board[i][j] = c;
                        if (solve(board)) return true;
                        board[i][j] = '.';
                    }
                }
                return false;
            }
        }
        return true;
    }

    // 验证（row, col）位置是否有效
    bool isValid(vector<vector<char>>& board, int row, int col, char c) {
        for (int i = 0; i < 9; i++) {
            if (board[i][col] != '.' && board[i][col] == c) return false;
            if (board[row][i] != '.' && board[row][i] == c) return false;
            int boxI = 3*(row/3) + i/3;
            int boxJ = 3*(col/3) + i%3;
            if (board[boxI][boxJ] != '.' && board[boxI][boxJ] == c) return false;
        }
        return true;
    }
};

```

```
// C++

// 优化：每次递归起点都是下一个

class Solution {
public:
    void solveSudoku(vector<vector<char>>& board) {
        if (0 == board.size() || 0 == board[0].size()) return;
        solve(board, board.size(), 0);
    }

private:
    // 递归填充数据（每次递归起点为下一个）
    // 求得一个解需要设有返回值，如果想获得所有解需要在达到最大数时记录结果
    bool solve(vector<vector<char>>& board, int size, int current) {
        for (int k = current, total = size*size; k < total; k++) {
            int i = k / size, j = k % size;
            if (board[i][j] != '.') continue;
            for (char c = '1'; c <= '9'; c++) {
                if (isValid(board, size, i, j, c)) {
                    board[i][j] = c;
                    if (solve(board, size, k+1)) return true;
                    board[i][j] = '.';
                }
            }
            return false;
        }
        return true;
    }

    // 验证（row, col）位置是否有效
    bool isValid(vector<vector<char>>& board, int size, int row, int col, char c) {
        for (int i = 0; i < size; i++) {
            if (board[i][col] != '.' && board[i][col] == c) return false;
            if (board[row][i] != '.' && board[row][i] == c) return false;
            int boxI = 3*(row/3) + i/3;
            int boxJ = 3*(col/3) + i%3;
            if (board[boxI][boxJ] != '.' && board[boxI][boxJ] == c) return false;
        }
        return true;
    }
};

```

## 6.求1+2+…+n（剑指 Offer 64）

```
class Solution {
public:
    int sumNums(int n) {
        int ans = 0, A = n, B = n + 1;
        
        /*
        while (B) {
            if (B & 1) ans += A;
            A <<= 1;
            B >>= 1;
        }
        return ans >> 1;
        */
        
        // 因为 n 为 [1,10000]，所以 n 二进制位最多不会超过 14 位
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 1
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 2
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 3
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 4
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 5
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 6
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 7
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 8
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 9
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 10
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 11
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 12
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 13
        (B & 1) && (ans += A); A <<= 1; B >>= 1; // 14
        return ans >> 1; // (n * (n + 1)) / 2
    }
};

```

## 7.N皇后（Leetcode 51）

```
// C++
// 回溯 方法一 生成中间结果，各个皇后的位置

class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {
        if (n <= 0) return vector<vector<string>>();
        vector<vector<int>> result;
        vector<int> currentState(n, -1);    // 下标代表皇后所在行，值代表列
        set<int> cols;                      // '|' 列
        set<int> slashs;                    // '/' row + column
        set<int> backslashs;                // '\' row - column
        dfs(n, 0, cols, slashs, backslashs, currentState, result);
        return generateResult(n, result);
    }

private:
    void dfs(int n, int row, set<int> &cols, set<int> &slashs, set<int> &backslashs, vector<int> &currentState, vector<vector<int>> &result) {
        if (row >= n) {
            result.push_back(currentState);
            return;
        }
        for (int col = 0; col < n; col++) {
            if (hasContain(row, col, cols, slashs, backslashs)) continue;
            cols.insert(col);
            slashs.insert(row + col);
            backslashs.insert(row - col);

            currentState[row] = col; 
            dfs(n, row + 1, cols, slashs, backslashs, currentState, result);
            currentState[row] = -1; // 这行可以省略，后续会直接替换该位置

            cols.erase(col);
            slashs.erase(row + col);
            backslashs.erase(row - col);
        }
    }

    // 检测是否发生冲突
    bool hasContain(int row, int col, set<int> &cols, set<int> &slashs, set<int> &backslashs) {
        if (cols.find(col) != cols.end() || 
            slashs.find(row + col) != slashs.end() ||
            backslashs.find(row - col) != backslashs.end()) {
            return true;
        }
        return false;
    }

    // 生成结果
    vector<vector<string>> generateResult(int n, vector<vector<int>> result) {
        vector<vector<string>> generateResult;
        for (int i = 0, size = result.size(); i < size; i++) {
            vector<int> currentState = result[i];
            vector<string> currentStateStr(n, string(n, '.'));
            for (int j = 0, curSize = currentState.size(); j < curSize; j++) {
                currentStateStr[j][currentState[j]] = 'Q';
            }
            generateResult.push_back(currentStateStr);
        }
        return generateResult;
    }
};

```

```

// C++
// 回溯 方法二 直接生成结果

class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {
        if (n <= 0) return vector<vector<string>>();
        vector<vector<string>> result;
        vector<string> currentState(n, string(n, '.')); 
        set<int> cols;                      // '|' 列
        set<int> slashs;                    // '/' row + column
        set<int> backslashs;                // '\' row - column
        dfs(n, 0, cols, slashs, backslashs, currentState, result);
        return result;
    }

private:
    void dfs(int n, int row, set<int> &cols, set<int> &slashs, set<int> &backslashs, vector<string> &currentState, vector<vector<string>> &result) {
        if (row >= n) {
            result.push_back(currentState);
            return;
        }
        for (int col = 0; col < n; col++) {
            if (hasContain(row, col, cols, slashs, backslashs)) continue;
            cols.insert(col);
            slashs.insert(row + col);
            backslashs.insert(row - col);

            currentState[row][col] = 'Q'; 
            dfs(n, row + 1, cols, slashs, backslashs, currentState, result);
            currentState[row][col] = '.';

            cols.erase(col);
            slashs.erase(row + col);
            backslashs.erase(row - col);
        }
    }

    // 检测是否发生冲突
    bool hasContain(int row, int col, set<int> &cols, set<int> &slashs, set<int> &backslashs) {
        if (cols.find(col) != cols.end() || 
            slashs.find(row + col) != slashs.end() ||
            backslashs.find(row - col) != backslashs.end()) {
            return true;
        }
        return false;
    }
};

```

```
// C++
// 回溯 方法三 位运算

class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {
        if (n <= 0) return vector<vector<string>>();
        vector<vector<string>> result;
        vector<string> currentState(n, string(n, '.'));
        dfs(n, 0, 0, 0, 0, currentState, result);
        return result;
    }

private:
    void dfs(int n, int row, int cols, int slashs, int backslashs, vector<string>& currentState, vector<vector<string>>& result) {
        if (row >= n) {
            result.push_back(currentState);
            return;
        }
        /*
         1. cls | slash | backslashs 得到所有可以放置皇后的列，对应位为 0
         2. ~ 取反将可放皇后的位置改为 1
         3. & ((1 << n) - 1) 清空高位多余的 1
        */
        int placeCols = (~(cols | slashs | backslashs)) & ((1 << n) - 1);
        while (placeCols) {
            int p = placeCols & -placeCols;         // 取出最低位的 1（可放置皇后位置）
            placeCols = placeCols & (placeCols - 1);// 清除最低位 1
            int col = getColumn(p);
            currentState[row][col] = 'Q';
            // (slashs | p) << 1 与 (backslashs | p) >> 1 都是下一行不可放置的列
            dfs(n, row + 1, cols | p, (slashs | p) << 1, (backslashs | p) >> 1, currentState, result);
            currentState[row][col] = '.';
        }
    }

    // 计算 p 对应的列
    int getColumn(int p) {
        int col = 0;
        while(p = (p >> 1)) {
            col++;
        }
        return col;
    }
};

```

## 8.LRU缓存机制（Leetcode 146）

```
// C++

class LRUCache {
public:
    LRUCache(int _capacity): capacity(_capacity), size(0) {
        head = new DLinkedNode();
        tail = new DLinkedNode();
        head->next = tail;
        tail->pre = head;
    }
    
    int get(int key) {
        if (!cache.count(key)) return -1;
        DLinkedNode* node = cache[key];
        moveToHead(node);
        return node->value;
    }
    
    void put(int key, int value) {
        if (cache.count(key)) {
            DLinkedNode* node = cache[key];
            node->value = value;
            moveToHead(node);       // 移到表头
            return;
        }

        DLinkedNode* node = new DLinkedNode(key, value);
        cache[key] = node;
        addToHead(node);            // 添加到表头
        size++;
        // 如果超过上限，移除最久没使用节点
        if (size > capacity) {
            DLinkedNode* removeNode = removeTail();
            cache.erase(removeNode->key);
            delete removeNode;
            size--;
        } 
    }

private:
    struct DLinkedNode {
        int key;
        int value;
        DLinkedNode* pre;
        DLinkedNode* next;
        DLinkedNode(): key(0), value(0), pre(nullptr), next(nullptr){}
        DLinkedNode(int _key, int _value): key(_key), value(_value), pre(nullptr), next(nullptr){}
    };

    unordered_map<int, DLinkedNode *> cache;
    DLinkedNode* head;
    DLinkedNode* tail;
    int size;           // 当前数量
    int capacity;       // 容量

    // 将节点添加到表头
    void addToHead(DLinkedNode* node) {
        node->pre = head;
        node->next = head->next;
        head->next->pre = node;
        head->next = node;
    }

    // 删除节点
    void removeNode(DLinkedNode* node) {
        node->pre->next = node->next;
        node->next->pre = node->pre;
    }

    // 将节点移到表头
    void moveToHead(DLinkedNode* node) {
        removeNode(node);
        addToHead(node);
    }

    // 删除尾部节点
    DLinkedNode* removeTail() {
        DLinkedNode *node = tail->pre;
        removeNode(node);
        return node;
    }

};

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache* obj = new LRUCache(capacity);
 * int param_1 = obj->get(key);
 * obj->put(key,value);
 */
 
```

## 9. 正则表达式匹配（Leetcode 10）

```
// C++

class Solution {
public:
    bool isMatch(string s, string p) {
        unordered_map<string, bool> memo;
        return dp(s, 0, p, 0, memo);
    }

private:
    bool dp(string& s, int i, string& p, int j, unordered_map<string, bool>& memo) {
        int m = s.size(), n = p.size();
        // 1.如果 p 匹配完，s 也恰好被匹配完，则匹配成功
        if (j == n) return i == m; 
        // 2.如果 s 匹配完，只要 j 后的字符串能够匹配空串，则匹配成功
        if (i == m) {
            if ((n-j)%2 == 1) return false;     // 字符和 * 一定成对儿出现
            for (; j+1 < n; j += 2 ) {          // 隔一个字符出现一个 *
                if (p[j+1] != '*') return false;
            }
            return true;
        }

        // 记录状态 (i,j)，消除重叠子问题
        string key = to_string(i) + "," + to_string(j);
        if (memo.count(key)) return memo[key];

        // 判断当前位置是否匹配
        bool res = false;
        if (s[i] == p[j] || p[j] == '.') {
            // 如果下一位是 *，可以匹配 0 或多次，否则常规匹配 1 次
            res = j<n-1 && p[j+1]=='*' ? (dp(s, i, p, j+2, memo) || dp(s, i+1, p, j, memo)) : dp(s, i+1, p, j+1, memo);
        } else {
            // 如果下一位是 *，可以匹配 0 次，否则匹配失败
            res = j<n-1 && p[j+1]=='*' ? dp(s, i, p, j+2, memo) : false;
        }
        memo[key] = res;
        return res;
    }
};

```

## 10.最长上升子序列（Leetcode 300）

```
// C++
// DP

class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) return 0;
        // dp[i] 为前 i+1 个元素，以第 i+1 个数字结尾的最长上升子序列的长度（ nums[i] 必须被选取）
        vector<int> dp(n, 0);
        for (int i = 0; i < n; ++i) {
            dp[i] = 1;
            for (int j = 0; j < i; ++j) {
                if (nums[j] < nums[i]) {
                    dp[i] = max(dp[i], dp[j] + 1);
                }
            }
        }
        return *max_element(dp.begin(), dp.end());
    }
};

```

```
// C++
// 贪心 + 二分查找

class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) return 0;
        /* 
            dp[i] 表示长度为 i+1 的所有上升子序列的结尾的最小值
            [10,9,2,5,3,7,101,18] 中长度为 2 的所有上升子序列中结尾最小的是子序列 [2,3]，因此 dp[1] = 3
        */
        vector<int> dp(n, 0); 
        int k = 0;
        dp[k] = nums[0];
        for (int i = 1; i < n; ++i) {
            if (nums[i] > dp[k]) {
                dp[++k] = nums[i];
            } else {
                int left = 0, right = k;
                while (left <= right) {  // 第一个大于等于 nums[i] 的下标
                    int mid = (left + right) >> 1;
                    nums[i] > dp[mid] ? left = mid + 1 : right = mid - 1;
                }
                dp[right+1] = nums[i];
            }
        }
        return k + 1;
    }
};

```
