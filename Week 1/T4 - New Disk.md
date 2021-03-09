• Added another disk of 10G for the VM

• Created that disk into a new Physical volume using 'pvcreate' command
```bash
pvcreate /dev/sdd
```
and verified the status by running 'pvs' command

• Used 'vgextend' command to add the new PV into the existing Volume group 'vg1'
```bash
vgextend vg1 /dev/sdd
```
and verified the result of operation by running 'vgs' and 'vgdisplay' commands, on running 'vgdisplay', we can see that there is a free space of 10G available which is newly added to extend it to the LV 'lvm1'

• Extended LV using 'lvextend' command to the remaining space left (newly added 10G)
```bash
lvextend -l +100%FREE /dev/vg1/lvm1
```

• Used 'xfs_growfs' command to extend the file system to the newly added logical volume of 10G into 'lvm1' LV.
```bash
xfs_growfs /dev/vg1/lvm1
```
