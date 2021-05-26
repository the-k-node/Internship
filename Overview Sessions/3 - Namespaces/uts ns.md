# Unix Timesharing System Namespace - _uts_

> Constant - **CLONE_NEWUTS**

- It isolates two system identifier _**nodename**_ and _**domainname**_ returned by the **uname()** system call.
- The names are set using the **sethostname()** and **setdomainname()** system calls.
- The term **"UTS"** is derived from the name of the structure passed to the **uname()** system call: `struct utsname`.
- The name of that structure in turn derives from "UNIX Time-sharing System".

- **Example**: Containers

  - In the context of containers, the UTS namespaces feature allows each container to have its own **hostname** and **NIS domain name**.
  - This can be useful for **initialisation and configuration scripts** that tailor their actions based on these names.

- Usage Example:

  - Searching through log files is much easier when identifying a hostname rather than IP addresses and ports.
  - Also in a dynamic environment, IPs can change.
