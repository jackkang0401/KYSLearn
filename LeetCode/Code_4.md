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
            return size1 + size2;
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
            dp[i][j]：word1 前 i 个字符转换为 word2 前 j 个字符的最小操作数
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

class UnionFind {

private:
    int count;
    vector<int> rank;
    vector<int> parent;

public:
    UnionFind(int n) {
        // 初始化
        count = n;
        rank = vector(n, 0);
        parent = vector(n, 0);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
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
        parent[rootQ] = rootP;                              // 大的作为父节点
        if (rank[rootP] == rank[rootQ]) rank[rootP]++;      // 如果相等 rank 加 1
        count--;
    }

    int getCount() {
        return count;
    }
};

class Solution {
public:
    int findCircleNum(vector<vector<int>>& M) {
        int size = M.size();
        if (0 == size) return 0;

        UnionFind uf(size);
        
        // 进行合并
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (1 == M[i][j]) uf.unionFind(i, j);
            }
        }
        
        // 返回集合数
        return uf.getCount();
    }    
};


```


## 3.并查集（朋友圈（547）、岛屿数量（200）、被围绕的区域（130））


```

// C++
// 1. 并查集 权重信息，压缩逻辑

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
        parent[rootQ] = rootP;                              // 大的作为父节点
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
// 1. DFS

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


```
// C++
// 2. 并查集

class UnionFind {

private:
    int count;
    vector<int> rank;
    vector<int> parent;

public:
    UnionFind(int n) {
        count = n;
        rank = vector(n, 0);
        parent = vector(n, 0);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    int find(int i) {
        while(parent[i] != i) {
            parent[i] = parent[parent[i]];
            i = parent[i];
        }
        return i;
    }

    void unionFind (int p, int q) {
        int rootP = find(p);
        int rootQ = find(q);
        if (rootP == rootQ) return;
        if (rank[rootP] < rank[rootQ]) swap(rootP, rootQ);
        parent[rootQ] = rootP;              // 保证大的作为父节点
        if (rank[rootP] == rank[rootQ]) rank[rootP]++;
        count--;
    }

    bool isConnect(int p, int q) {
        return find(p) == find(q);
    }
};

class Solution {
public:
    void solve(vector<vector<char>>& board) {
        int row = board.size();
        if (row <= 0) return;
        int col = board[0].size();

        // 把所有边界上的 ‘O’ 节点看作一个连通区域
        UnionFind uf(row*col + 1); 
        int borderO = row*col;      // 边界上的 ‘O’ 连通区域

        for(int i = 0; i < row; i++) {
            for(int j = 0; j < col; j++) {
                if ('O' == board[i][j]) {
                    if (0 == i || i == row-1 || 0 == j || j == col-1) {
                        uf.unionFind(i*col+j, borderO);
                    } else {
                        // 走到这里一定不会越界
                        if ('O' == board[i-1][j]) uf.unionFind(i*col+j, (i-1)*col+j);
                        if ('O' == board[i+1][j]) uf.unionFind(i*col+j, (i+1)*col+j);
                        if ('O' == board[i][j-1]) uf.unionFind(i*col+j, i*col+(j-1));
                        if ('O' == board[i][j+1]) uf.unionFind(i*col+j, i*col+(j+1));
                    }
                }
            }
        }

        for(int i = 0; i < row; i++) {
            for(int j = 0; j < col; j++) {
                if ('X' == board[i][j]) continue; 
                if (false == uf.isConnect(i*col+j, borderO)) {
                    board[i][j] = 'X';
                }
            }
        }
    } 
};

```

## 5.二进制矩阵中的最短路径（Leetcode 1091）


