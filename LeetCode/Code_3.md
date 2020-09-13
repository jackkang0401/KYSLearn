# Code_3


## 1.单词接龙（Leetcode 127）

```
// C++
// BFS

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        if (0 ==beginWord.size()) return 0;
        // 建立映射
        unordered_map<string,vector<string>> allWordMap;
        for (auto word : wordList) {
            string key = word;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = key[i];
                key[i] = '*'; 
                allWordMap[key].push_back(word);
                key[i] = c;
            }
        }

        // BFS
        queue<pair<string,int>> q;
        q.push(make_pair(beginWord, 1));
        set<string> visitedSet;          // 记录已遍历字符串，避免重复遍历
        visitedSet.insert(beginWord);
        while(!q.empty()) {
            pair<string,int> wordPair = q.front();
            q.pop();
            string word = wordPair.first;
            int level = wordPair.second;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = word[i];
                word[i] = '*';
                for (auto w : allWordMap[word]) {
                    if (w == endWord) return level + 1;
                    if (visitedSet.find(w) != visitedSet.end()) continue;
                    q.push(make_pair(w, level + 1));
                    visitedSet.insert(w);
                }
                word[i] = c;
            }
        }
        return 0;
    }
};

```

```
// C++
// DBFS

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        if (0 == beginWord.size()) return 0;

        // 建立映射
        bool hasEndWord = false;
        unordered_map<string, vector<string>> wordMap;
        for (auto word : wordList) {
            if (word == endWord) hasEndWord = true;
            string key = word;
            for (int i = 0, size = word.size(); i < size; i++) {
                char c = key[i];
                key[i] = '*';
                wordMap[key].push_back(word);
                key[i] = c;
            }
        }

        if (false == hasEndWord) return 0;

        // DBFS
        queue<pair<string, int>> beginQ;
        beginQ.push(make_pair(beginWord, 1));
        unordered_map<string, int> beginVis;        // 记录 begin 已遍历字符串，避免重复遍历
        beginVis[beginWord] = 1;

        queue<pair<string,int>> endQ;
        endQ.push(make_pair(endWord, 1));
        unordered_map<string,int> endVis;           // 记录 end 已遍历字符串，避免重复遍历
        endVis[endWord] = 1;

        // 两边同时走
        while(!beginQ.empty() && !endQ.empty()) {
            int beginAns = visitWord(beginQ, beginVis, endVis, wordMap);
            if (beginAns > -1) return beginAns;
            int endAns = visitWord(endQ, endVis, beginVis, wordMap);
            if (endAns > -1) return endAns;
        }
        return 0;
    }

private:
    int visitWord(queue<pair<string, int>>& q, unordered_map<string, int>& visited, unordered_map<string, int>& otherVis, unordered_map<string, vector<string>>& wordMap) {
        pair<string, int> wordPair = q.front();
        q.pop();
        string word = wordPair.first;
        int level = wordPair.second;
        for (int i = 0, size = word.size(); i < size; i++) {
            char c = word[i];
            word[i] = '*';
            for (auto w : wordMap[word]) {
                if (otherVis.find(w) != otherVis.end()) return level + otherVis[w];
                if (visited.find(w) != visited.end()) continue;
                q.push(make_pair(w, level+1));
                visited[w] = level+1;
            }
            word[i] = c;
        }
        return -1;
    }
};

```

## 2.搜索插入位置（Leetcode 35）

```
// C++
// 二分查找

class Solution {
public:
    int searchInsert(vector<int>& nums, int target) {
        int n = nums.size();
        int left = 0, right = n - 1;
        // 其实就是找第一个大于等于 target 的下标（看等于时停在哪）
        while (left <= right) {
            int mid = (right + left) >> 1;
            if (target > nums[mid]) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return left; // right+1
    }
};

```

## 3.二叉树的后序遍历（Leetcode 145）

```
// C++
// 后续遍历

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
 
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        if (nullptr == root) return vector<int>();
        vector<int> result;
        stack<TreeNode *> stack;
        stack.push(root);
        while(!stack.empty()) {
            TreeNode* node = stack.top();
            stack.pop();
            result.insert(result.begin(), node->val);
            if (nullptr != node->left) {
                stack.push(node->left);
            }
            if (nullptr != node->right) {
                stack.push(node->right);
            }
        }
        return result;
    }
};

```
