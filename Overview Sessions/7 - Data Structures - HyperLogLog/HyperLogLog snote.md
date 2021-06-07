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
- Mathematically speaking, if we denote \rho(x_i) as the number of consecutive zeros in hash(x_i), the cardinality of the set \{x_1, x_2, ..., x_M\} is 2^R, where R = \max\left(\rho(x_1), \rho(x_2), ..., \rho(x_M)\right).

There are two disadvantages to this method:

At best, this can give us a power of two estimate for the cardinality and nothing in between. Because of 2^R in the above formula, the resulting cardinalities can only be one of \{1, 2, 4, 8, 16, 32, ..., 1024, 2048, 4096, ...\}.
The estimator still has high variability. Because it’s recording the maximum \rho(x_i), it requires only one entry whose hash value has too many consecutive zeros to produce a drastically inaccurate (overestimated) estimate of cardinality.
On the plus side, the estimator has a very small memory footprint. We record only the maximum number of consecutive zeros seen. So to record a sequence of leading zeros up to 32 bits, the estimator needs only a 5-bit number for storage.