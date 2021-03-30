In this task, we have 2 parts:
# Tasks
1. Take a physical backup of one node and start a docker on it
2. Upgrade the Galera cluster version from 10.5.6 to 10.5.9

## Physical Backup & Docker
> physical backup using `mariabackup` sst method

* We are going to use `mariabackup manual sst` technique for creating a physical backup of one of our nodes, my preference is `node3`.

* First of all we need two nodes (one from the cluster `node3` and another is an standalone node which can be used to deploy mariadb as a `docker container`), these are known as
    * Donor Node : `node3` | 172.10.0.103
    * Joiner Node : stanalone node - `docker-node` | 172.10.0.104

* Now we need to check the versions of `mariabackup` utility and cross-versions are not recommended, can be checked using 
    ```bash
    $ mariabackup --version
    ```
    on both the nodes.

* We could make some configurations in our cnf file of `node3`, in `/etc/mysql/mariadb.conf.d/50-server.cnf` file I am going to add,
    ```bash
    [mariadb]
    .....
    wsrep_sst_method = mariabackup
    wsrep_sst_auth = kiran:kiran        #username:password
    wsrep_sst_donor = node3,
    ```
    on the last line, `,` indicates that in case of `node3` unavailability, it can check on my other nodes to make it as my donor node. All the above configurations are mainly used by normal mariabackup sst.

* We also need a user in `mysql` shell with the username : `kiran` and password : `kiran` and have privileges to reload, process, alter, lock tables, log, so after creating the user, we should grant them like
    ```sql
    GRANT RELOAD, PROCESS, ALTER, LOCK TABLES, BINLOG MONITOR ON *.* TO `kiran`@`%` IDENTIFIED BY PASSWORD 'kiran';
    ```

* Now, for storing the physical backup in `node3` and initiating the backup using `mariabackup`, we do
    ```bash
    $ sudo mkdir /home/kiran/pbackup
    $ sudo mariabackup --backup --galera-info --target-dir=/home/kiran/pbackup \
        --user kiran --password kiran           #user should be available in mysql users list
    ```

* Stop the `mariadb` server and check the status
    ```bash
    $ sudo systemctl stop mariadb
    $ sudo systemctl status mariadb
    ```

* Now in Joiner node - `docker-node`, we create the directory and copy the backup from `node3` (donor) to `docker-node` (joiner) using rsync or scp
    * In `docker-node` :
        ```bash
        $ sudo mkdir /home/kiran/backup
        ```
    * In `node3` :
        ```bash
        $ rsync -av /home/kiran/pbackup/* kiran@172.10.0.104:/home/kiran/backup/
        ```

* In joiner node - `docker-node`, before restoring the backup, we need to prepare it
    ```bash
    $ sudo mariabackup --prepare \
        --target-dir=/home/kiran/backup \
        --user kiran --password kiran
    ```

* In joiner node, we may have to remove any kind of existing file in our `datadir` i.e `/var/lib/mysql/`
    ```bash
    $ sudo rm -Rf /var/lib/mysql/*
    ```

* We now have the work with `docker`, so install it and pull `mariadb v10.5.6` to create a container with the name `maria-dock-node`,
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install docker.io
    $ docker pull mariadb:10.5.6
    $ docker images                     #check the pulled images - mariadb with tag 10.5.6
    
    #creating a container
    $ docker run --name maria-dock-node -d -e MYSQL_ROOT_PASSWORD=kiran mariadb:10.5.6
    $ docker ps -a                      #see all containers with their details and status
    ```

* Now we can login to the `mysql` shell in the docker container or open up a bash terminal, so for `mysql` shell,
    ```bash
    $ docker inspect maria-dock-node | grep IPAddress       #to get the IP of the docker to login remotely
    $ mysql -uroot -p -h 172.17.0.2                     #172.17.0.2 was my output for my previous command
    ```
    and for bash,
    ```bash
    $ docker exec -it maria-dock-node bash
    ```

* Now we need to copy that backup from `/home/kiran/backup` from `docker-node` host to the docker container `maria-dock-node`,
    ```bash
    $ sudo docker cp /home/kiran/backup/* maria-dock-node:/home/backup/
    $ docker exec -it maria-dock-node           #open bash of docker container
    $ ls /home/backup                           #list the files and compare with the host backup files to verify the copy operation
    ```

* Now, we require to restore the backup so, in `maria-dock-node` we can use either `cp` command to just copy all files into `/var/lib/mysql` directory or use `mariabackup` with the option `--copy-back` / `--move-back`,
    ```bash
    $ sudo cp /home/backup/* /var/lib/mysql/
    or
    $ mariabackup --copy-back --target-dir=/home/backup/
    ```

* Now verify all the contents of database by loging into the `mysql` shell inside docker container either by running
    ```bash
    mysql -uroot --p
    ```
    from `maria-dock-node`'s bash or
    ```bash
    mysql -uroot -p -h 172.17.0.2
    ```
    from 'docker-node` i.e host's bash and check the databases, tables, and their checksum to ensure all the contents of database are successfully restored on a docker container.

## Upgradation
> from version 10.5.6 to 10.5.9

```
Note : These steps should be done for all nodes present in the Cluster
```

* Before proceeding to the upgradation, as a caution we need to have a full backup of the current database.

* For backup, we use `mariadb-backup` tool which gets installed when we install the mariadb.

* Follow the below commands to create a full backup
    ```bash
    $ sudo mariadb-backup --backup --user=<user-name> \
      --password=<user-password> --target-dir=<destination-dir>
    ```
    here, we use `mysql` credentials that we generally use for logining into the database SQL shell like in my case,
    * user-name : root
    * destination-dir : /home/kiran/upgrade_backup/
    then the backup has to prepared using
    ```bash
    $ sudo mariadb-backup --prepare \
      --target-dir=/home/kiran/upgrade_backup
    ```

* Now we proceed to remove the older version of `mariadb` and install the `10.5.9` version of it using the below commands,
    * stop the `mariadb` before starting the removal process
        ```bash
        $ sudo systemctl stop mariadb
        ```
        and check the status to double-check using
        ```bash
        $ sudo systemctl status mariadb
        ```
    * Now we start uninstalling,
        ```bash
        $ sudo apt remove "mariadb-*"
        $ sudo apt remove galera-4
        ```
        and verify all packages have been removed using
        ```bash
        $ apt list --installed | grep -i -E "mariadb|galera"
        ```

* Now we start installing the `10.5.9` version of mariadb
    * configuring the `apt` repositories using
        ```bash
        $ sudo apt install wget
        $ wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
        $ echo "6528c910e9b5a6ecd3b54b50f419504ee382e4bdc87fa333a0b0fcd46ca77338 mariadb_repo_setup" | sha256sum -c -
        $ chmod +x mariadb_repo_setup
        $ apt install apt-transport-https       #package required for next command
        $ sudo ./mariadb_repo_setup --mariadb-server-version="mariadb-10.5"
        $ sudo apt update
        ```
    * Now we install the server and other packages we need for `mariadb 10.5.6` 
        ```bash
        $ sudo apt install mariadb-server mariadb-backup
        ```
        he we can just leave the configuration files to be of previous version by either entering `N` or just hitting `Enter` / `Return` would do fine when it asks about configuration files
    * To verify the server is up & running
    ```bash
    $ sudo systemctl status mariadb
    ```
* Finally to verify the upgrade,
    ```bash
    mariadb --version
    ```
    or
    ```sql
    > SELECT VERSION();
    ```
    which should return `10.5.9` version of `mariadb` and also verify the `checksum` value which should be same as in previous stages (mine is : `991005604`)
