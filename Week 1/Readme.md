># Tasks - Week1 

* Install VBOX on your laptop.

* Download Ubuntu Focal ISO.

* Install Ubuntu Focal ( give 2 cpu cores and 512 MB of RAM. Do not install the GUI).

* Once the installation is done, create all the users who are a part of this email ( mehul.intern, neha.intern etc  ). Create a group called  `intern`
and add the users to that group. 

* Add 2 disks each of 10GB each to this VM. Create a LVM using these two disks and create XFS filesystem on it. Mount this on /data directory and make sure that the mount persists across reboots.

* Add another 10GB disk to the VM. Add it to the existing LVM.

* run a http server on this VM . Make sure that the server starts automatically when the system starts.

* The users in the group interns should be able to login via a private key, and not a password.

*  Mount  `/var/log`
on a separate mount point.

*  The http server should only listen on the VMs IP and not localhost.

* Using packer automate the entire setup.
