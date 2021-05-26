# Mount Namespace - _mnt_

> Constant - **CLONE_NEWNS**

- It isolates the set of **filesystem mount points** seen by a group of processes.
- Processes in different _mount_ namespaces can have **different views of the filesystem hierarchy**.
- The **mount()** and **umount()** system calls ceased operating on a _global set of mount points visible to all processes on the system_ and instead performed operations that **affected just the mount namespace associated with the calling process**.
- As far as the _namespace is concerned_, it is at the **root of the file system**, and **nothing else exists**.
- However, we can **mount portions of an underlying file system** into the **mount namespace**, thereby allowing it to see additional information.

- Usage Example:

  - Separate mount namespaces can be set up in a **master-slave relationship**, so that the **mount events are automatically propagated from one namespace to another**.
  - This allows, for example, _an optical disk device that is mounted in one namespace to automatically appear in other namespaces_.

- Usage Example 2:

  - mount namespaces is to **create environments that are similar to chroot jails**.
  - But with the use of the **chroot()** system call, mount namespaces are a **more secure and flexible tool** for this task
