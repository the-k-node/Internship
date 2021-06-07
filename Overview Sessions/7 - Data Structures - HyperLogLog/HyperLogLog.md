# HyperLogLog :bookmark_tabs:

- **HyperLogLog** is an algorithm for the _count-distinct problem_, approximating the number of **distinct elements in a multiset**.

### What led to `HLL`? :thinking:

- The amount of **memory and computation** required to count the distinct elements in a large dataset grows bigger.
- A common example of this is, “How many unique visitors have visited facebook today?” or "How many unique searches did google get today?".
- Obvious approaches, such as sorting the elements or simply maintaining the set of unique elements seen, are impractical because they are either too computationally intensive or demand too much memory.

### Solution  :test_tube:

> A Simple Estimator

- We want an algorithm that outputs an estimate.
- That estimate may be in error, but it should be within a reasonable margin.
- First, we generate a hypothetical data set with repeated entries as such:

    1. **Generate n numbers ->  >0 & <1.**
    2. **Replicate some of the numbers.**
    3. **Shuffle the data set.**

- Minimum number **(x_min)** in the set and estimate the number of unique entries as **1/x_min**.
- Ensure that the entries are evenly distributed - hash function and estimate the cardinality from the hashed values instead of from the entries themselves.
- The graph below illustrates a simple example in which the hashed values are normalized and uniformly distributed between 0 and 1.
![dis_graph](https://engineering.fb.com/wp-content/uploads/2018/12/HLL22.png)
- **Problem** - high variance because it relies on the minimum hashed value & might inflate our estimate.

> Probabilistic counting

- Improved pattern by **counting the number of zero bits at the beginning of the hashed values**.
- Probability that a given `hash(x)` ends in at least `i` zeros is `1/2^i`.
- The figure below illustrates an example of the probability of observing a sequence of three consecutive zeros.
![prob_diag](https://engineering.fb.com/wp-content/uploads/2018/12/HLL31.png)

- On average, a sequence of **k** consecutive zeros will occur once in every **2^k** distinct entries.
- Hence number of distinct entries ~  record the length of the longest sequence of consecutive zeros.

### Summary
- HyperLogLog uses very **little memory or CPU**.
- There’s no practical limit to how many items you can count with it.
- It’s a probabilistic counter, usually accurate within 2%.
- It counts the number of trailing zeroes in some unique ID.
- Bucketing results, then throwing out the top 30% gives us better answers by removing outliers.
