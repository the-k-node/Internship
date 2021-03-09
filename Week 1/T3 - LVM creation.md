• Previously added 2 disks of 10G storage are used here to create LVMs

• Check the details of the disks using 'fdisk' command with '-l' option to list out its complete details (In my case, two added disks are /dev/sdb, /dev/sdc)
```bash
fdisk -l
```

• Make these disks into physical volumes using 'pvcreate' command, i.e 
```bash
pvcreate /dev/sdb /devsdc
```

• Verify the operation using 'pvs' to list out all available physical volumes or 'pvdisplay' followed by disk name like 
```bash
pvdisplay /dev/sdb
```
to display complete details of that physical volume

• Created new Volume Group using 'vgcreate' command followed by name of volume group along with volumes to be added
```bash
vgcreate vg1 /dev/sdb /dev/sdc
```

• Verify the operation using 'vgs' for simple detials and 'vgdisplay' followed by name of the volume group
```bash
vgdisplay vg1
```
to get the complete details of volume group

• Created the LVMs using 'lvcreate' command with '-n' option for naming it
```bash
lvcreate -n lvm1 -l 100%FREE vg1
```
here -l is meant for remaining storage and 100%FREE option species percentage to be added out of free storage available

• Verify the operation using 'lvs' or 'lvdisplay' command to get the details of the lvm created
```bash
lvdisplay /dev/vg1/lvm1
```

• Add file system for this lvm, here 'xfs' is the requirement

• 'mkfs' command along with the file system type is used to use the file system of specified lvm
```bash
mkfs.xfs /dev/vg1/lvm1
```

• Mounted to '/data' directory using 'mount' command can be used, but the requirement is that the mount should be persistent across reboots.

• So we use the UUID of the lvm to add it to the '/etc/fstab' file to make it persistent across reboots

• To get UUID of lvm, use 'blkid' command along with the lvm name
```bash
blkid /dev/vg1/lvm1
```
copy the UUID, edit '/etc/fstab' file to add a command to run on bootup

• make the '/data' directory if it doesn't exists using 'mkdir' command, edit the file using simple text editors like vim or vi or nano
```bash
vi /etc/fstab
```
and add 
```bash
UUID=<UUID got from blkid command> /data xfs defaults 0 0
```
at the end of the file to make sure it will be the last one to execute

• Save the changes and mount the LV using
```bash
mount -a
mount | grep home
```

• Verified by running 'df' command on the mount point:
```bash
df hT /data
```
