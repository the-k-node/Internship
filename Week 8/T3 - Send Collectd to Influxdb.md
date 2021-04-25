* In `influx-node`, configure `/etc/influxdb/influxdb.conf`, add details of the `collectd` to receive the metrics and store into the `collectd` database in `influxdb`

    ```conf
    [[collectd]]
        enabled = true
        bind-address = ":25826"
        database = "collectd"
        retention-policy = ""
        typesdb = "/usr/local/share/collectd/types.db"
        batch-size = 5000
        batch-pending = 10
        batch-timeout = "10s"
        read-buffer = 0    
    ```

* we also need `types.db` as specified in `typesdb` key in above configuration file, so

    ```bash
    $ sudo mkdir /usr/local/share/collectd
    $ sudo wget -P /usr/local/share/collectd https://raw.githubusercontent.com/collectd/collectd/master/src/types.db
    ```

* Restart the `influxdb` to see the changes

    ```bash
    $ sudo service influxdb restart
    ```

* Verify the details stored

    ```bash
    $ influx -username kiran -password kiran
    ```
    check data,
    ```
    > use collectd
    > show measurements
    > select * from cpu_value
    ```
    `show measurements` shows all the metrics sent by `collectd`, and `cpu_value` is one among them.