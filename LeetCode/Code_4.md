# Code_4


## 1.编辑距离（Leetcode 72）

```

// C++
// 1. 递归


class Solution {
public:
    unordered_map<string,int> memo;
    int minDistance(string word1, string word2) {
        int size1 = word1.size(), size2 = word2.size();
        if (0 == size1 || 0 == size2) {
            return max(size1, size2);
        }

        string key = to_string(size1) + to_string(size2);
        if (memo.find(key) != memo.end()) {
            return memo[key];
        }

        if (word1.back() == word2.back()) {
            // 末尾相同，可直接删除，不影响操作数
            return minDistance(word1.substr(0, size1-1), word2.substr(0, size2-1));
        }

        // 1. word1 末尾插入一个与 word2 末尾相同的字符，等同在 word2 末尾删除一个字符
        int n2_1 = minDistance(word1, word2.substr(0, size2-1));
        // 2. word1 末尾删除一个字符，等同在 word2 末尾插入一个与 word1 末尾相同的字符
        int n1_1 = minDistance(word1.substr(0, size1-1), word2);
        // 3. word1 末尾替换为与 word2 末尾相同的字符，反之替换word2也是一样的
        int n21_1 = minDistance(word1.substr(0, size1-1), word2.substr(0, size2-1));

        int val = min(n2_1, min(n1_1, n21_1)) + 1;
        memo[key] = val;
        return val;
    }
};


```

```

// C++
// 2. DP


class Solution {
public:
    unordered_map<string,int> memo;
    int minDistance(string word1, string word2) {

        /*
            dp[i][j]：word1 前 i+1 个字符与 Word 前 j+1 个字符转换的最小操作数
                word1[i-1] == word2[j-1]：dp[i][j] = dp[i-1][j-1]
                word1[i-1] != word2[j-1]：dp[i][j] = min(dp[i][j-1], min(dp[i-1][j], min[i-1][j-1])) + 1
        */

        int size1 = word1.size(), size2 = word2.size();
        if (0 == size1 || 0 == size2) {
            return size1 + size2;
        }

        vector<vector<int>> dp(size1+1, vector(size2+1, 0));

        for (int i = 0; i <= size1; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= size2; j++) {
            dp[0][j] = j;
        }
        for(int i = 1; i <= size1; i++) {
            for (int j = 1; j <= size2; j++) {
                if (word1[i-1] == word2[j-1]) {
                    dp[i][j] = dp[i-1][j-1];
                } else {
                    dp[i][j] = min(dp[i][j-1], min(dp[i-1][j], dp[i-1][j-1])) + 1;
                }
            }
        }
        
        return dp[size1][size2];
    }
};


```


## 2.朋友圈（Leetcode 547）


```

// C++
// 1. DFS

class Solution {
public:
    int findCircleNum(vector<vector<int>>& M) {
        int size = M.size();
        vector<bool> visited(size, false);
        int count = 0;
        for (int i = 0; i < size; i++) {
            if (false == visited[i]) {
                dfs(M, visited, i);
                count++;
            }
        }
        return count;
    }

private:
    void dfs(vector<vector<int>>& M, vector<bool>& visited, int i) {
        for (int j = 0, size = M.size(); j < size; j++) {
            if (1 == M[i][j] && false == visited[j]) {
                visited[j] = true;
                dfs(M, visited, j);
            }
        }
    }
};


```

