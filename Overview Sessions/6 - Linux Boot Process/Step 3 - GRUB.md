# GRUB :floppy_disk:

- GRUB stands for **Grand Unified Bootloader**.
- Result of a troubleshooting done by **Erich Boleyn**, to boot `GNU Hurd` - OS which was designed by GNU, as a **free replacement of UNIX**.
- **Yoshinori K. Okuji** carried further work to advance the initial GRUB, and is called GRUB2.
- `440 bytes` of MBR will have GRUB first boot stage.
- Stage 2 GRUB loads the kernel and other `initrd` image files.
- GRUB is the combined name given to **different stages** of grub.
- If you have multiple kernel images installed on your system, you can choose which one to be executed.
- GRUB stages:
    - GRUB Stage 1
    - GRUB Stage 1.5
    - GRUB Stage 2
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
- As you notice from the above info, it contains kernel and initrd image.
- So, in simple terms GRUB just loads and executes Kernel and initrd images.
