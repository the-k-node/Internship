## Task2 - Cluster, Slave replication setup using Ansible

* Run
```bash
$ ansible-playbook task2.yml --ask-become-pass
```
for complete Task 2 execution where `--ask-become-pass` option is used to make the playbook popup us an option to enter root password on starting it and [task2.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/task2.yml) has multiple playbooks for each subtasks in [playbooks](https://github.com/alwaysiamkk/Internship/tree/main/Week%205/playbooks) folder which are explained below. I have made all my subtasks into smaller chunks of operations i.e `roles`, and are in [roles](https://github.com/alwaysiamkk/Internship/tree/main/Week%205/playbooks/roles) folder

* Each role in this task is created using `ansible-galaxy` command
```bash
$ ansible-galaxy init /etc/ansible/roles/<role-name>
```

* The operational code is situated in `main.yml` file inside tasks directory of each role like `/etc/ansible/roles/<role-name>/tasks/main.yml`.

* Also I have all my nodes grouped like `nodes` for all nodes, variables for each node like `server_id` to be used in `my.cnf.j2` file in my default inventory file `/etc/ansible/hosts` - [hosts](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/hosts).

### 1. Setup 3 - Node Galera Cluster

* Playbook File : [t2.1.galera.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.1.galera.yml)

* Steps followed are
    1. Installed Mariadb (v10.5.9) on all 3 nodes using playbook [t2.1.mariadb.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.1.mariadb.yml).

    2. Copy galera config file into all 3 hosts by dynamically changing the details for each host like `wsrep_node_address` and `wsrep_node_name` using `jinga2` templating ([cluster.cnf.j2](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/templates/cluster.cnf.j2)) and sent to destination `/etc/mysql/conf.d/galera.cnf`.

    3. Check the status of replication between nodes just in case this file is running after creating cluster for making the process idempotent.

    3. Stop mariadb servers on all 3 nodes.

    4. Bootstraped a new galera cluster using `galera_new_cluster` from any one node (my choice was `node1`-`node_1` in inventory).

    5. Start mariadb servers on other 2 nodes and check the cluster creation, run `show status like 'wsrep_cluster_size'` and check the value which should be `3` if everything went successfully.

    6. Finally copy the `my.cnf` ([my.cnf.j2](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/templates/my.cnf.j2)) file into hosts using `jinga2` templating in playbook [t2.1.myconf.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.1.myconf.yml) file.

### 2. Demote Node 3 as Async Slave

* Playbook File : [t2.2.demote.node3.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.2.demote.node3.yml)

* Steps followed are
    1. Created a replication user named `kmaster` to be used for replication in slave and granted `REPLICATION SLAVE` privileges.

    2. As we are proceeding replication using `gtid`, we have to extract it from `master_node` (refer [hosts](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/hosts)) done using `gtid_binlog_pos` (we can also use `gtid_current_pos` but `gtid_binlog_log` will have most recent updates).

    3. Stop slave on `slave_node`.

    4. Configure replication in slave node using `changemaster` command in mysql shell specifying details of replication user details from `master_node`, its address, and `MASTER_USE_GTID` with `slave_pos` to get that global variable value defined above.

    5. Start the slave and check for its status using `SHOW SLAVE STATUS \G`.

    6. Now we have to remove this node out of galera cluster to avoid synchronous replication, so stop server, make `wsrep_on` as `OFF` in `galera.cnf`, and start the server and verify the result.

### 3. Destroy the cluster

* Playbook File : [t2.3.cluster.destroy.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.3.cluster.destroy.yml)

* Steps followed are
    1. Check the replication status in nodes 1 and 2 using 
    ```sql
    SHOW STATUS LIKE 'wsrep_local_state_comment';
    ```
    if that returns `Synced`, then we can perform cluster destruction or wait for replication to sync up in all nodes.

    2. If `Synced`, then stop servers in both nodes, change `wsrep_on` to `OFF` in `galera.cnf`, and start the servers.

    3. Verify the cluster details and size will be either empty set or `0`.

### 4. Playbook Idempotency

* I have configured various conditions for each task and its subtasks to avoid any kind of errors and repetetive configurations if we already did that before.

### 5. 2 New Users

* Playbook File : [t2.5.users.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/playbooks/t2.5.users.yml)

* Steps followed are
    1. Using `mysql_user` module, created 2 users 
        
        1. `me_kiran` with all permissions (read & write) on all databases in the cluster.

        2. `monitoring` with only `SELECT` permissions (read only) on all databases of cluster.
