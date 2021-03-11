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
// 哈希表-存储索引

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
