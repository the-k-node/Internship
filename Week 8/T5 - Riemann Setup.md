* On `riemann-node`, install `riemann` server

    ```bash
    $ wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6.tar.bz2
    $ tar xvfj riemann-0.3.6.tar.bz2
    $ cd riemann-0.3.6

    #check the md5sum
    $ wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6.tar.bz2.md5
    $ cd ..
    $ md5sum -c riemann-0.3.6/riemann-0.3.6.tar.bz2.md5
    ```
    verify server is installed by running it,
    ```bash
    $ bin/riemann etc/riemann.config
    ```

* Change server's host address, edit `etc/riemann-config` which has `Clojure` syntax, then 
    ```config
    (let [host "192.168.100.126"]
        (tcp-server {:host host})
        (udp-server {:host host})
        (ws-server  {:host host}))
    ```

* Install `riemann-dash`, for accessing dashboard, we have to create a configuration file too
    ```bash
    $ gem install riemann-dash riemann-tools
    ```
    and create a config file, (I created `config.rb` at `/home/kiran/riemann-0.3.6/etc/config.rb`)
    ```rb
    set  :port, 4567
    set  :bind, "0.0.0.0"
    ```
    run the dashboard along with server to see the dashboard in normal browser of physical host machine, before that, `cd` to the `riemann-0.3.6` directory
    ```bash
    $ cd /home/kiran/riemann-0.3.6

    # start server
    $ bin/riemann etc/riemann.config
    #keep the server running by using one more terminal or hit Ctrl+C

    # start dashboard
    $ riemann-dash etc/config.rb
    ```
    verify by opening a browser and enter `192.168.100.126:4567` to access the dashboard and refer the settings to change IP address on top-right edit text field, & use `Grid` option for the dashboard, and enter `true` in `Query`, hit `apply` and see the results.