```

// C++
// 2. 并查集

class Solution {
public:
    int findCircleNum(vector<vector<int>>& M) {
        int size = M.size();
        if (0 == size) return 0;

        // 初始化
        this->count = size;
        this->parent = vector(size, 0);
        for (int i = 0; i < size; i++) {
            this->parent[i] = i;
        }
        
        // 进行合并
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (1 == M[i][j]) this->unionFind(i, j);
            }
        }
        
        // 返回集合数
        return this->count;
    }

private:
    int count;
    vector<int> parent;
  
    int find(int i) {
        int root = i;
        while(this->parent[root] != root) {
            root = this->parent[root];
        }
        // 路径压缩，所有节点的父节点都指向 root，可不进行压缩
        while(parent[i] != i) {
            int x = i;
            i = this->parent[i];
            this->parent[x] = root;
        }
        return root;
    }

    void unionFind(int p, int q) {
        int rootP = this->find(p);
        int rootQ = this->find(q);
        if (rootP == rootQ) return;
        this->parent[rootP] = rootQ;
        this->count--;
    }
    
};


```


## 3.并查集

```

// C++

class UnionFind {

private:
    vector<int> parent;
    
public:    
    // 初始化
    UnionFind(int n) {
        count = n;
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    int find(int i) {
        int root = i;
        while(this->parent[root] != root) {
            root = this->parent[root];
        }
        // 路径压缩，所有节点的父节点都指向 root，可不进行压缩
        while(parent[i] != i) {
            int x = i;
            i = this->parent[i];
            this->parent[x] = root;
        }
        return root;
    }

    void unionFind(int p, int q) {
        int rootP = this->find(p);
        int rootQ = this->find(q);
        if (rootP == rootQ) return;
        this->parent[rootP] = rootQ;
        this->count--;
    }
};


```


```

// C++
// 2. 添加类似权重信息，优化压缩逻辑

class UnionFind {

private:
    int count;
    vector<int> rank;
    vector<int> parent;

public:
    UnionFind(vector<vector<char>>& grid) {
        count = 0;
        int row = grid.size();
        if (0 == row) return;
        int col = grid[0].size();
        for (int i = 0; i < row; ++i) {
            for (int j = 0; j < col; ++j) {
                if (grid[i][j] == '1') {
                    parent.push_back(i * col + j);
                    ++count;
                }
                else {
                    parent.push_back(-1);
                }
                rank.push_back(0);
            }
        }
    }

    int find(int i) {
        while (parent[i] != i) {
            parent[i] = parent[parent[i]];  // 压缩
            i = parent[i];
        }
        return i;
    }

    void unionFind(int p, int q) {
        int rootP = find(p);
        int rootQ = find(q);
        if (rootP == rootQ) return;
        if (rank[rootP] < rank[rootQ]) swap(rootP, rootQ);  // 保证 rootP 为较大值
        parent[rootQ] = rootP;                              // 大的往小里合
        if (rank[rootP] == rank[rootQ]) rank[rootP]++;      // 如果相等 rank 加 1
        count--;
    }

    int getCount() {
        return count;
    }
};


```


## 4.被围绕的区域（Leetcode 130）


```

// C++
// DFS

class Solution {
public:
    void solve(vector<vector<char>>& board) {
        int n = board.size();
        if (n == 0) return;
        int m = board[0].size();
        // 遍历竖直边界节点，发现 ‘O’ 置为 ‘A’
        for (int i = 0; i < n; i++) {
            dfs(board, i, 0);
            dfs(board, i, m - 1);
        }
        // 遍历水平边界节点，发现 ‘O’ 置为 ‘A’
        for (int i = 1; i < m - 1; i++) {
            dfs(board, 0, i);
            dfs(board, n - 1, i);
        }
        // 将 ‘A’ 置为 ‘O’，‘O’ 置为 ‘X’，得到对应结果
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == 'A') {
                    board[i][j] = 'O';
                } else if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
            }
        }
    }

private:
    void dfs(vector<vector<char>>& board, int x, int y) {
        int n = board.size();
        if (n == 0) return;
        int m = board[0].size();
        if (x < 0 || x >= n || y < 0 || y >= m || board[x][y] != 'O') {
            return;
        }
        board[x][y] = 'A';
        dfs(board, x + 1, y);
        dfs(board, x - 1, y);
        dfs(board, x, y + 1);
        dfs(board, x, y - 1);
    }
};

```
