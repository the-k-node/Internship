# Namespaces

- Namespaces are a **kernel mechanism for limiting the visibility that a group of processes has of the rest of a system**.

- The purpose of namespaces is to **wrap a particular global system resource** in an **abstraction** that makes it appear to the **processes** within the namespace that they have their own **isolated instance of the global resource**.

- _For example - you can limit visibility to certain process trees, network interfaces, user IDs or filesystem mounts._

- namespaces were originally developed by **Eric Biederman**, and the final major namespace was merged into **Linux 3.8**.

- **Example:** Docker Containers

  - When we run a container, docker creates a set of **namespaces** for that container.
  - They use these namespaces to provide a **layer of isolation**.
  - Docker triggers `dockerd` daemon for each **docker client** command, and creates `containers` with the help of `containerd` which inturn calls `unshare` syscall for isolating the namespaces for the container.
  - i.e **docker client -> dockerd -> containerd -> container -> unshare syscall**
  - It uses,

    - **pid** - process id: process isolation.
    - **net** - networking: managing network interfaces.
    - **ipc** - interprocess communication: managing access to IP resources.
    - **mnt** - mount: managing file system mps.
    - **uts** - unix timesharing system: kernel & version identifiers isolation.

    namespaces.
