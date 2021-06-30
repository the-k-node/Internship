# **CHAOS Engineering**

First thing comes to mind is ...
<p>
    <img src="https://media.giphy.com/media/137TKgM3d2XQjK/giphy.gif" width="300"/>
</p>
Yeah... it might be correct but in a different way.

First of all, here's a "quote" said by Jedi master to all Youngling Padawans ...

<p>
    <img src="https://memegenerator.net/img/instances/53037991/create-order-from-chaos-you-must.jpg" width="400"/>
</p>

## **Overview**

- **Chaos Engineering** is the discipline of **experimenting on a system** in order to build **confidence** in the system’s **capability to withstand turbulent conditions in production**.

- Advances in large-scale, **distributed software systems** are changing the game for **software engineering**.

- As an industry, we are quick to adopt practices that increase **flexibility** and **velocity** of deployment.

!!! danger Problem
    - Interactions between individual services can cause **unpredictable outcomes**.

    !!! info Unpredictable Outcomes
        They are compounded by **rare but disruptive real-world events** that **affect** production environments, make these distributed systems inherently **chaotic**.

    - **Systemic weaknesses**:
      - **improper fallback settings** when a service is *unavailable*,
      - retry storms from **improperly tuned timeouts**,
      - **outages** when a downstream dependency receives too much **traffic**,
      - **cascading failures** when a single point of failure **crashes**,

<br/>

## **CHAOS in practice**

- To specifically address the **uncertainty of distributed systems at scale**, Chaos Engineering can be thought of as the **facilitation of experiments** to uncover systemic **weaknesses**.

- These experiments follow four steps:

!!! note Steps for Solution
    1. Start by defining ‘**steady state**’ as some measurable **output** of a system that indicates **normal** behavior.
    2. Hypothesize that this steady state will continue in both the **control** group and the **experimental** group.
    3. Introduce variables that **reflect real world events** like servers that **crash**, hard drives that **malfunction**, network connections that are **severed**, etc.
    4. Try to disprove the hypothesis by looking for a **difference** in steady state **between the control group and the experimental group**.

!!! success Solution
    - The **harder** it is to disrupt the steady state, the **more confidence** we have in the behavior of the system.
    - If a **weakness** is uncovered, we now have a **target** for improvement before that behavior manifests in the system at large.

<p>
    <img src="https://media.giphy.com/media/d3mlE7uhX8KFgEmY/giphy.gif" width="300"/>
</p>