* For this task, we are redoing the same operation as in `T2` but in alternate servers.

* Static IP addresses that I have configured are 
    ```
    Master : 172.10.0.101/24
    Slave : 172.10.0.102/24  
    ```

* In SLAVE Server:
    * We have to create an user with replication privileges, same as we  did with `knode1` user in MASTER server before, this one will be `knode2`
        ```sql
        > CREATE USER 'knode2'@'%' identified by 'kiran';
        > GRANT REPLICATION SLAVE ON *.* TO 'knode2'@'%';
        > FLUSH PRIVILEGES;
        ```
        now check the status of master using
        ```sql
        > SHOW MASTER STATUS;
        ```
        and note the values of `File` and `Position` fields of the output, mine are 
        File | Position
        :--: | :--:
        mysql-bin.000001 | 767

* Now in MASTER server (1st master server):
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
        > CHANGE MASTER TO MASTER_HOST = '172.10.0.102', MASTER_USER = 'knode2', MASTER_PASSWORD = 'kiran', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 767;
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

* Verify the whole setup by modifying databases in one server and check whether its reflecting in the other one which should be consistent and also compare the checksums of the both tables in both servers which should have same value.