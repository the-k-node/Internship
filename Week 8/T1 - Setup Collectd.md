* We have to do these following steps on all 3 nodes of `aerospike` datastore 
    * my vm configurations:
    
    host name | host address
    :--: | :--:
    aero-node-1 | 192.168.100.88
    aero-node-2 | 192.168.100.133
    aero-node-3 | 192.168.100.86
    influx-node | 192.168.100.129
    riemann-node | 192.168.100.126

* Install `collectd`:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install collectd collectd-utils
    ```

    in case of any python related errors:
    ```bash
    $ sudo apt-get install python-setuptools
    ```

    check daemon status:    
    ```bash
    $ sudo service collectd status
    ```

* Configure `collectd` to collect OS metrics
    
    in `/etc/collectd/collectd.conf` file, we add this [configuration](https://github.com/alwaysiamkk/Internship/blob/main/Week%208/collectd.conf)

    & check for any errors in logs
    ```bash
    $ tail -f /var/log/syslog | grep "collectd"
    or
    $ tail -n 500 /var/log/syslog | grep "collectd"
    ```

* This configuration lets `collectd` collect specified metrics in `/etc/collectd/collectd.conf` file.