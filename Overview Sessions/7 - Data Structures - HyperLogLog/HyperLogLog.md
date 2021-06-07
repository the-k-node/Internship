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
- If `p(x_i)` is number of consecutive zeros in `hash(x_i)`, the **cardinality** of the set `{x_1, x_2, ..., x_M}` is `2^R`, where
```
R = max(p(x_1), p(x_2), ..., p(x_M)).
```

- **But**, *There are two disadvantages to this method:*

  1. Gives only powers of **2** cardinalities, the resulting cardinalities can only be one of `{1, 2, 4, 8, 16, 32, ..., 1024, 2048, 4096, ...}`.
  2. Still has high variability, might produce a **drastically inaccurate (overestimated) estimate of cardinality**.

- On the plus side, the estimator has a very small memory footprint.
- To record a sequence of leading zeros up to `32 bits`, the estimator needs only a `5-bit` number for **storage**.

> Improving accuracy: LogLog

- In order to improve the estimate, we can store many estimators instead of one and average the results.
![imp_loglog](https://engineering.fb.com/wp-content/uploads/2018/12/HLL51.png)
- We can achieve this by using m independent hash functions: `{h_1(x), h_2(x), ..., h_m(x)}`.
- For `{R_1, R_2, ..., R_m}`, our estimator becomes ![2pow](https://s0.wp.com/latex.php?latex=2%5E%7B%5Cbar%7BR%7D%7D+%3D+2%5E%7B%5Cfrac%7B1%7D%7Bm%7D%5Cleft%28R_1%2B...%2BR_m%5Cright%29%7D&bg=f1f2f4&fg=000&s=1&c=20201002).

- However, this requires each input `x_i` to pass through a number of independent hash functions, which is computationally expensive.

- **Durand and Flajolet** has proposed a solution to use a single hash function but use part of its output to split values into one of many buckets.
- To break the input entry into `m` buckets, they suggest using the first few (`k`) bits of the hash value as an index and compute the longest sequence of consecutive 0s on what is left.

- For example, assume the hash of our incoming datum looks like `hash(input)=1011011101101100000`.
- Let’s use the four leftmost bits `k = 4` to find the bucket index.
- The `4-bits` are colored: `red`, which tells us which bucket to update (1011 = `11`).
- So that input should update the 11th bucket.
- From the remaining, `011101101100000`, we can obtain the longest run of consecutive 0s from the rightmost bits, which in this case is **five**.
- Thus, we would update bucket number 11 with a value of 5 as illustrated below, using 16 buckets.
![eg](https://engineering.fb.com/wp-content/uploads/2018/12/HLL5.png)

- This costs us nothing in terms of accuracy but saves us from having to compute many independent hash functions.
- This procedure is called **stochastic averaging**.
- Finally, the formula below is used to get an estimate on the count of distinct values using the m bucket values `{R_1, R_2,..., R_m}`.

    ![card](https://s0.wp.com/latex.php?latex=%5Ctext%7BCARDINALITY%7D_%7B%5Ctext%7BLogLog%7D%7D+%3D+%5Ctext%7Bconstant%7D+%5Ccdot+m+%5Ccdot+2%5E%7B%5Cfrac%7B1%7D%7Bm%7D%5Csum_%7Bj%3D1%7D%5EN+R_j%7D&bg=f1f2f4&fg=000&s=1&c=20201002)

- Statistical analysis has shown that the above estimator has a predictable bias towards larger estimates.
- **Durand-Flajolet** derived the **constant=0.79402** to correct this bias.
- For `m` buckets, this reduces the standard error of the estimator to about ![sqrt](https://s0.wp.com/latex.php?latex=1.3%2F%5Csqrt%7Bm%7D&bg=f1f2f4&fg=000&s=1&c=20201002).
- Thus, with `2,048` buckets where each bucket is `5` bits , we can expect an average error of about `2.8` percent.
- 5 bits per bucket is enough to estimate cardinalities up to `2^27` per the original paper and requires only `2048 * 5 = 1.2 KB` of memory.
