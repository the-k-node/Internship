* Creating a galera cluster would typically require atleast 3 nodes so we are going to consider a new node `node3` which has `mariadb` installed, up and running.

* Static IP addresses and alias names for servers that I have configured are
    ```
    node1 : 172.10.0.101/24              #master1 from previous task
    node2 : 172.10.0.102/24              #master2 from previous task
    node3 : 172.10.0.103/24              #new node for galera cluster
    ```

* When we installed `mariadb-server` and `mariadb-client`, `galera` was automatically gets installed for versions > 10.1. So we don't need to install anything new.

* We need a configuration file in each server called `galera.cnf` which should be located in `/etc/mysql/conf.d/galera.cnf`. So lets create this file in each server and insert the content
    * in `node1`:
        ```bash
        [mysqld]
        binlog_format=ROW
        default-storage-engine=innodb
        innodb_autoinc_lock_mode=2
        bind-address=0.0.0.0

        # Galera Provider Configuration
        wsrep_on=ON
        wsrep_provider=/usr/lib/galera/libgalera_smm.so

        # Galera Cluster Configuration
        wsrep_cluster_name="galera_cluster"
        wsrep_cluster_address="gcomm://172.10.0.101,172.10.0.102,172.10.0.103"

        # Galera Synchronization Configuration
        wsrep_sst_method=rsync

        # Galera Node Configuration
        wsrep_node_address="172.10.0.101"
        wsrep_node_name="node1"
        ```
    
    * in `node2`:
        ```bash
        [mysqld]
        binlog_format=ROW
        default-storage-engine=innodb
        innodb_autoinc_lock_mode=2
        bind-address=0.0.0.0

        # Galera Provider Configuration
        wsrep_on=ON
        wsrep_provider=/usr/lib/galera/libgalera_smm.so

        # Galera Cluster Configuration
        wsrep_cluster_name="galera_cluster"
        wsrep_cluster_address="gcomm://172.10.0.101,172.10.0.102,172.10.0.103"

        # Galera Synchronization Configuration
        wsrep_sst_method=rsync

        # Galera Node Configuration
        wsrep_node_address="172.10.0.102"
        wsrep_node_name="node2"
        ```
    
    * in `node3`:
        ```bash
        [mysqld]
        binlog_format=ROW
        default-storage-engine=innodb
        innodb_autoinc_lock_mode=2
        bind-address=0.0.0.0

        # Galera Provider Configuration
        wsrep_on=ON
        wsrep_provider=/usr/lib/galera/libgalera_smm.so

        # Galera Cluster Configuration
        wsrep_cluster_name="galera_cluster"
        wsrep_cluster_address="gcomm://172.10.0.101,172.10.0.102,172.10.0.103"

        # Galera Synchronization Configuration
        wsrep_sst_method=rsync

        # Galera Node Configuration
        wsrep_node_address="172.10.0.103"
        wsrep_node_name="node3"
        ```
    
    save and close the files.

* For initializing the cluster details that we configured above, we have to stop the mariadb
    ```
    # systemctl stop mariadb
    ```
    then, Initialize the cluster from only `node1`
    ```
    # galera_new_cluster
    ```
    this command will start the cluster and add `node1` to the cluser, we can verify that using
    ```
    # mysql -uroot -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
    ```
    after entering the password, this should show something like
    Variable_name | Value
    :---: | :---:
    wsrep_cluster_size | 1
    
    then start the mariadb using
    ```
    # systemctl start mariadb
    ```

* Now in `node2`, we have to add it to the cluster by running
    ```
    # systemctl start mariadb
    # mysql -uroot -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
    ```
    this should give the output of value 2 by adding this node to that cluster
    Variable_name | Value
    :---: | :---:
    wsrep_cluster_size | 2

* Similarly in `node3`
    ```
    # systemctl start mariadb
    # mysql -uroot -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
    ```
    this should give the output of value 3 by adding this node to that cluster
    Variable_name | Value
    :---: | :---:
    wsrep_cluster_size | 3

* Finally verify the database replication by modifying the database content across servers and check the results in other servers and also the checksum value should be same for the table `ngnix_access_log` across the servers.