### Aerospike Tasks

> VM  Configuration
    
node name | IP address
:--: | :--:
`aero-node-1` | 192.168.100.88
`aero-node-2` | 192.168.100.85
`aero-node-3` | 192.168.100.86

1. Install and configure 1 node Aerospike cluster version 4.8.0.6

    * For installing `aerospike` server of version `4.8.0.6` on `aero-node-1`,

        ```bash
        $ sudo wget -O aerospike.tgz 'https://www.aerospike.com/download/server/4.8.0.6/artifact/ubuntu18'      #to download the file and save it as 'aerospike.tgz'
        $ sudo tar -xvf aerospike.tgz       #extract the files out of the downloaded file
        $ sudo apt --fix-broken install    #for fixing python dependency(if the next command results in an error)
        $ cd aerospike-server-community-4.8.0.6-ubuntu18.04
        $ sudo ./asinstall            #inbuilt script to install aerospike
        ```
    
    * Verify that `aerospike` has installed,

        ```bash
        $ sudo systemctl start aerospike
        $ asinfo -v build           #displays aerospike version installed
        ```
    
    * Check logs

        ```bash
        $ journalctl -u aerospike -a -o cat -f
        ```

2. The AS cluster should have a username/password

    * Note: only available for `enterprise` edition and not for `community` edition

    * In `/etc/aerospike/aerospike.conf` file

        ```conf
        security {
            ...
            enable-security true
            ...
        }
        ```
        and again back to bash,
        
        ```bash
        $ asadm           #to access server admin shell
        > manage acl create role superuser priv read-write-udf  #create a new role 'superuser' with read, write privileges
        > manage acl grant role superuser priv sys-admin
        > list all roles        #check the creation of role
        > manage acl allowlist role superuser allow 192.168.100.88
        > manage acl create user kiran password kiran roles superuser       #create a new user with 'superuser' role
        > show users            #verify user creation
        ```

3. Data should be persisted on disk

    * For achieving data persistence, we need to change `storage-engine` from `memory` to `device` and either specify a `.dat` file or device itself eg `/dev/sdb` in `namespace` stanza for which data we need persistence feature enabled. Before that, we need to have appropriate permissions for the user we are using in our `aerospike.conf` file which is also an user in OS,

        ```conf
        service {
            ...
            user kiran
            ...
        }
        ```

        create required files and own to the user defined above.

        ```bash
        $ sudo mkdir /var/log/aerospike        #for log file defined in conf file
        $ sudo touch /opt/aerospike/data/test.dat   #for 'test' namespace (optional, can remove the namespace itself)
        ```

    * Now we have made these required files and directories, but we need to have certain permission to access them using the user that we explained above, in this case user `kiran` who is a sudoer in my server machine os,

        ```bash
        $ sudo chown kiran /var/log/aerospike/
        $ sudo chown kiran /opt/aerospike/data/test.dat
        ```

    * We now need to create symlink for accessing aql on each node, it initially uses the latest available `libreadline` edition which is `8.0`, but `aql` runs on `libreadline.so.7` version, so it results in an error for accessing `aql`. We have to make a symlink to just make `8.0` version available in the name of `7`,

        ```bash
        $ sudo ln -s /lib/x86_64-linux-gnu/libreadline.so.8.0 /lib/x86_64-linux-gnu/libreadline.so.7
        $ aql
        ```
    
    * Now in `namespace` stanza in configuration files,

        ```conf
        namespace test {
            ...
            storage-engine device {
                file /opt/aerospike/data/test.dat
                filesize 16G
                data-in-memory true # Store data in memory in addition to file.
            }
        }
        ```
    
    * Restart the `aerospike` daemon to apply all these changes


* We also need to have a log file enabled, in `aerospike.conf`,

    ```conf
    logging {
        ...
        file /var/log/aerospike/aerospike.log {
        context any info
        context migrate debug
        }
    }
    ```

    and in bash,

    ```bash
    $ sudo touch /var/log/aerospike/aerospike.log
    $ sudo chown kiran /var/log/aerospike/aerospike.log
    ```

