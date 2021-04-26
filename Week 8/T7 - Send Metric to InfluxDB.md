* We have make changes in `riemann.config` file located in `/home/kiran/riemann-0.3.6/etc/riemann.config`, we have to add a function for `influxdb` with needed details like `host`, `db`, `username`, `password`, and others in a function,

    ```clj
    (def riemann-to-influxdb (
        influxdb {
            :version :0.9
            :host "192.168.100.129"
            :db "riemann_metrics"
            :port 8086
            :username "kiran"
            :password "kiran"
            :timeout 100000
        })
    )
    ```

* We have add this function name `riemann-to-influxdb` to the `streams` below,
    ```clj
    (let [index (index)]
        ...
        (streams
            (default :ttl 20
                ...
                riemann-to-influxdb
                ...
            )
        )
    )
    ```

* Now in `influx-db`, we need to create the `riemann_metrics` database,
    ```
    > create database riemann_client
    ```

* Now, we can be able to see the metrics pushed by riemenn server which were received from our client script into this database, to verify, run script, and check riemann dashboard and you should see the new metrics, then login to influx db,
    ```
    > use riemann_metrics
    > show measurements
    > select * from as_cluster_size
    ```
    on running `show measurements` should show you all the metrics, then on `select` statement, you should see the details, we specified while sending events.