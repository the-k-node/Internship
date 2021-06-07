# HyperLogLog

- HyperLogLog is an algorithm that lets us make a good guess at counting huge numbers of distinct elements, with very little computation or memory resources required.
- So, it's an algorithm for the _count-distinct problem_, approximating the number of **distinct elements in a multiset**.
- Actually, Multiset in mathematics is a **generalization of the concept of a set**. It’s a collection of unordered numbers (or other elements), where every element occurs a finite number of times, in other words, repetition of elements is allowed.
- HyperLogLog is an algorithm that lets us make a good guess at counting huge numbers of distinct elements, with very little computation or memory required.
- It’s fast and it’s lightweight, hence it comes with a cost to pay of an imperfect result and has a margin of 2% error.
- This means the result is no more than 2% away from the actual answer, which may be acceptable for your situation. For example, Reddit uses HyperLogLog to store view counts on posts.
- Before solution, what was the problem?

>- What led to HyperLogLog?

- Counting how many distinct elements are in a large dataset is surprisingly difficult problem.
- As the dataset grows bigger, the amount of memory and computation required to count the distinct elements in it grows.
- A common example of this is, “How many unique visitors have visited facebook today?” or "How many unique searches did google get today?".
- Note how we want unique & distinct values. We can't just have a counter that goes up by one with each page-view or anything easily.
- Obvious approaches, such as sorting the elements or simply maintaining the set of unique elements seen, are impractical because they are either too computationally intensive or demand too much memory.

> Solution :test_tube:

- To find our answer, we want an algorithm that outputs an estimate. That estimate may be in error, but it should be within a reasonable margin. First, we generate a hypothetical data set with repeated entries as such:

    1. Generate n numbers evenly distributed between 0 and 1.
    2. Randomly replicate some of the numbers an arbitrary number of times.
    3. Shuffle the above data set in an arbitrary fashion.

- Since the entries are evenly distributed, we can find the minimum number **(x_{min})** in the set and estimate the number of unique entries as **1/x_{min}**.
- However, to ensure that the entries are evenly distributed, we can use a hash function and estimate the cardinality from the hashed values instead of from the entries themselves.
- The graph below illustrates a simple example in which the hashed values are normalized and uniformly distributed between 0 and 1.
![dis_graph](https://engineering.fb.com/wp-content/uploads/2018/12/HLL22.png)
- In this, we use a hash function probably a mod function to decrease the range of each element to range between 0 to 1.
- Although its straightforward, this procedure has a high variance because it relies on the minimum hashed value, which may be happen to be too small, thus inflating our estimate.


> Probabilistic counting

- To reduce the high variability in previous method, we can use an improved pattern by counting the number of zero bits at the beginning of the hashed values.
- This pattern works because the probability that a given hash(x) ends in at least i zeros is 1/2^i.
- The figure below illustrates an example of the probability of observing a sequence of three consecutive zeros.
![prob_diag](https://engineering.fb.com/wp-content/uploads/2018/12/HLL31.png)

- In other words, on average, a sequence of k consecutive zeros will occur once in every 2^k distinct entries.
- To estimate the number of distinct elements using this pattern, all we need to do is record the length of the longest sequence of consecutive zeros.
- Mathematically speaking, if we denote (rho) `p(x_i)` as the number of consecutive zeros in `hash(x_i)`, the cardinality of the set `{x_1, x_2, ..., x_M}` is `2^R`, where
```
R = max(p(x_1), p(x_2), ..., p(x_M)).
```

- **But**, *There are two disadvantages to this method:*

  1. At best, this can give us a power of two estimate for the cardinality and nothing in between. Because of `2^R` in the above formula, the resulting cardinalities can only be one of `{1, 2, 4, 8, 16, 32, ..., 1024, 2048, 4096, ...}`.
  2. The estimator still has high variability. Because it’s recording the maximum `p(x_i)`, it requires only one entry whose hash value has too many consecutive zeros to produce a drastically inaccurate (overestimated) estimate of cardinality.

- On the plus side, the estimator has a very small memory footprint. We record only the maximum number of consecutive zeros seen. So to record a sequence of leading zeros up to 32 bits, the estimator needs only a 5-bit number for storage.

> Improving accuracy: LogLog

- In order to improve the estimate, we can store many estimators instead of one and average the results.
- This is illustrated in the graph below, where a single estimator’s variance is reduced by using multiple independent estimators and averaging out the results.
![imp_loglog](https://engineering.fb.com/wp-content/uploads/2018/12/HLL51.png)
- We can achieve this by using m independent hash functions: `{h_1(x), h_2(x), ..., h_m(x)}`.
- Having obtained the corresponding maximum number of consecutive zeros for each one: {R_1, R_2, ..., R_m}, our estimator becomes ![2pow](https://s0.wp.com/latex.php?latex=2%5E%7B%5Cbar%7BR%7D%7D+%3D+2%5E%7B%5Cfrac%7B1%7D%7Bm%7D%5Cleft%28R_1%2B...%2BR_m%5Cright%29%7D&bg=f1f2f4&fg=000&s=1&c=20201002).

- However, this requires each input x_i to pass through a number of independent hash functions, which is computationally expensive.
- There is actually a workaround proposed by Durand and Flajolet is to use a single hash function but use part of its output to split values into one of many buckets. To break the input entry into m buckets, they suggest using the first few (k) bits of the hash value as an index into a bucket and compute the longest sequence of consecutive 0s on what is left (let’s denote the longest sequence as R).

- For example, assume the hash of our incoming datum looks like hash(input)=1011011101101100000. Let’s use the four leftmost bits (k = 4) to find the bucket index. The 4-bits are colored: 1011011101101100000, which tells us which bucket to update (1011 = 11 in decimal). So that input should update the 11th bucket. From the remaining, 1011011101101100000, we can obtain the longest run of consecutive 0s from the rightmost bits, which in this case is five. Thus, we would update bucket number 11 with a value of 5 as illustrated below, using 16 buckets.
![eg](https://engineering.fb.com/wp-content/uploads/2018/12/HLL5.png)

- By having m buckets, we are basically simulating a situation in which we had m different hash functions. This costs us nothing in terms of accuracy but saves us from having to compute many independent hash functions. This procedure is called stochastic averaging. Finally, the formula below is used to get an estimate on the count of distinct values using the m bucket values \{R_1, R_2,..., R_m\}.

    ![card](https://s0.wp.com/latex.php?latex=%5Ctext%7BCARDINALITY%7D_%7B%5Ctext%7BLogLog%7D%7D+%3D+%5Ctext%7Bconstant%7D+%5Ccdot+m+%5Ccdot+2%5E%7B%5Cfrac%7B1%7D%7Bm%7D%5Csum_%7Bj%3D1%7D%5EN+R_j%7D&bg=f1f2f4&fg=000&s=1&c=20201002)

- Statistical analysis has shown that the above estimator has a predictable bias towards larger estimates.
- Durand-Flajolet derived the constant=0.79402 to correct this bias (the algorithm is called LogLog).
- For m buckets, this reduces the standard error of the estimator to about ![sqrt](https://s0.wp.com/latex.php?latex=1.3%2F%5Csqrt%7Bm%7D&bg=f1f2f4&fg=000&s=1&c=20201002).
- Thus, with 2,048 buckets where each bucket is 5 bits , we can expect an average error of about 2.8 percent.
- 5 bits per bucket is enough to estimate cardinalities up to `2^{27}` per the original paper and requires only `2048 * 5 = 1.2 KB` of memory. That’s pretty good for basically 1 KB of memory.
