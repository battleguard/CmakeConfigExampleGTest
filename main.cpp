#include "gtest/gtest.h"

#include <string>

using std::string;

struct Solution
{
// Return the index of the first occurrence of needle in haystack, 
// or -1 if needle is not part of haystack.
int strStr(string haystack, string needle) {
   if (needle.empty()) return 0;
   if (needle.size() > haystack.size()) return -1;
   for (int i = 0, j = 0; i < haystack.size() - needle.size(); ++i)
   {
      for (j = 0; j < needle.size(); ++j)
      {
         if (needle[j] != haystack[i + j])
            break;
      }
      if (j == needle.size())
         return i;
   }
   return -1;
}
};

TEST(strStr, LeetCodeExample1)
{
   string haystack = "hello";
   string needle = "ll";
   int expected = 2;
   int actual = Solution().strStr(haystack, needle);
   EXPECT_EQ(expected, actual);
}

TEST(strStr, LeetCodeExample2)
{
   string haystack = "aaaaa";
   string needle = "bba";
   int expected = -1;
   int actual = Solution().strStr(haystack, needle);
   EXPECT_EQ(expected, actual);
}

TEST(strStr, HayStackEmptyNonEmptyNeedle)
{
   string haystack = "";
   string needle = "a";
   int expected = -1;
   int actual = Solution().strStr(haystack, needle);
   EXPECT_EQ(expected, actual);
}