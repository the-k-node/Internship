# Linux boot process :penguin:

Following steps
1. BIOS (Basic input and output system)
2. MBR (Master boot record)
3. GRUB (Grand unified boot loader)
4. Kernel
5. Init
6. Runlevel program



![](https://static.thegeekstuff.com/wp-content/uploads/2011/02/linux-boot-process.png)

### a) SMPS (Switching Mode Power Supply )
- The primary objective of this component is to provide the perfect required voltage level to the motherboard and other computer components.
- SMPS converts AC to DC and maintain the required voltage level so that the computer can work
-  After power is supplied, SMPS checks the voltage level's its providing to the motherboard. If the power signal level is perfect, then SMPS will send a POWER GOOD signal to the motherboard timer.
- On receiving this POWER GOOD signal from SMPS, the motherboard timer will stop sending reset signal to the CPU. Which means the power level is good.

### b) Bootstrapping
- Something has to be programmed by default, so that the CPU knows where to search for instructions.
- This is an address location in the ROM. The address location is FFFF:0000h.
- This address location is the last region of the ROM. It only contains one instruction. The instruction is to jump to another memory address location. This JUMP command will tell the location of the BIOS program.

## 1. BIOS
- BIOS stands for Basic Input Output System.
- The most important use of BIOS during the booting process is POST. POST stands for Power on Self Test.
- Its a series of tests conducted by the bios, which confirms the proper functioning of different hardware components attached to the computer.
- POST is very important thing to have before the Operating system is loaded.  if  we have a faulty hard drive or faulty memory, sometimes the fault causes data corruption or data loss.
- After POST, all drivers are activated including the storage drivers, now the BIOS looks for bootloader in the floowing order.
	1. CD ROM
	2. HARD DISK
	3. USB
	4. Floppy Disk
> **How does the BIOS validate if a disk is bootable or not?** :thinking:

[reference]( https://superuser.com/questions/420557/mbr-how-does-bios-decide-if-a-drive-is-bootable-or-not#:~:text=The%20BIOS%20decides%20if%20a,at%20the%20446th%20byte)

- The BIOS decides if a drive is bootable based on the 16-byte partition record, present _after_ the MBR code area (held in a table starting at the 446th byte).
- The first byte in each partition record represents the drive's bootable status (and is set to `0x80` if bootable, `0x00` if not)
- If the flag is set ( the drive is bootable ) then the control is sent back to the start of the MBR code area of the same drive.
- if the flag is not set, the BIOS checks the other devices in the given order for a valid bootable disk ( set bootable flag )

## 2. MBR
- Assuming no bootloader is found in the above devices, BIOS is programmed to look at a permanent location on the hard disk to complete its task.
- This location is called a *Boot sector*, called MBR (Master Boot Record) which is the first sector of hard disk
- This is the location that contains the program that will help our computer to load the operating system.
- As soon as bios finds a valid MBR, it will load the entire content of MBR to RAM, and then further execution is done by the content of MBR.

- Quick look at the same
	- MBR stands for Master Boot Record.
	-   It is located in the 1st sector of the bootable disk. Typically /dev/hda, or /dev/sda
	-   MBR is less than 512 bytes in size. This has three components
		- primary boot loader info in 1st 446 bytes
		- partition table info in next 64 bytes
		- mbr validation check in last 2 bytes.
	- It contains information about GRUB (or LILO in old systems).
	-   So, in simple terms MBR loads and executes the GRUB boot loader.

## 3. GRUB :floppy_disk:

> Grand Unified Bootloader

- Its actually an impossible task to boot/start a Linux, or any other operating system, without the help of a boot loader.
- Boot loader plays a major role in bringing up the system into running state.
- Infact the boot loader is the first program, that runs, when a computer is switched on.
- Boot loader is the one, which transfers control to an operating system kernel.
- GRUB is the default boot loader, for many Linux distributions and stands for **Grand Unified Bootloader**.
- GRUB was actually the result of a troubleshooting done by **Erich Boleyn**, to boot `GNU Hurd` with a micro kernel.
- `GNU Hurd` is the operating system which was designed by GNU, as a **free replacement of UNIX**.
- **Yoshinori K. Okuji** carried further work to advance the initial GRUB, and is called GRUB2.
- The older version of GRUB(before grub2), is now called as **GRUB-Legacy**.
- Grub has got several added advantages, compared to previous boot loaders, and also many **Proprietary boot loaders**.
- Grub can be used to load almost all operating systems.
- Grub **does not require** the exact physical location of the operating system kernel in the hard disk. It just requires the **hard disk number**(like the first hard disk,second hard disk), and the **partition number**, along with the **file name of the kernel**. Because, GRUB understands the **format in which kernel is made**.
- First `440 bytes` of total `512 bytes` of MBR's sector 1 will have GRUB first boot stage.
- The primary job of the stage 1 bootloader is to load the second stage boot loader. The second stage boot loader is the stage 2 grub, that actually does the job of loading the kernel and other `initrd` image files and GRUB is the combined name given to different stages of grub.
- There are actually not two stages but 3 stages of grub in total. The three stages are:
    - GRUB Stage 1
    - GRUB Stage 1.5
    - GRUB Stage 2
![GRUB stages](https://www.linuxnix.com/wp-content/uploads/2013/04/Linux-Booting-process.png)
- Now, where does the stage `1.5` comes from?
- Usually, the hard disk sectors are counted from 0 to the last sector. So the first sector i.e sector 0 contains the GRUB stage 1.
- Normally partititons will not start before sector 63. Hence we have sectors from 1-63 free.
- This space is used for storing GRUB stage 1.5. This free space between MBR and the beginning of the partitions is called as **MBR GAP**.
- Now you might think what is the requirement of an additional stage in grub.
- Actually, Grub Stage 1.5 located in the MBR GAP basically contains the drivers for reading file systems.
- So grub stage 1 will load grub stage 1.5 to the RAM, and will pass the control to it.
- Now grub stage 1.5 will load the file system drivers and once the file system drivers are loaded, it can now access /boot/grub/grub.conf file which contains other details about kernel path, initrd path, etc.
- If you have multiple kernel images installed on your system, you can choose which one to be executed.
- GRUB displays a splash screen, waits for few seconds, if you don’t enter anything, it loads the default kernel image as specified in the grub configuration file.
- GRUB has the knowledge of the filesystem (the older Linux loader LILO didn’t understand filesystem).
- Grub configuration file is /boot/grub/grub.conf (/etc/grub.conf is a link to this). The following is sample grub.conf of CentOS.
    ```
    #boot=/dev/sda
    default=0
    timeout=5
    splashimage=(hd0,0)/boot/grub/splash.xpm.gz
    hiddenmenu
    title CentOS (2.6.18-194.el5PAE)
              root (hd0,0)
              kernel /boot/vmlinuz-2.6.18-194.el5PAE ro root=LABEL=/
              initrd /boot/initrd-2.6.18-194.el5PAE.img
    ```
- As you can notice from the above information, it contains all required details like sector from where `grub stage 1` starts, kernel image, and initrd image.
- So, in a nutshell GRUB just loads and executes Kernel and initrd images.

## 4. Kernel :penguin:

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


## 5. Init :one: & 6. Runlevel :runner: :running:
> Pre init process

The **initrd** and **initramfs** are two different methods by which the temporary file system is made available to the kernel.**Initrd** (Initial ramdisk) was the technique used with earlier linux distros where the compressed image of the entire file system (initrd image) is made available as a special block storage device (**`/dev/ram`**) which is then mounted and decompressed.   
The driver software to access this block storage device is compiled into the kernel. The kernel assumes that the actual file system is mounted and starts `/linuxrc` which in turn starts `/sbin/init`.  
- **Linuxrc** is a program used for setting up the kernel for installation purposes. It allows the user to load modules, start an installed system, a rescue system.   
- **Linuxrc** is designed to be as small as possible. Therefore, all needed programs are linked directly into one binary.  
- `/sbin/init` is the executable starting the **SysV** initialization system.  
- `/sbin/init` is a symlink to `/lib/systemd/systemd`  
 ```bash  
stat /sbin/init  
```
With Initramfs the compressed image is made available as a **cpio** archive which is unpacked by the kernel using a temporary instance of **tempfs** which then becomes the **root file system**.   
It is followed by executing **`/init`** as the first process.  
- **cpio** stands for "copy in, copy out".  
- **tmpfs** is intended to be for temporary storage that is very quick to read and write from and does not need to persist across operating system reboots.   
- **tmpfs** is **used in** Linux for /run, /var/run and /var/lock to provide very fast access for runtime data and lock files.
>Init 	Process

**Init**   
Initialization

It is the parent of all processes, executed by the kernel during the booting of a system.   
- Its principle role is to create processes from a script stored in the file **`/etc/inittab`**. The **init** is a daemon process which starts as soon as the computer starts and continue running till, it is shutdown  having "**pid=1**".  
- If somehow **init** daemon could not start, no process will be started and the system will reach a stage called **Kernel Panic**, which is one of the drawback. init is most commonly referred to as **System V init**.
- System V -> first commercial UNIX Operating System designed.The OS is booted with the desired runlevel or target.Once the actual file system is mounted, the runlevel is identified.
- There are 7 runlevels associated with Init:
	0. **Shutdown or halt** -> Shuts down system
	1. **Single user mode** (root user mode) -> Does not configure network interfaces, start daemons,
	2. **Multiuser without network service** -> Does not configure network interfaces or start daemons.
	3. **Multiuser with network service** -> Starts the system normally. `Default`
	4. **Undefined** -> Not used/User-definable ,configured to provide a custom boot state.
	5. **Graphical mode** -> Starts the system normally with GUI.
	6. **Reboot** -> Reboots the system

The main configuration file is `/etc/inittab`. The default runlevel is specified here.  
The scripts required by each runlevel is specified in **`/etc/rc.d/rc*`** directory  
- One could find a list of **kill (K)** scripts and **start (S)** script. The kill scripts are executed followed by start scripts, along with sequence number in which the programs should be started or killed.

**Systemd**  
(System Management Daemon)

It is based on parallel booting concept where processes and services are started in parallel, speed up the booting process.  
In Systemd there are no runlevels involved, instead target unit files come into play. Unit files are configuration files what define any entity in systemd environment  
**Unitfiles** -> services, targets, devices, file system mount points and sockets.

The targets in systemd are :

   0. **poweroff.target**   
   1. **rescue.target**   
   2. **multi-user.target**   
   3. **graphical.target**    
   4. **reboot.target**

- In Systemd `/sbin/init` is simlinked to **`/etc/systemd/system/default.target`**.  
- The default.target file is empty and is simlinked with the presently chosen target file located at **`/usr/lib/systemd/system/<target name>.target`**.  
- Advantage is that if the main service fails the dependent services are bypassed  
- It uses `wanted`,` requires`,`before`,`after` for adding a specific service in systemd   
	- **`: <target-name>.target.wants`**
### Comparison of Sys V Run Levels with Target
Unitsrunlevel0.target **<=>** poweroff.target    
runlevel1.target **<=>** rescue.target   
runlevel[234] **<=>** target, multi- user.target  
runlevel5.target **<=>** graphical.target   
runlevel6.target **<=>** reboot.target

Init works based on serial booting principle, so even if the main service fails the sub-services are also checked unnecessarily. Even if the service becomes up before the booting has completed it will not be detected by init.   
> - For example, network service is essential for NFS or CIFS to function, so there is no meaning in trying to activate dependant services until the main service is up, but Init will still do it.

If due to some reason Init could not start then, no process will be started and the system will reach a state called **Kernal Panic** where booting fails.
### TELINIT  
**`/sbin/telinit`** is linked to `/sbin/init` which takes a one-character argument and signals `init` to perform the appropriate action.
- 0,1,2,3,4,5 or 6 -> switch to the specified run level.  
- a, b, c -> process only those **`/etc/inittab`** file entries having runlevel **a, b** or **c**  
- Q or q -> re-examine the **`/etc/inittab`** file.  
- S or s -> switch to single user mode

Only by users with appropriate privileges can invoke **telinit**.
