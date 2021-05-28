# Containerd for Docker :ship::whale:

> Containers

  [2]
  - What are containers?
  [3]
  - Containers are isolated workspaces & are implemented using Linux namespaces and cgroups
  [4]
  - Why we should use containers?
      * A container image format
      * A method for building container images (Dockerfile/docker build)
      * A way to manage container images (docker images, docker rm , etc.)
      * A way to manage instances of containers (docker ps, docker rm , etc.)
      * A way to share container images (docker push/pull)
      * A way to run containers (docker run)
  - These containers are managed by the **containerd** which is a container runtime.

> Container runtimes

  [5]
  - So, now what are container runtimes?
  [6]
  - container runtimes are those that actually **run containers** and might also support **image & API management** to the container.
  [7]
  [high-level]
  - We have 2 sections in container runtimes which are divided cos of their functionalities
  - high-level container runtimes & low-level container runtimes.
  - high-level container runtime usually sits top of the stack which is responsible for transport and management of container images and their management.
  - They can provide a daemon application and an API that remote applications can use to logically run containers and monitor them.
  - **containerd** actually comes into this category which uses **runc** for its low-level requirements.
  [low-level]
  - Low-level runtimes have a limited feature set and typically perform the low-level tasks for running a container.
  - These are usually implemented as simple tools or libraries that developers of higher level runtimes can use for the low-level features.
  - It actually creates required **cgroups** & **namespaces**, uses **unshare** to move to its own namespaces and at the end **cleans** up cgroups after command completes and no reference exists.

> containerd

[8]
- What is containerd?
[9]
- containerd is actually a high-level container runtime that came from Docker, and implements the CRI specification.
- It pulls images from registries, manages them and then hands over to a lower-level runtime, which actually creates and runs the container processes.
[10]
- Container daemon was originally built as an integration point for OCI runtimes like runc but over the past couple of years, it has added a lot of functionality to bring it up to par the needs of modern container platforms like Docker and Kubernetes.
- containerd was separated out of the Docker project, to make Docker more modular.
- Docker uses containerd internally itself. When you install Docker, it will also install containerd.
- containerd implements the Kubernetes Container Runtime Interface (CRI), via its cri plugin.
[11]
- After **docker** announced **containerd** as an open-source project that the industry can use as a common container runtime to build added value on top, many companies has started using in its stack.
- Because as it can be used to manage the container lifecycle including tasks such as image transfer, container execution, some storage and networking functions.
- It exposes a task API that lets users create a running task, have the ability to add interfaces to the network namespace, and then start the container’s process without the need for complex hooks in various points of a container’s lifecycle.
[12]
- So, containerd in a nutshell is able to take care of container execution and supervision.
- push and pull functionalities as well as image management.  
- Also offers the container lifecycle APIs to create, execute, and manage containers and their tasks.
- It also provides features like network interfaces and management & local storage.
- Basically everything that you need to build a container platform without having to deal with the underlying OS details.
