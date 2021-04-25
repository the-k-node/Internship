* Create a new VM,

    * my vm configuration

    host name | host address
    :--: | :--:
    influx-node | 192.168.100.129

* Install `influxdb` using

    ```bash
    $ sudo echo "deb https://repos.influxdata.com/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/influxdb.list             # add repo to ubuntu
    $ sudo sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -             #import GPG key

    #install 'influxdb'
    $ sudo apt-get update
    $ sudo apt-get install influxdb
    ```

    enable the service on boot up using 
    
    ```bash
    $ sudo systemctl enable --now influxdb
    ```

    & chceck its status

    ```bash
    $ sudo systemctl status influxdb
    ```

* Configure `influxdb`

    * enable user authentication by creating a new user to access `influxdb`

        ```bash
        $ sudo influx               #login to influx console
        ```

        in `influx`, create user
        ```
        > CREATE USER inanzzz WITH PASSWORD '123123' WITH ALL PRIVILEGES
        > SHOW USERS
        > EXIT
        ```

    * create database to store `collectd` values to be sent in next task:

        ```bash
        $ curl -i -XPOST http://localhost:8086/query -u kiran:kiran --data-urlencode "q=CREATE DATABASE collectd"
        ```
        this creates a database named `collectd` & check the whether the db has been created
        ```
        > show databases
        ```


