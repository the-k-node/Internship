* Topology asked to establish was
    ![alt text](https://github.com/alwaysiamkk/Internship/blob/main/Week%203/Week3.png "BGP Network Topology")

* Here we can observer the topology of VMs and its interfaces, for configuring BGP, I consider eBGP (external Border Gateway Protocol) to be my choice.

* Install `frr` software in all 3 VMs and edit `/etc/netplan/<yaml-file>` in each VM according to the IP addresses assigned in above topology, my netplan configuration has:
    ```
    * vm-router :
        * Interfaces : 
            * lo - 10.1.1.1/32
            * enp0s3 - 172.10.0.1/30
            * enp0s8 - 172.10.0.5/30
            * enp0s9 - 172.10.0.9/30    
    * vm-1 : 
        * Interfaces :
            * lo - 10.1.1.2/32
            * enp0s3 - 172.10.0.2/30
    * vm-2 : 
        * Interfaces :
            * lo - 10.1.1.3/32
            * enp0s3 - 172.10.0.6/30
    * vm-3 : 
        * Interfaces :
            * lo - 10.1.1.4/32
            * enp0s3 - 172.10.0.10/30
    ```

* Edit the daemons fileat `/etc/frr/daemons` and make `bgp=yes` for all vms, and also make ipv4 forwarding true at `etc/sysctl.conf` and make `net.ipv4.ip_forward=1` (remove the # infront of the statement).

* To establish BGP sessions, ensure `frr` is running and for confirmation, run `systemctl restart frr.service` this makes both `zebra` and `bgpd` daemons to run (should be done in all 4 vms), then configure BGP session by,
    * In `vm-router` :
        * Go to `vtysh` and `conf` and enter the commands :
            ```
            (config)#router bgp 10
            (config-router)#neighbor 172.10.0.2 remote-as 1
            (config-router)#neighbor 172.10.0.6 remote-as 2
            (config-router)#neighbor 172.10.0.10 remote-as 3
            (config-router)#address-family ipv4
            (config-router-af)#neighbor 172.10.0.2 activate
            (config-router-af)#neighbor 172.10.0.6 activate
            (config-router-af)#neighbor 172.10.0.10 activate
            ```
    * In `vm-1` :
        * Go to `vtysh` and `conf` and enter the commands :
            ```
            (config)#router bgp 1
            (config-router)#neighbor 172.10.0.1 remote-as 10
            (config-router)#address-family ipv4
            (config-router-af)#neighbor 172.10.0.1 activate
            ```
    * In `vm-2` :
        * Go to `vtysh` and `conf` and enter the commands :
            ```
            (config)#router bgp 2
            (config-router)#neighbor 172.10.0.5 remote-as 10
            (config-router)#address-family ipv4
            (config-router-af)#neighbor 172.10.0.5 activate
            ```
    * In `vm-3` :
        * Go to `vtysh` and `conf` and enter the commands :
            ```
            (config)#router bgp 3
            (config-router)#neighbor 172.10.0.9 remote-as 10
            (config-router)#address-family ipv4
            (config-router-af)#neighbor 172.10.0.9 activate
            ```
    now if you check the BGP session by running `sh ip bgp sum`, you can see under each neighbor's state is changed it into a number (mine was `0`), this was achieved as we used `activate` command to start exchanging the details from specified address.

* For Filters, we have 3 of them to do
    1. vm-router orginates and sends default route to vm-1 , vm-2 and vm-3
        * In vm-router :
        ```
        (config)#router bgp 10
        (config-router)#address-family ipv4
        (config-router-af)#neighbor 172.10.0.2 default-originate
        (config-router-af)#neighbor 172.10.0.6 default-originate
        (config-router-af)#neighbor 172.10.0.10 default-originate
        ```
        * Now verify the routes using
        ```
        # sh ip bgp
        or
        # sh ip route
        ```
        here you can see new default root got added showing `0.0.0.0/0` next hop is address of router's interface connected this machine and in case of command 2, it shows the Code from which the connection got established check for `B`, if found then default route is successfully advertised.
    
    2. Each of the vms ( vm1, 2, 3 ) will accept only default route from its bgp peer ( vm-router) and advertise their own loopback(IP on its lo interface ) to vm-router. 
        We use prefix-list for this purpose
        * In each VM :
        ```
        (config)#ip prefix-list IN_FIL seq 10 permit 0.0.0.0/0
        (config)#router bgp <ASN>
        (config-router)#neighbor <vm-router interface IP> prefix-list IN_FIL in
        ```
        this makes the VMs to receive the default routes advertised by `vm-router`. For advertising own loopback IPs, in each VM (vm-1 is considered):
        ```
        (config)#router bgp 1
        (config-router)#network 10.1.1.2/32 
        ```
        this command advertises the loopback interface IP into the `vm-router` from there, BGP takes care to inject into the BGP routes table. To verify, run
        ```
        #sh ip bgp
        or
        #sh ip route
        ```
        in `vm-router` to see all the routes that it learnt through the vms advertisements.
    
    3. vm-router to accept /32 IPs that belong to subnet (10.1.1.0/24) and reject all other routes.
        * In `vm-router` :
        ```
        (config)#ip prefix-list IN_RFIL seq 10 permit 10.1.1.0/24 le 32
        (config)#ip prefix-list IN_RFIL seq 5 deny any
        (config)#router bgp <ASN>
        (config-router)#neighbor 172.10.0.2 prefix-list IN_RFIL in
        (config-router)#neighbor 172.10.0.2 prefix-list IN_RFIL in
        (config-router)#neighbor 172.10.0.2 prefix-list IN_RFIL in
        ```

* So the solution topology would be :
    ![alt text](https://github.com/alwaysiamkk/Internship/blob/main/Week%203/w3%20task6.%20solution%20topology.png "Solution Topology Diagram")

* Finally to verify our complete task, test using `ping` between
    * `vm-1` : 
        ```
        ping 10.1.1.3
        ping 10.1.1.4
        ```
    * `vm-2` : 
        ```
        ping 10.1.1.2
        ping 10.1.1.4
        ```
    * `vm-3` : 
        ```
        ping 10.1.1.3
        ping 10.1.1.2
        ```
    these commands should return no packet loss, then the task is completed successfully.