```

// C++
// 1. BFS


class Solution {

private:
    struct Node {
        int x;
        int y; 
        int step;
        Node(int i, int j, int s): x(i), y(j), step(s) {}
    };

public:
    int shortestPathBinaryMatrix(vector<vector<int>>& grid) {
        int size = grid.size();
        if(size == 0 || grid[0][0] || grid[size-1][size-1]) return -1; // 无节点 || 起始点被阻塞 || 结束点被阻塞

        queue<struct Node> q;
        q.push(Node(0, 0, 1));      // 起始节点 (0,0)
        grid[0][0] = 1;             // 标记第一个节点，为已访问
        
        while(!q.empty()) {         // 一个一个走需要记深度
            Node node = q.front();
            q.pop();
            if(node.x == size-1 && node.y == size-1) return node.step; // 到达终点
            for(int dx = -1; dx <= 1; dx++) {
                for(int dy = -1; dy <= 1; dy++) {
                    int i = node.x + dx;
                    int j = node.y + dy;
                    if(i < 0 || j < 0 || i >= size || j >= size || grid[i][j]) continue;    // 当前节点越界或阻塞，跳过
                    q.push(Node(i, j, node.step + 1));                  // 放入队列
                    grid[i][j] = 1;                                     // 标记为阻塞
                }
            }
        }
        return -1;
    }
};


```


```

// C++
// 2. DBFS

struct Node {
    int x;
    int y; 
    Node(int i, int j): x(i), y(j){}

    bool operator<(const Node& node) const {       
        if (x == node.x && y == node.y) return false;       // 去重
        return x == node.x ? (y > node.y) : (x > node.x);   // 降序
    }

    bool operator==(const Node& node) const {               // set 查找使用
        return x == node.x && y == node.y;
    }
};

// 自定义哈希
struct hashFunc {
    size_t operator()(const Node& node) const{
        return hash<int>()(node.x) ^ hash<int>()(node.y);
    }
};

class Solution {

public:
    int shortestPathBinaryMatrix(vector<vector<int>>& grid) {
        int size = grid.size();
        if(size == 0 || grid[0][0] || grid[size-1][size-1]) return -1; // 无节点 || 起始点被阻塞 || 结束点被阻塞
        if (1 == size) return 1 == grid[0][0] ? -1 : 1 ;
        unordered_set<Node, hashFunc> beginSet; 
        unordered_set<Node, hashFunc> endSet;
        beginSet.insert(Node(0, 0));
        grid[0][0] = 1;             // 标记第一个节点，为已访问
        endSet.insert(Node(size-1, size-1));
        grid[size-1][size-1] = 1;   // 标记最后一个节点，为已访问

        int step = 1;
        while(!beginSet.empty() && !endSet.empty()) {                   // 一层一层走，直接叠加层数即可
            // 如果起始集合比结束集合大，进行交换
            if (beginSet.size() > endSet.size()) {
                unordered_set<Node, hashFunc> tempSet = beginSet;
                beginSet = endSet;
                endSet = tempSet;
            }

            unordered_set<Node, hashFunc> nextSet;
            for (Node node : beginSet) {
                for(int dx = -1; dx <= 1; dx++) {
                    for(int dy = -1; dy <= 1; dy++) {
                        int i = node.x + dx;
                        int j = node.y + dy;
                        if(i < 0 || j < 0 || i >= size || j >= size) continue;// 当前节点越界跳过
                        if (endSet.find(Node(i, j)) != endSet.end()) {
                            return step+1;
                        } 
                        if(1 == grid[i][j]) continue;                   // 当前节点阻塞跳过
                        nextSet.insert(Node(i, j));                     // 放入队列
                        grid[i][j] = 1;                                 // 标记为阻塞
                    }
                }
            }
            beginSet = nextSet;
            step++;
        }
        return -1;
    }
};


```

