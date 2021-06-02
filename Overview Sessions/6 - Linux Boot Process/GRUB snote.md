# GRUB

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
