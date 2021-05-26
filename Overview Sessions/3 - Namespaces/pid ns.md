# Process ID Namespace - _pid_

> Constant - **CLONE_NEWPID**

- It isolates the **process ID number space** or in other words, **processes in different PID namespaces can have the same PID**.
- PID namespaces also allow each container to have its own **init - PID 1**, the **"ancestor of all processes"** that _manages various system initialization tasks and reaps orphaned child processes when they terminate_.
- In a **PID namespace instance**, a process has **two PIDs**: the **PID inside the namespace**, and the **PID outside the namespace on the host system**.
- **PID namespaces can be nested**, a process will have **one PID for each of the layers of the hierarchy** starting from the **PID namespace in which it resides** through to the **root PID namespace**.
- A process can see only processes contained in its **own PID namespace** and the **namespaces nested below that PID namespace**.

- Example:

  - One of the main benefits of PID namespaces is that **containers can be migrated between hosts while keeping the same process IDs for the processes inside the container**.
