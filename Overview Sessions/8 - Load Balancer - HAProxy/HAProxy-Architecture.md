# HAProxy
---

### Overview
---

- **HAProxy** is a **TCP/HTTP** reverse proxy which is particularly suited for **high availability** environments.
- It has features like:
  - It needs very little **resources**.
  - route **HTTP requests** depending on statically assigned cookies.
  - **spread the load among several servers** while **assuring** server **persistence** through the use of HTTP cookies.
  - switch to **backup** servers in the event a **main one fails**.
  - **block** requests matching a particular pattern.
  - hold clients to the **right application server** depending on **application cookies**.

- Its **event-driven architecture** allows it to easily handle thousands of simultaneous connections on hundreds of instances without risking the system's stability.

### Architecture
---

- **Frontend** - anything in front of haproxy.
  - **Timeout client**.
  - **Bind**.
  - **ACL**.

- **Backend** - anything in back of haproxy.
  - **Timeout connect**.
  - **Timeout server**.
  - **Balance**.
    - eg: *roundrobin*, *leastconn*, *source*.

- **Multiple frontends** or **Multiple backends**.
- Frontend bind to **one or more ports**.
- A frontend **connects** to a backend
- Eg: Two frontends
  - frontend - **http**: binds `80`
    - *forwards* to *https* backend
  - frontend - **https**: binds `443`
- **Access Control List (ACL)**
    - ACLs are used to test some **condition** and perform an action based on the **test result**.
    - Use of ACLs allows **flexible network traffic forwarding** based on a variety of factors like **pattern-matching** and the **number of connections to a backend**, etc.

- Modes -
  - Frontend & Backend can have **mode** of protocol.
  - HAProxy has 2 modes
    - `tcp`
    - `http`
  - depending on the **mode** choosen, **proxy layer** gets changed.
  - using mode `tcp` becomes `layer 4` proxy
  ![layer4]()
  - using mode `http` becomes `layer 7` proxy