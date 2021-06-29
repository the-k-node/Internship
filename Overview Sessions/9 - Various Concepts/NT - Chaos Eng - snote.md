## Principles of CHAOS ENGINEERING

- Chaos Engineering is the discipline of experimenting on a system in order to build confidence in the system’s capability to withstand turbulent conditions in production.

- Advances in large-scale, distributed software systems are changing the game for software engineering.

- As an industry, we are quick to adopt practices that increase flexibility of development and velocity of deployment.

- An urgent question follows on the heels of these benefits: How much confidence we can have in the complex systems that we put into production?

- Even when all of the individual services in a distributed system are functioning properly, the interactions between those services can cause unpredictable outcomes.

- So, these unpredictable outcomes, compounded by rare but disruptive real-world events that affect production environments, make these distributed systems inherently chaotic.

- We need to identify weaknesses before they manifest in system-wide, aberrant behaviors.

- Systemic weaknesses could take the form of:
  - improper fallback settings when a service is unavailable.
  - retry storms from improperly tuned timeouts;
  - outages when a downstream dependency receives too much traffic;
  - cascading failures when a single point of failure crashes;
  - etc.

- We must address the most significant weaknesses proactively, before they affect our customers in production.
- We need a way to manage the chaos inherent in these systems, take advantage of increasing flexibility and velocity, and have confidence in our production deployments despite the complexity that they represent.

- An empirical, systems-based approach addresses the chaos in distributed systems at scale and builds confidence in the ability of those systems to withstand realistic conditions.
- We learn about the behavior of a distributed system by observing it during a controlled experiment. We call this Chaos Engineering.

### CHAOS in practice

- To specifically address the uncertainty of distributed systems at scale, Chaos Engineering can be thought of as the facilitation of experiments to uncover systemic weaknesses. These experiments follow four steps:

- Start by defining ‘steady state’ as some measurable output of a system that indicates normal behavior.
- Hypothesize that this steady state will continue in both the control group and the experimental group.
- Introduce variables that reflect real world events like servers that crash, hard drives that malfunction, network connections that are severed, etc.
- Try to disprove the hypothesis by looking for a difference in steady state between the control group and the experimental group.
- The harder it is to disrupt the steady state, the more confidence we have in the behavior of the system. If a weakness is uncovered, we now have a target for improvement before that behavior manifests in the system at large.

---

# Testing in Production

## What Is Testing in Production?

- Testing in production (TIP) is a software development practice in which new code changes are tested on live user traffic rather than in a staging environment.

- It is one of the testing practices found in continuous delivery.

- Production software is the version of software that is released live to real users. In contrast, development, staging or pre-production software is in the process of being built and is not yet available to end users.

## Why Test in Production

- Historically, companies have tried to ensure that the software they build has been thoroughly tested for bugs in development, staging and pre-production environments, well before it reaches users in production. Catching bugs early prevents users from seeing errors, increasing customer trust and overall satisfaction with a brand and its products.

- However, catching all bugs in development and staging is not easy. Engineering and QA teams can spend a lot of time and effort building unit tests, test suites and test automation systems, trying to simulate the production environment, or manually verifying user flows with mock user data and test cases to try to expose bugs only to find out that a key corner-case was overlooked.

- In the end, many users may experience buggy software even after a large amount of time is spent testing in development.

- In many instances it is impossible to completely simulate live, real-world software in a test environment. With all the dependencies present in modern production systems and the many possible edge cases, production testing has become a necessary part of devops and software testing.

- Top software companies such as Google, Netflix, and Amazon constantly release new features to a fraction of their traffic measure the impact.

## Production Testing & Feature Flags

- With the advance of feature flags (a.k.a. feature toggles and feature rollouts) that allow engineering teams to expose new software to only fractions of live production traffic, companies can put experimental or new features in front of a small portion of their production traffic to quickly verify their software works as expected in real-time while having a safe way to roll back any uncaught bugs using a feature flag kill switch or rollback.

- Running tests in production via roll outs or feature flags allows for all the product data, dependencies and edge cases to be accounted for in comprehensive integration tests.

- Having real-world data, can be especially powerful when doing performance testing or load testing.

- Feature flag tooling also have the added benefit of allowing for a/b testing, where the new feature is compared against the previous version of the software to see which one results in a better user experience based on production data.

- This allows software engineers to not just ensure that their new features are bug free, but also uses real data to validate that the change actually improves their overall software experience.