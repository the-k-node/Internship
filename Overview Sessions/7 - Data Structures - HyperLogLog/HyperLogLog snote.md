# HyperLogLog

- HyperLogLog is an algorithm that lets us make a good guess at counting huge numbers of distinct elements, with very little computation or memory resources required.
- So, it's an algorithm for the _count-distinct problem_, approximating the number of **distinct elements in a multiset**.
- Actually, Multiset in mathematics is a **generalization of the concept of a set**. It’s a collection of unordered numbers (or other elements), where every element occurs a finite number of times, in other words, repetition of elements is allowed.
- Before solution, what was the problem?

>- What led to HyperLogLog?

- Counting how many distinct elements are in a large dataset is surprisingly difficult problem.
- As the dataset grows bigger, the amount of memory and computation required to count the distinct elements in it grows.
- A common example of this is, “How many unique visitors have visited facebook today?” or "How many unique searches did google get today?".
- Note how we want unique & distinct values. We can't just have a counter that goes up by one with each page-view or anything easily.
- Obvious approaches, such as sorting the elements or simply maintaining the set of unique elements seen, are impractical because they are either too computationally intensive or demand too much memory.

> Solution :test_tube:

- HyperLogLog is an algorithm that lets us make a good guess at counting huge numbers of distinct elements, with very little computation or memory required.
- It’s fast and it’s lightweight, hence it comes with a cost to pay of an imperfect result and has a margin of 2% error.
- This means the result is no more than 2% away from the actual answer, which may be acceptable for your situation. For example, Reddit uses HyperLogLog to store view counts on posts.