4. Add 2 more nodes to the cluster without restarting AS service on first one

    * Create 2 more VMs - `aero-node-2` & `aero-node-3`, and follow all the steps as we did for `aero-node-1`.

    * Now this configurations to be made to all 3 nodes with respect to its details, in `aerospike.conf`,

        ```conf
        network {
            heartbeat {             #heartbeat is the one for clustering
                ...
                mode mesh
                port 3002
                address 192.168.100.88                          #current node address eg for node 1
                mesh-seed-address-port 192.168.100.88 3002       #node1 address
                mesh-seed-address-port 192.168.100.85 3002       #node2 address
                mesh-seed-address-port 192.168.100.86 3002       #node3 address
                ...
            }
        }
        ```

    * Verify the cluster after restarting `aerospike` daemon

        ```bash
        $ journalctl -u aerospike -a -o cat -f | grep 'CLUSTER-SIZE'
        ```
        the cluster size will be `3` if configured properly

5. Create a namespace Orders

    * Create a separate `namespace` stanza in `aerospike.conf` file with required configuration
        
        ```conf
        namespace orders {
            ...
            storage-engine device {
                file /opt/aerospike/data/orders.dat
                filesize 4G
                data-in-memory true
            }
        }
        ```

        and also the required files and permissions

        ```bash
        $ sudo touch /opt/aerospike/data/orders.dat
        $ sudo chown kiran /opt/aerospike/data/orders.dat
        ```
    
        restart for applying changes

