• Created users with defined usernames and passwords(temporarily) for intended group of users using 'adduser' or 'useradd' commands
```bash
adduser [username]
```
	
• Created a User Group called 'intern' command 'groupadd'
```bash
groupadd interns
```
• Add the newly created users to 'intern' group using 'useradd' or 'adduser' or 'usermod' commands
```bash
adduser [username] interns
useradd -G interns [username]
usermod -a -G interns [username]
```
here '-a' option acts as append, if not used user might be dropped from other groups

• Verified users and their associated groups using 'id' command
```bash
id [username]
```
