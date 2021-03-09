• Added a separate disk to create a different mount point for /var/log files with 3G(size isn't mandatory), and made it into a lvm partition by:
1. Creating it into Physical volume ('pvcreate')
2. Creating a separate Volume Group to isolate this mount point ('vgcreate')
3. Creating lvm partition out of the attached disk space ('lvcreate')
4. Formatting the whole lvm using any file system. Here 'xfs' is used ('mkfs.xfs')

• Create a separate mount point by creating a directory like 'mkdir /test'.

• Mount the newly created lvm partition to it using 'mount' command.
```bash
mount /dev/vg2/lvmmount /test
```

• Copy all the contents of '/var/log' directory into '/test' (i.e into the 'lvmmount' partition) by using command 'rsync' which is used to sync contents of source directory into destination remotely.
```bash
rsync -axP /var/log/* /test
```

• Check whether '/test' is correctly mounted and has contents of '/var/log' directory or not using 'df -hT' & 'ls' commands.

• Unmount the '/test' point and edit '/etc/fstab' file to make that mount persistent across reboots.
```bash
vi /etc/fstab
```

• Add the line '/dev/mapper/vg2-lvmmount /test /xfs defaults 0 0' at the end of the file and save it. Run this file using 'mount -a' command

• Verify the status by running 'df -hT' command and do that again after rebooting by running 'reboot' command.

• So effectively we have mounted all the contents of '/var/log' directory into '/test' mount point in which the contents are technically synced into 'lvmmount' partition which is mounted on '/test' point.
