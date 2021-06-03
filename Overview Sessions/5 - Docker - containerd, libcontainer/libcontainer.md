# libcontainer :file_cabinet::whale:

> libcontainer

- What is the libcontainer? Is it some kind of library for container?
- Libcontainer provides a standard interface to making sandboxes or containers inside an OS.
- Before the release of version 0.9, Docker used to use Linux Containers i.e LXC for short, as its default execution environment.
-  Now, LXC was made optional with Docker’s own **libcontainer** taking over as the default execution environment
- LXC was limited to Linux. It offered a userspace interface for the Linux kernel containment features.
- Libcontainer, on the other hand, is an abstraction that supports a broader range of isolation technologies.
- Another main advantage that libcontainer has over LXC is that it was developed to access the kernel’s container APIs directly to remove dependencies.
- This drastically reduces the number of moving parts, and insulates Docker from the side-effects of LXC.
- Using its libcontainer library, Docker can manipulate namespaces, control groups, capabilities, network interfaces, and firewall rules without relying on LXC and other external packages.
- Reduced dependencies make libcontainer more stable and efficient. - Libcontainer also allows for more reusability and is easier to adopt by other vendors as compared to LXC.
