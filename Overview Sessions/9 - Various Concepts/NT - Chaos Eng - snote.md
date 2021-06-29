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