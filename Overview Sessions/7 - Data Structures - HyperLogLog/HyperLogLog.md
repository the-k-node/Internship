# HyperLogLog :bookmark_tabs:

- **HyperLogLog** is an algorithm for the _count-distinct problem_, approximating the number of **distinct elements in a multiset**.

### What led to `HLL`? :thinking:

- The amount of **memory and computation** required to count the distinct elements in a large dataset grows bigger.
- A common example of this is, “How many unique visitors have visited facebook today?” or "How many unique searches did google get today?".
- Obvious approaches, such as sorting the elements or simply maintaining the set of unique elements seen, are impractical because they are either too computationally intensive or demand too much memory.

### Solution  :test_tube:

### Summary
- HyperLogLog uses very **little memory or CPU**.
- There’s no practical limit to how many items you can count with it.
- It’s a probabilistic counter, usually accurate within 2%.
- It counts the number of trailing zeroes in some unique ID.
- Bucketing results, then throwing out the top 30% gives us better answers by removing outliers.
