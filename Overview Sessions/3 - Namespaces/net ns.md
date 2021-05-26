# Network Namespace - _net_

> Constant - **CLONE_NEWNET**

- It provides the **isolation of the system resources associated with networking**.
- So, each network namespace has its **own network devices, IP addresses, IP routing tables, port numbers**, /proc/net directory and so on.
- Network namespaces allow processes inside each namespace instance to have **access to a new IP address** along with the **full range of ports**.
- In containers, each container can have its **own (virtual) network device** and its **own applications that bind to the per-namespace port numbers**.
- Suitable routing rules in the host system can **direct network packets to the network device associated with a specific container**.
- Hence, it is possible to have **multiple containerized web servers on the same host system**, with **each server bound to same port number (like port 80)** in its **own (per-container) network namespace instance**.
