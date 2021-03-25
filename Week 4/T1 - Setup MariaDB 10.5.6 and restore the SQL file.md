* For the first task, we need to install mariadb 10.5.6 version. Follow the below commands to set it up
    ```bash
    $ sudo apt update && sudo apt upgrade
    $ sudo apt -y install software-properties-common
    $ sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'       #to add the repo keys to the system
    $ sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://archive.mariadb.org/mariadb-10.5.6/repo/ubuntu/ focal main'        #to add the mariadb of version 10.5.6 - ubuntu focal to the APT repo
    $ sudo apt update
    $ sudo apt install mariadb-server mariadb-client        #to install both server and client of mariadb into the machine
    ```
    after successfully installing the mariadb into the system, secure the shell using
    ```bash
    $ sudo mysql_secure_installation
    $ Enter current password for root (enter for none): [press ENTER]
    $ Switch to unix_socket authentication [Y/n] y
    $ Change the root password? [Y/n] n
    $ Remove anonymous users? [Y/n] y
    $ Disallow root login remotely? [Y/n] y
    $ Remove test database and access to it? [Y/n] y
    $ Reload privilege tables now? [Y/n] y
    ```
    after this procedure, check the status of `mysql`
    ```bash
    $ systemctl status mysql
    ```
    if its `active(running)`, we can safely login to the `mysql` shell
    ```bash
    mysql -u root -p
    ```
    enter the password and we can use this shell to access and modify the database.

* Creating an user can be done using SQL commands in `mysql` shell that we just logged in i.e
    ```sql
    > CREATE USER 'knode1'@'%' IDENTIFIED BY 'kiran';
    ```
    here `knode1` is my username and `kiran` is my password to login to the shell, verify using
    ```sql
    > SELECT user FROM mysql.user;
    ```

* We can provide some privileges to the user we created
    ```sql
    > GRANT ALL PRIVILEGES ON *.* TO 'kiran'@'%' IDENTIFIED BY 'kiran';
    ```
    here, `*.*` says that we are granting privileges on all databases onm the server (first `*`) and all operations on those databases (second `*`). If we want to only grant privileges for all operation on a selected database, we can do that using
    ```sql
    > GRANT ALL PRIVILEGES ON <dbname>.* TO 'kiran'@'%';
    ```
    and then
    ```sql
    > FLUSH PRIVILEGES;
    ```
    verify the grants using
    ```sql
    > SHOW GRANTS FOR 'kiran'@'%';
    ```

* Creating a database is simple,
    ```sql
    > CREATE DATABASE Ngnix;
    ```
    here `Ngnix` is the database name and verify using
    ```sql
    > SHOW DATABASES;
    ```

* Restoring the sql file can be done using a single command, but transferring it into VM is the main hurdle, we can use `scp` tool for this purpose
    ```bash
    $ sudo scp ./Documents/ngnix_access_log.sql kiran@192.168.100.58:/home/kiran/Documents
    ```
    here, `./Documents/ngnix_access_log.sql` is the location of the backup file and `kiran@192.168.100.58` is the username and IP of my VM (which I could also use for ssh), `/home/kiran/Documents` is the destination location to copy the file into.

* Finally to restore the backup file, 
    ```bash
    $ mysql -u root -p Ngnix < ./Documents/ngnix_access_log.sql
    ```
    here, `Ngnix` is database name that we created earlier and `./Documents/ngnix_access_log.sql` is the location of the file that we just transferred using `scp` tool. Verify using
    ```sql
    > USE Ngnix;
    > SHOW TABLES;
    > CHECKSUM TABLE ngnix_access_log;
    ```
    we can check that it returns some value except `NULL` which says that table exists and is accessible.