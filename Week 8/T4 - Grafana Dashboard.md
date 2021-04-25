* We make use of data sent into `influxdb` by `collectd`

* Install `grafana`,

    ```bash
    $ wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    $ sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    
    $ sudo apt update
    $ apt-cache policy grafana
    $ sudo apt install grafana

    #verify
    $ sudo systemctl start grafana-server
    $ sudo systemctl status grafana-server

    #for running on boot
    $ sudo systemctl enable grafana-server
    ```

* Now we can make use of `influx-node`'s IP address to login to grafana through local computer using
    ```http
    http://192.168.100.129:3000
    ```
    and login using `admin` as both username & password.

* Now add a `data source` in grafana
    * hover on settings icon on left navigation pane, and select `data sources`
    * click `add data source`, select `InfluxDB` as type.
    * Add these details,

        option | value
        :--: | :--:
        Name | collectd-stats
        Query Language | InfluxQL
        URL | http://localhost:8086
        Database | collectd
        User | kiran
        Password | kiran
        HTTP Method | POST
    
    and leave others as default values, hit `Save & Test`.

* If above step is Success, then hover on blocks icon, select `Home`, adn select `Create your first dashboard` block. Select `Add an empty panel`, this shows us the graph dashboard.

* Plot the metrics, by selecting one metric in below configurations UI blocks, click on `select measurement` and selct one metric like `memory_value`, this plots shows the graph of memory usage and also we can select a particular host and plot its metrics by hitting `+` at the end of first line of blocks and select `host` and `=` , then your specific host name.