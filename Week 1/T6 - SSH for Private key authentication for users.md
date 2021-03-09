• Installed SSH server using apt-get package manager
```bash
apt-get install openssh-server
```
here, 'openssh-server' is the package name of the SSH server

• Generate pair of SSH keys (Public and Private) in Client Machine (or local device) using command 'ssh-keygen'
```bash
ssh-keygen
```

• Location, Passphrase are optional and are better to opt for increased security with passphrase

• If location is left default, you can able to see the new directory '.ssh' created, use '-a' option to see hidden directories as '.ssh' has a period sign which means hidden
```bash
ls -a
```

• navigate to the directory '.ssh' to see the keys generated (default names are 'id_rsa' for private key and 'id_rsa.pub' for public key)
```bash
cd .ssh
ls
```
this shows the keys inside '.ssh' directory, navigate back to root

• Now we have to configure the VM's network settings, so that we could remote login using another VM or device.

• While the Server VM running, open settings of it from VBOX, go to 'Network' Panel, and in 'Advanced' Section, click of 'Port Forwarding' and add one entry for SSH.
	Name - SSH, Protocol - TCP, Host IP - 127.0.0.1, Host Port - 2200, Guest IP - 10.0.2.15 (Server's IP, can get using 'hostname -I' command), Guest Port - 22

• Check the status of ssh on server using 'service' command
```bash
service ssh status
```
and ensure it is active and running

• Now from remote device, login using 'ssh' command
```bash
ssh -p 2200 kiranintern@localhost
```
here '-p' option states port 2200 to just specify it and 'kiranintern' is admin username, 'localhost' is how we can access the server from client VM or device remotely.
Login using password

• Now the generated key pairs from client machine, copy it into the '.ssh/authorized_keys' file in server using 'ssh-copy-id' command.
```bash
ssh-copy-id kiranintern@localhost
```
this copies the public key from client machine into server's authorized keys 

• Now remote login into the server using 'ssh' command.
```bash
ssh kiranintern@localhost
```
Now it asks for the passphrase entered during generation of keys in client machine after entering we will be able to login remotely into the specified username

• We needed to eliminate password authentication and have only Private key authentication. For that, go to server and edit its '/etc/ssh/sshd_config' file.
```bash
vi /etc/ssh/sshd_config
```
and find 'PasswordAuthentication yes' entry (shouldn't have # infront) and make it 'PasswordAuthentication no' and find 'ChallengeResponseAuthentication' and ensure it is followed by 'no', otherwise password authentication will be still working

• Now try remote login again and can notice that it only asks for passphrase and not password anymore.

• Backup the private key into some secure directory to avoid getting locked out from the server and can never access it. Using 'cp' command, copy the keys.
```bash
cp ~/.ssh/id_rsa* /some/secure/directory/path
```

• We can also change the owner of the key to let them login remotely to the server (as other interns are supposed to use Private keys to login than Passwords) using 'chown' command.
```bash
sudo chown [new-username]:[new-username] ~/.ssh/id_rsa*
```
