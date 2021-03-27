In this task, we have 2 parts:
# Tasks
1. Take a physical backup of one node and start a docker on it
2. Upgrade the Galera cluster version from 10.5.6 to 10.5.9

## Physical Backup & Docker
> physical backup using `mariabackup` sst method


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
