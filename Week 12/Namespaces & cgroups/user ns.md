# User Namespace - _user_

> Constant - **CLONE_NEWUSER**

- It isolates the **user** and **group ID number spaces**, in other words, a **process's user and group IDs can be different inside and outside a user namespace**.
- Normally, in order to **track** the file permissions correctly in a system, there is a **process of mapping the user name to a specific user identification (UID) number**.
- This UID is then applied to the **metadata** of the file which provides us a **single point for any future operations**.
- An unique case here is that a process can have a normal **unprivileged user ID outside a user namespace** while at the same time having a **user ID of _0_ inside the namespace**.
- This means that the process has **full root privileges for operations inside the user namespace**, but is **unprivileged for operations outside the namespace**.
