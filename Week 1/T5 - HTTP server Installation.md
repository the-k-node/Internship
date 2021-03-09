• Installed Apache Web Server using apt-get package manager tool
```bash
apt-get install apache2
```

• verified that the server is running using 'service' command
```bash
service apache2 status
```
gives 'active' if the server is running successfully

• We can also use apache's file ('/etc/init.d/apache2') directly to initiate commands on server eg: start, stop, restart, etc
```bash
/etc/init.d/apache2 start
/etc/init.d/apache2 stop
/etc/init.d/apache2 restart
```

• To make the server start automatically when the system starts, we have to use 'update-rc' command to make it run on bootup
```bash
update-rc.d apache2 defaults
```

• Finally verify by rebooting server again to see whether Apache Web Server is running on bootup or not
```bash
service apache2 status
```