```

// C++
// 3. A* 启发式搜索


struct Node {
    int x;
    int y; 
    int step;
    int size;   // 方形网格大小
    Node(int i, int j, int step, int size): x(i), y(j), step(step), size(size){}

    bool operator<(const Node& node) const {  // 降序，大顶堆
        int maxIndex = size-1;
        return max(maxIndex-x, maxIndex-y)+step > max(maxIndex-node.x, maxIndex-node.y)+node.step;
    }
};

class Solution {

public:
    int shortestPathBinaryMatrix(vector<vector<int>>& grid) {
        int size = grid.size();
        if(size == 0 || grid[0][0] || grid[size-1][size-1]) return -1; // 无节点 || 起始点被阻塞 || 结束点被阻塞

        vector<vector<int>> stepCount(size, vector(size, 0));
        priority_queue<struct Node> q;
        q.push(Node(0, 0, 1, size));        // 起始节点 (0,0)
        stepCount[0][0] = 1;                // 保存最小花费

        while(!q.empty()) {
            Node node = q.top();
            q.pop();
            if(node.x == size-1 && node.y == size-1) return node.step; // 到达终点
            for(int dx = -1; dx <= 1; dx++) {
                for(int dy = -1; dy <= 1; dy++) {
                    int i = node.x + dx;
                    int j = node.y + dy;
                    if(i < 0 || j < 0 || i >= size || j >= size || grid[i][j]) continue;    // 当前节点越界或阻塞，跳过
                    // 没有到走过改点或者当前的路线更优
                    if (0 == stepCount[i][j] || node.step+1 < stepCount[i][j]) {
                        int curStep = node.step + 1;
                        q.push(Node(i, j, curStep, size));
                        stepCount[i][j] = curStep;
                    }
                }
            }
        }
        return -1;
    }
};


```


## 6.滑动谜题（Leetcode 773）



```

// C++
// 1. BFS

class Solution {

public:
    int slidingPuzzle(vector<vector<int>>& board) {
    
        if (board.size() == 0 || board[0].size() == 0) return -1;
        int n = board.size(); 
        int m = board[0].size();
        // 转化成字符串
        string startStatus = "";
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                startStatus.push_back(board[i][j]+'0');
            }
        }
        string endStatus = "123450";

        // 保存各个位置对应的索引变化
        vector<vector<int>> neighbor = {
            { 1, 3 },
            { 0, 4, 2 },
            { 1, 5 },
            { 0, 4 },
            { 3, 1, 5 },
            { 4, 2 }
        };
        
        queue<string> q;                    // bfs队列
        unordered_set<string> visited;      // 已转换状态
        q.push(startStatus);
        visited.insert(startStatus);
    
        int step = 0;
        while (!q.empty()) {                // 一层一层遍历
            int currentLevelSize = q.size();
            for (int i = 0; i < currentLevelSize; i++) {
                string currentStatus = q.front(); 
                q.pop();
                if (endStatus == currentStatus) return step;// 已到最终结果，返回
                // 找到数字 0 的索引
                int idx0 = 0;
                while (currentStatus[idx0] != '0') idx0++;  // 查找 ‘0’ 的位置
                for (int nextIndex : neighbor[idx0]) {      // 变换 ‘0’ 的位置
                    string nextStatus = currentStatus;
                    swap(nextStatus[nextIndex], nextStatus[idx0]);
                    if (visited.find(nextStatus) == visited.end()) {
                        q.push(nextStatus);                 // 放入队列
                        visited.insert(nextStatus);
                    }
                }
            }
            step++;
        }
        return -1;
    }
};


```


