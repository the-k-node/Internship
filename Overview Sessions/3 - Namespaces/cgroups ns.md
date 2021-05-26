# CGroups Namespace - _cgroups_

> Constant - **CLONE_NEWCGROUP**

- cgroups, which stands for control groups, are a **kernel mechanism for limiting and measuring the total resources** used by a group of processes running on a system.
- Using cgroups we can **allocate resources such as CPU, memory, network or IO quotas**.
- A cgroup namespace **virtualizes the contents** of the `/proc/self/cgroup` file.
- Processes inside a cgroup namespace are only able to **view paths relative to their namespace root**.
- Each process is a **child to a parent** and **relatively descends from the `init` process**.
- cgroups are **hierarchical**, where **child cgroups inherit the attributes of the parent**, but we can have multiple **cgroup hierarchies within a single system**.

- **Example**: Containers

  - Applying cgroups on namespaces results in **isolation of processes into containers** within a system, where resources are managed distinctly.
  - Each **container is a lightweight virtual machine**, all of which run as **individual entities** and are not aware of other entities within the same system.
