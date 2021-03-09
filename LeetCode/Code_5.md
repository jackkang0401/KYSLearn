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
