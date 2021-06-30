# **Testing in Production**

<p float="left">
    <img src="https://media.giphy.com/media/LmNwrBhejkK9EFP504/giphy.gif" width="250" />
    <img src="https://media.giphy.com/media/V4NSR1NG2p0KeJJyr5/giphy.gif" width="270" />
    <img src="https://media.giphy.com/media/WQy9FkJlhGSwl3eQ5V/giphy.gif" width="270" />
</p>

## **What is Testing in Production?**

!!! info TIP
    **Testing in production** (**TIP**) is a **software development practice** in which new code changes are tested on **live user traffic** rather than in a staging environment. It is **one of the testing practices found in continuous delivery**.

- **Production software** is the version of software that is released **live** to real users. In contrast, **development, staging or pre-production software** is in the process of **being built** and is **not yet available to end users**.

## **Why Test in Production?**

- Catching all bugs in development and staging is **not** easy.

!!! danger Why's that?
    **Engineering** and **QA** teams can spend a lot of **time** and **effort** building **unit tests**, **test suites** and **test automation systems**, trying to **simulate** the **production environment**, or manually verifying **user flows** with mock user data and test cases to try to **expose bugs** only to find out that a key corner-case was **overlooked**.
- In the end, many users may experience **buggy software** even after a large amount of time is spent testing in development.
- In many instances it is **impossible to completely simulate live**, **real-world software** in a **test** environment.
- With all the **dependencies** present in modern **production systems** and the many **possible** edge cases, production testing has become a **necessary part** of devops and software testing.

Hence all companies are like
<p float="left">
    <img src="https://media.giphy.com/media/OqJp9fcjk9HpWBuF4u/giphy.gif" width="600"/>
</p>

- Top software companies such as Google, Netflix, and Amazon constantly release new features to a fraction of their traffic measure the impact.

## **Feature Flags**

!!! success Final Solution
    **Feature Flags** allow engineering teams to expose new software to only **fractions** of live production traffic, companies can put **experimental** or **new** features in front of a small portion of their production traffic to quickly verify their software **works as expected** in real-time while having a **safe way to roll back** any **uncaught bugs using a feature flag** kill switch or rollback.

- **Feature flag tooling** also have the added benefit of allowing for `a/b testing`, where the **new** feature is compared against the **previous** version of the software to see which one results in a **better user experience** based on **production data**.

- This allows software engineers to not just ensure that their new features are **bug free**, but also uses **real data** to validate that the change actually improves their overall software experience.