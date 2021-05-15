>Task 2:

* L3 connectivity using Hosts loopback IPs,

    Host | interface | IP
    :--: | :--: | :--:
    H1 | `lo` | `10.10.1.1/32`
    H2 | `lo` | `10.10.1.2/32`
    H3 | `lo` | `10.10.1.3/32`

* Add hosts into e-BGP with either their own ASN or internal to each leaf `R` and advertise host loopbacks to the BGP.

    * Adding hosts to e-BGP, on `R1`,
      ```nclu
      $ net add bgp neighbor 10.3.1.1 remote-as 1           #in case of different ASN else mention `internal` in place of `1`
      $ net commit
      ```
      same for `R2` with `10.3.1.2` - ASN `2`, and `R3` with `10.3.1.3` - ASN `3`. On hosts (`H1` is considered),
      ```bash
      $ vtysh
      ```
      ```vtysh
      # conf
      (config)# router bgp 1
      (config-router)# neighbor 10.3.1.11 remote-as 10
      (config-router)# address-family ipv4
      (config-router-af)# neighbor 10.3.1.11 activate

      #do the prefix-list method to allow traffic in & out of the neighbor
      ```
    similarly on `H2`, ASN `2` - neighbor `10.3.1.22` & on `H3`, ASN `3` - neighbor `10.3.1.33`

    * Now, we have to advertise the loopback IPs of hosts to make sure that BGP learns these IPs. For `H1`,
        ```vtysh
        (config-router)# address-family ipv4
        (config-router-af)# network 10.10.1.1/32
        ```
      similarly, for `H2` - network `10.10.1.2/32` & for `H3` - network `10.10.1.3/32`

    * Verfify the routes using `show bgp summary` for ubuntu & `net show bgp sum` for cumulus linux, and check the connections using
        ```bash
        $ ping 10.10.1.2 -I 10.10.1.1           #on H1
        ```

* Setting up a GRE tunnel between ubuntu hosts(`H1` & `H3` are the target hosts) require a module called `ip_gre`, check using

    Host | lo IP | tunnel interface IP
    :--: | :--: | :--:
    H1 | `10.10.1.1/32` | `192.168.200.1/24`
    H3 | `10.10.1.3/32` | `192.168.200.2/24`

    ```bash
    $ sudo modprobe ip_gre        #install if not available
    $ lsmod | grep gre
    ```
    you should see lines including `ip_gre` & `gre`, then you can proceed.

* We need to enable ipv4 traffic forwarding on both the hosts by editing `/etc/sysctl.conf` file,
    ```conf
    ...
    net.ipv4.ip_forward=1
    ...
    ```
    either add this line or find and uncomment.

* Create a new network interface to be used by GRE tunnel, on `H1`,
    ```bash
    $ sudo ip tunnel add gre-int mode gre local 10.10.1.1 remote 10.10.1.3 ttl 255
    $ sudo ip addr add 192.168.200.1/24 dev gre-int
    $ sudo ip link set gre-int up
    ```
    and similarly on `H3`,
    ```bash
    $ sudo ip tunnel add gre-int mode gre local 10.10.1.3 remote 10.10.1.1 ttl 255
    $ sudo ip addr add 192.168.200.2/24 dev gre-int
    $ sudo ip link set gre-int up
    ```
    this creates a new interface named `gre-int` that we use to establish a GRE tunnel.

* Verify the connection established through GRE tunnel,
    ```bash
    $ ping 192.168.200.2 -I 192.168.200.1           #on H1 & `-I` is used, as we need to use the virtual interface to verify the tunnel
    ```