6. Write a program using an AS client to write and read the data from AS.

    * We can write the program using any major languages like Java, C, Go, Python, etc. We choose python for this task

    * Environment setup on a different machine (I'm using my host OS X)

        * Aerospike supports `python` versions upto `3.8`, so verify version (I use v`2.7`), and `pip` too.

        * Verify python & pip are working properly,

            ```bash
            $ python2.7 -V
            $ pip2.7 -V
            ```
        
            if got any error, try reinstalling the same version and if it displays version details, then proceed.

        * Install `aerospike` client

            ```bash
            $ sudo xcode-select --install
            $ brew install openssl
            $ sudo pip2.7 install aerospike
            ```
        
        * Now verify the installation by importing `aerospike` into a python program and you shouldn't get any errors for that.

        * The program to read and write some data is [access_client.py](https://github.com/alwaysiamkk/Internship/blob/main/Week%206/client/access_client.py), which has `key` data which has (`namespace`,`set`,`Primary Key(PK)`). If this program returns any exception, check for the connection node address of one node of a cluster in `hosts` object, and if a write exception, then create a new set in that namespace using `aql` client console.

            ```aql
            > insert into orders.products(PK,product,cost) values(1,'mouse',200)
            > delete from orders.products where PK=1
            ```
        
            this inserts the record by creating the set and will be stored in metadata even if we remove the only record in the set.

        * Run the program in supported python console
        
            ```bash
            $ python2.7
            >>> <copy-paste the whole program>
            ```
            if this returns some code like `0L`, then it worked fine and you'll get the read ouput as well, else will get an exception.

7. The namespace should have the following sets (buyer details, product details)

    * Using same technique used above
        
        ```aql
        > insert into orders.buyers(PK,name,expenditure) values(1,'kiran',6700)
        > delete from orders.buyers where PK=1
        > insert into orders.products(PK,product,cost) values(1,'mouse',200)
        > delete from orders.products where PK=1
        ```

        now, we can add any number of records and won't get any write exceptions.

8. Each set should have 3000 records.

    * Client Python program [add_3k_rec.py](https://github.com/alwaysiamkk/Internship/blob/main/Week%206/client/add_3k_rec.py), I just run a for loop of range 30001 with same records which adds 3000 records with iterative variable as my `PK`.

9. The records should have an expiry of 24h

    * Add a line `default-ttl` with some appropriate time and `allow-ttl-without-nsup` as `true` to avoid setting `nsup` to turn on and take control on namespaces in `namespace` stanza of conf file,
    ```conf
    namespace orders {
        ...
        default-ttl 30d
        allow-ttl-without-nsup true
        ...
    }
    ```

    * Now for making the records persist only for 24h, we need to have `meta`'s `ttl` object set to 24 hours or 86400 seconds while writing

        ```python
        client.put(key, buyer_bins, meta={'ttl':86400})
        ```

10. Shut down one of the nodes, optimise the AS cluster such that the data migration is faster.

    * Stopped the `aerospike` daemon on `aero-node-3`.

    * For optimising the migration and make it much faster. On all nodes, I changed multiple attributes like,
    ```conf
    service {
        ...
        migrate-max-num-incoming 6      #def 4
        migrate-threads 2               #def 1
    }

    network {
        fabric {
            ...
            #for even higher migration traffic
            channel-bulk-recv-threads 8     #def 4
            channel-bulk-fds 4              #def 2
        }
    }

    namespace orders {
        ...
        migrate-sleep 0                 #def 1
        ...
    }
    ```

11. Bring back the node,start inserting 1000 records in the AS cluster while the data migration is going on.

    * Created a separate program [add_1k_rec.py](https://github.com/alwaysiamkk/Internship/blob/main/Week%206/client/add_1k_rec.py), to add 1000 records as did for 3000 records before.

    * Start the `aerospike` on `aero-node-3`, this starts the migration and run the program above in the `python2.7` shell, then check the migration status by running
    x
        ```bash
        $ cat /var/log/aerospike/aerospike.log | grep "migrations"
        ```
    
12. Observe the ops/sec, read/write latencies and migration speed.

    * We can use `latency` command in `asinfo` to get the latencies like `ops/sec`, `read/write`,

        ```bash
        $ asinfo -v latency: -l
        ```
    
    * For detailed latencies,

        ```bash
        $ asloglatency -h {orders}-write    #for write latencies
        $ asloglatency -h {orders}-read    #for read latencies
        ```

        , use `Ctrl+C` for final results of `avg` & `max` values of `ops/sec` for `read` & `write`.

    * We can check the statestics of the migrations in admin console using `asadm` command,

        ```
        > show stat like migrate
        ```
    
    * We can also use Benchmarks, add benchmarks lines in `namespace` stanza,

        ```conf
        namespace orders {
            ...
            enable-benchmarks-read true
            enable-benchmarks-write true
            enable-benchmarks-ops-sub true
            ...
        }
        ```

        we have read, write, and ops benchmarks for monitoring these latencies using

        ```bash
        $ cat /var/log/aerospike/aerospike.log | grep "{orders}-write"              #for writes
        $ cat /var/log/aerospike/aerospike.log | grep "{orders}-read"              #for reads
        $ cat /var/log/aerospike/aerospike.log | grep "{orders}-ops-sub"              #for all operations like 'dup', 'response', etc
        ```

13. Upgrade AS to version 4.9 without loosing the data.

    * For upgrading, we need to download the relevant version, these steps are done on all 3 nodes,

        ```bash
        $ sudo wget -O aerospike4.9.tgz 'https://www.aerospike.com/download/server/4.9.0.30/artifact/ubuntu18'  #saves as 'aerospike4.9.tgz'
        $ tar xzf aerospike4.9.tgz      #extract it
        $ cd aerospike-server-4.9.0.30-community-ubuntu20.04.tgz
        $ sudo dpkg -i aerospike-server-community-4.9.0.30.ubuntu18.04.x86_64.deb       #install server
        $ sudo dpkg -i aerospike-tools-3.25.1.ubuntu18.04.x86_64.deb            #install tools
        ```

    * Verify the version installed by using,
        ```bash
        $ asinfo -v build
        ```
    should give you something like `4.9.0.30`, else recheck or redo the steps again.

    * Check for the data,
        ```bash
        $ aql
        ```
        and,
        ```aql
        > select * from orders.products
        > select * from orders.buyers
        ```
        verify the count displayed at the last, should be same as before.