```

// C++
// 2. A* 启发式搜索


struct Node {
    string status;      // 当前状态
    int zeroIndex;      // ‘0’ 位置
    int step;           // 已遍历层数
    int distance;       // 距离终点距离
    int f;              // 最终估价值 step + distance

    Node(string status) {
        this->status = status;
        // 记录 ‘0’ 的位置
        for (int i = 0, size = status.size(); i < size; i++) {
            if ('0' == status[i]) {
                zeroIndex = i;
                break;
            }
        }
        step = 0;
        distance = calculateDistance();
        f = step + distance; 
    }

    Node(string status, int zeroIndex, int step) {
        this->status = status;
        this->zeroIndex = zeroIndex;
        this->step = step;
        distance = calculateDistance();
        f = step + distance; 
    }

    int calculateDistance() {
        int n = 0;
        // 计算每个坐标的当前位置到最终位置的距离（曼哈顿距离）
        for (int i = 0, size = status.size(); i < size; i++) {
            int endIndex = status[i] - '0' - 1; // 当前字符的最终位置
            n += abs(endIndex/3 - i/3) + abs(endIndex%3-i%3);        
        }
        return n;
    }

    bool operator<(const Node& node) const {  // 降序，大顶堆
        return f > node.f;
    }

    bool operator==(const Node& node) const { // 查找
        return status == node.status;
    }
};

// 自定义哈希
struct hashFunc {
    size_t operator()(const Node& node) const{
        return hash<string>()(node.status);
    }
};

class Solution {

public:
    int slidingPuzzle(vector<vector<int>>& board) {
        
        if (board.size() == 0 || board[0].size() == 0) return -1;
        int n = board.size(); 
        int m = board[0].size();
        // 转化成字符串
        string startStatus = "";
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                startStatus.push_back(board[i][j]+'0');
            }
        }
        string endStatus = "123450";
        string wrongStatus = "123540";          // 如果进入这种状态是一定不能到达终点

        // 保存各个位置对应的索引变化
        vector<vector<int>> neighbor = {
            { 1, 3 },
            { 0, 4, 2 },
            { 1, 5 },
            { 0, 4 },
            { 3, 1, 5 },
            { 4, 2 }
        };
        
        priority_queue<Node> q;                     // 优先队列
        unordered_set<Node, hashFunc> visited;      // 已转换状态
        q.push(Node(startStatus));
        visited.insert(Node(startStatus));

        while (!q.empty()) {
            Node currentNode = q.top(); 
            q.pop();
            if (currentNode.status == endStatus) return currentNode.step; // 已到最终结果，返回
            for (int nextIndex : neighbor[currentNode.zeroIndex]) { 
                string nextStatus = currentNode.status;
                swap(nextStatus[nextIndex], nextStatus[currentNode.zeroIndex]);
                if (nextStatus == wrongStatus) return -1;               // 无法到这终点
                Node nextNode = Node(nextStatus, nextIndex, currentNode.step+1);
                if (visited.find(nextNode) == visited.end()) {
                    q.push(nextNode);                                   // 放入队列
                    visited.insert(nextNode);
                }
            }
        }
        return -1;
    }
};


```


## 7.位1的个数（Leetcode 191）



```

// C++
// 位运算

class Solution {
public:
    int hammingWeight(uint32_t n) {
        int count = 0;
        while(0 != n) {
            count++;
            n &= (n-1);     // 清空最低位的 1
        }
        return count;
    }
};


```


## 8. 2的幂（Leetcode 231）


```

// C++
// 位运算


class Solution {
public:
    bool isPowerOfTwo(int n) {
        return (n > 0) && (0 == (n & (n - 1))); // 一个数的幂次方不会小于 0 && 清空最低位
    }
};


```


## 9. 颠倒二进制位（Leetcode 190）



```

// C++
// 1. 逐位颠倒


class Solution {
public:
    uint32_t reverseBits(uint32_t n) {
        uint32_t result = 0, power = 31;
        while (n != 0) {
            result += (n & 1) << power; // 颠倒到正确位置 (n & 1) << power，加入最终结果
            n = n >> 1;                 // 左移
            power--;                    // 对应颠倒位 -1
        }
        return result;
    }
};


```

```

// C++
// 2. 分治、位运算

class Solution {
public:
    uint32_t reverseBits(uint32_t n) {
        /*
        首先，我们将原来的 32 位分为 2 个 16 位的块
        然后，将 16 位块分成 2 个 8 位的块
        继续将这些块分成更小的块，直到达到 1 位的块
        */
        n = (n >> 16) | (n << 16);
        n = ((n & 0xff00ff00) >> 8) | ((n & 0x00ff00ff) << 8);
        n = ((n & 0xf0f0f0f0) >> 4) | ((n & 0x0f0f0f0f) << 4);
        n = ((n & 0xcccccccc) >> 2) | ((n & 0x33333333) << 2);
        n = ((n & 0xaaaaaaaa) >> 1) | ((n & 0x55555555) << 1);
        return n;
    }
};


```


## 10. 比特位计数（Leetcode 338）


```

// C++
// DP+位运算

class Solution {
public:
    vector<int> countBits(int num) {
        vector<int> bits(num+1, 0);
        for (int i=1; i <= num; i++) {
            bits[i] = bits[i & (i-1)] + 1;      // 清空最低位 + 1
        }
        return bits;
    }
};


```
