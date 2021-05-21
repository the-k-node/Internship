# InterProcess Communication Namespace - _ipc_

> Constant - **CLONE_NEWIPC**

- It isolates certain **interprocess communication (IPC) resources**, namely, **System V IPC objects**.
- The common characteristic of these IPC mechanisms is that IPC objects are **identified by mechanisms other than filesystem pathnames**.

- **System V IPC** is the name given to **three interprocess communication mechanisms** that are widely available on UNIX systems:

  1. **message queues**:

    ```
    - message queues allow data to be exchanged in units called messages.
    - Each messages can have an associated priority.
    ```

  2. **semaphore** -

    ```
    - semaphores allow processes to synchronize their actions.
    - semaphores are allocated in groups called sets.
    - each semaphore in a set is a counting semaphore.
    ```

  3. **shared memory** -

    ```
    - shared memory allows processes to share a region a memory - a "segment"
    ```

- Each IPC namespace has its **own set of System V IPC identifiers**.

- Objects created in an IPC namespace are **visible** to all other processes that are **members of that namespace**, but are **not visible** to processes in **other IPC namespaces**.

- When an IPC namespace is **destroyed** i.e., when the **last process** that is a member of the namespace **terminates**, all IPC objects in the namespace are **automatically destroyed**.
