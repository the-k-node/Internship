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
    - The simplest way to load balance network traffic to multiple servers is to use `layer 4` i.e **transport layer** load balancing.
    - Load balancing this way will forward **user traffic** based on **IP range and port**
      - eg: if a request comes in for `http://yourdomain.com/something`, the traffic will be forwarded to the backend that handles all the requests for `yourdomain.com` on port 80.
    - Here is a diagram of a simple example of layer 4 load balancing:
  ![layer4](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/8%20-%20Load%20Balancer%20-%20HAProxy/layer_4_load_balancing.png)
    - The user accesses the load balancer, which **forwards** the user’s **request** to the **web-backend** group of backend servers.
    - Whichever backend server is selected will respond **directly** to the user’s request.
    - All of the servers in the web-backend should be serving **identical content** otherwise the user might receive inconsistent content.
    - *Multiple web servers connect to the same database server*.

  - using mode `http` becomes `layer 7` proxy
    - More complex way to load balance network traffic is to use `layer 7` i.e **application layer** load balancing.
    - Using `layer 7` allows the load balancer to **forward requests to different backend servers** based on the **content of the user’s request**.
    - This mode of load balancing allows you to run **multiple web application servers** under the **same domain and port**.
    - Here is a diagram of a simple example of layer 7 load balancing:
  ![layer7](https://github.com/alwaysiamkk/Internship/blob/main/Overview%20Sessions/8%20-%20Load%20Balancer%20-%20HAProxy/layer_7_load_balancing.png)
    - In this example, if a user requests `yourdomain.com/blog`, they are forwarded to the `blog` backend, which is a set of servers that run a `blog` application.
    - Other requests are forwarded to **web-backend**, which might be running another application.
    - Both backends use the **same** database server.

- Example:
  - snippet of the example (layer 7 proxy) frontend configuration would look like this:
    ```
    frontend http
    bind *:80
    mode http

    acl url_blog path_beg /blog
    use_backend blog-backend if url_blog

    default_backend web-backend
    ```
    - This configures a frontend named `http`, which handles all incoming traffic on port 80.
    - `acl url_blog path_beg /blog` matches a request if the path of the user’s request begins with /blog.
    - `use_backend blog-backend if url_blog` uses the ACL to proxy the traffic to blog-backend.
    - `default_backend web-backend` specifies that all other traffic will be forwarded to web-backend.