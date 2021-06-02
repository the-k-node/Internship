# Kernel :penguin:

- Similar to GRUB, kernel is also loaded in stages.
- A linux kernel is responsible for handling Process management, Memory Management, Users, IPC etc.
- Actually what the kernel does is, maintain a good environment for programs to run.
- Kernel is basically a compressed image file. The location of this compressed kernel image is specified in the grub.conf file.
- Kernel actually mounts the root file system as specified in the “root” key in grub.conf and also executes the /sbin/init program.
- Since init was the 1st program to be executed by Linux Kernel, it has the process id (PID) of 1.
- Do a `ps -ef | grep init` and check the pid.
- `initrd` is sometimes called as **initial root file system**.
- This is used by the kernel before the real root file system is mounted.  
- Initrd is available in the form of an image similar to the kernel image file and can find both initrd & kernel image files in the /boot directory.
