# Code_2


## 1.解码方法（Leetcode 91）

```
// C++

class Solution {
public:
    int numDecodings(string s) {
        if ('0' == s[0]) return 0;
        vector<int> dp(s.size()+1);
        dp[0] = 1;
        dp[1] = 1;
        for (int i = 1, size = s.size(); i < size; i++) {
            if (s[i] == '0') {
                if (!(s[i-1] == '1' || s[i-1] == '2')) return 0;
                dp[i+1] = dp[i-1];      // 当前位为 ‘0’ 只有 1 或 2 可以解码
            } else if (s[i] <= '6') {
                dp[i+1] = (s[i-1] == '1' || s[i-1] == '2') ? (dp[i] + dp[i-1]) : dp[i];
            } else {
                dp[i+1] = (s[i-1] == '1') ? (dp[i] + dp[i-1]) : dp[i];
            }
        }
        return dp[s.size()];
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
        for(int i = 0; i < length*2; i++){
            // 长度分别为奇数（s[i]）、偶数（中心为空）的回文子串
            int left = i / 2;
            int right = left + i % 2;
            while(left >= 0 && right < length && s[left] == s[right]){
                total++;
                left--;
                right++;
            }
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
    /** Initialize your data structure here. */
    Trie() {
        isEnd = false;
        for (int i = 0; i < 26; i++) {
            links[i] = nullptr;
        }
    }

    ~Trie() {
        for (int i = 0; i < 26; i++) {
            if (links[i] == nullptr) continue;
            delete(links[i]);
            links[i] = nullptr;
        }
    }
    
    /** Inserts a word into the trie. */
    void insert(string word) {
        Trie *node = this;
        for (auto c : word) {
            if (node->links[c - 'a'] == nullptr) {
                node->links[c - 'a'] = new Trie();
            }
            node = node->links[c - 'a'];
        }
        node->isEnd = true;
    }
    
    /** Returns if the word is in the trie. */
    bool search(string word) {
        Trie *node = this;
        for (auto c : word) {
            if (node->links[c - 'a'] == nullptr) return false;
            node = node->links[c - 'a'];
        }
        return node->isEnd;
    }
    
    /** Returns if there is any word in the trie that starts with the given prefix. */
    bool startsWith(string prefix) {
        Trie *node = this;
        for (auto c : prefix) {
            if (node->links[c - 'a'] == nullptr) return false;
            node = node->links[c - 'a'];
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
    string str;
    Trie* links[26];
public:
    Trie() {
        isEnd = false;
        str = "";
        for (int i = 0; i < 26; i++) {
            links[i] = nullptr;
        }
    }
    void insert(string word) {
        Trie *node = this;
        for (auto c : word) {
            if (node->links[c - 'a'] == nullptr) {
                node->links[c - 'a'] = new Trie();
            }
            node = node->links[c - 'a'];
        }
        node->str = word; 
        node->isEnd = true;
    }
    void search(vector<string>& result, vector<vector<char>>& board) {
        for (int i = 0; i < board.size(); i++) {
            for (int j = 0; j < board[i].size(); j++) {
                help(result, board, this, i, j);
            }
        }
    }
    void help(vector<string>&result, vector<vector<char>>& board, Trie* node, int x, int y) {
        if (node->isEnd) {
            node->isEnd = false;    // 删除单词（相当于标记为已使用过）
            result.push_back(node->str);
            return;
        }
        if (x < 0 || x == board.size() || y < 0 || y == board[x].size()) {
            return;
        }
        char c = board[x][y];
        // 当前字符已使用过或不存在直接返回
        if ('#' == c || node->links[c - 'a'] == nullptr) {
            return; 
        }
        node = node->links[c - 'a'];
        board[x][y] = '#';
        help(result, board, node, x+1, y);
        help(result, board, node, x-1, y);
        help(result, board, node, x, y+1);
        help(result, board, node, x, y-1);
        board[x][y] = c;
    }
};

class Solution {
public:
    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        Trie trie;
        vector<string> result;
        for (string& w: words) {
            trie.insert(w);
        }
        trie.search(result, board);
        return result;
    }
};

```
