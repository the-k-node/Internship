* Do the same steps as `T1` to install the `mariadb` and proceed to the following steps to configure the new VM as `slave` server.

* Static IP addresses that I have configured are 
    ```
    Master : 172.10.0.101/24
    Slave : 172.10.0.102/24  
    ```

* In MASTER Server (the one we configured before):
    * Make configurations
        ```bash
        vim /etc/mysql/mariadb.conf.d/50-server.cnf
        ```
        and modify
        ```bash
        bind-address            = 0.0.0.0
        ```
        and add the following at the end of the file
        ```bash
        server-id = 1
        log_bin = /var/log/mysql/mysql-bin.log
        log_bin_index =/var/log/mysql/mysql-bin.log.index
        relay_log = /var/log/mysql/mysql-relay-bin
        relay_log_index = /var/log/mysql/mysql-relay-bin.index
        ```
        then restart the mariadb
        ```bash
        systemctl restart mariadb
        ```
    
    * Now create an user with replication privileges, as we already created `knode1` user already we can either use the same user or create a new user using
        ```sql
        > CREATE USER 'username'@'%' identified by 'password';
        ```
        I will be using the same user for this purpose and granting him the replication privileges to be used by `slave`
        ```sql
        > GRANT REPLICATION SLAVE ON *.* TO 'knode1'@'%';
        > FLUSH PRIVILEGES;
        ```
        now check the status of master using
        ```sql
        > SHOW MASTER STATUS;
        ```
        and note the values of `File` and `Position` fields of the output, mine are
        
        File | Position
        :---: | :---:
        mysql-bin.000001 | 888

* Now in SLAVE server (newly created VM):
    * Make configurations
        ```bash
        vim /etc/mysql/mariadb.conf.d/50-server.cnf
        ```
        and modify
        ```bash
        bind-address            = 0.0.0.0
        ```
        and add the following at the end of the file
        ```bash
        server-id = 2
        log_bin = /var/log/mysql/mysql-bin.log
        log_bin_index =/var/log/mysql/mysql-bin.log.index
        relay_log = /var/log/mysql/mysql-relay-bin
        relay_log_index = /var/log/mysql/mysql-relay-bin.index
        ```
        then restart the mariadb
        ```bash
        systemctl restart mariadb
        ```
    * Login to the `mysql` shell,
        ```bash
        mysql -u root -p
        ```
        and stop the slave before configuring it
        ```sql
        > stop slave;
        ```
        then enter the details of the master including the output we received earlier
        ```sql
        > CHANGE MASTER TO MASTER_HOST = '172.10.0.101', MASTER_USER = 'knode1', MASTER_PASSWORD = 'kiran', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 888;
        ```
        then
        ```sql
        > start slave;
        ```
        and check for the connection status by
        ```sql
        > show slave status \G
        ```
        this should show `Slave_IO_Running` and `Slave_SQL_Running` to be `Yes`

* Verify the whole setup by creating a new database in Master and find it in the databases of slave and also compare the checksums of the both tables in `MASTER` & `SLAVE` which should have same value.
