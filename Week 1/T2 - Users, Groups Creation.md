• Created users with defined usernames and passwords(temporarily) for intended group of users using 'adduser' or 'useradd' commands
	adduser [username]

• Created a User Group called 'interns' command 'groupadd'
	groupadd interns

• Add the newly created users to 'interns' group using 'useradd' or 'adduser' or 'usermod' commands
	adduser [username] interns
	useradd -G interns [username]
	usermod -a -G interns [username]
here '-a' option acts as append, if not used user might be dropped from other groups

• Verified users and their associated groups using 'id' command
	id [username]
