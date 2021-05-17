>Task 1:

![topology](https://github.com/alwaysiamkk/Internship/blob/main/Week%2010%20%26%2011/t1.topology.png)

* In above topology, we see `R4` is `Spine` and `R1`, `R2`, & `R3` are `leaves` in a Spine-leaf architecture.

* After establishing the BGP between R1, R2, R3, & R4, we need to setup loopback interfaces for all leaves to enable VTEP and activate neighbors through `evpn` address family

    * On `R1`,
      ```nclu
      $ net add loopback lo ip add 1.1.1.1/32
      $ net add bgp l2vpn evpn neighbor 10.5.1.1 activate
      $ net commit
      ```

    * On `R2`,
      ```nclu
      $ net add loopback lo ip add 2.2.2.2/32
      $ net add bgp l2vpn evpn neighbor 10.5.1.5 activate
      $ net commit
      ```

    * On `R3`,
      ```nclu
      $ net add loopback lo ip add 3.3.3.3/32
      $ net add bgp l2vpn evpn neighbor 10.5.1.9 activate
      $ net commit
      ```

    * On `R1`,
      ```nclu
      $ net add loopback lo ip add 100.0.0.100/32
      $ net add bgp l2vpn evpn neighbor 10.5.1.2 activate
      $ net add bgp l2vpn evpn neighbor 10.5.1.6 activate
      $ net add bgp l2vpn evpn neighbor 10.5.1.10 activate
      $ net commit
      ```

* Verify the configurations on spine using
    ```nclu
    $ net show bgp l2vpn evpn summary
    ```
    that should display all the three node addresses under this address family.

* We need to advertise loopback IPs, each leaf node advertises its own lo IP eg- `R1` advertises `1.1.1.1`,
    ```nclu
    $ net add bgp network <loopackIP>/32
    $ net commit
    ```

* Now, each leaf would be aware of other leaf's loopback IP, check using
    ```nclu
    $ net show bgp ipv4 unicast
    ```
    and verify the connection using `ping` between loopback IPs using `-I` option,
    ```nclu
    $ ping 2.2.2.2 -I 1.1.1.1       #from R1's lo to R2's lo
    ```

* So, we have the complete underlay setup, now we need the overlay for creating the required tunnel and learning the addresses using Control-pane learning method (BUM traffic not handled). So now, we have to create a VNID using a VLAN number and create a virtual interface for VTEP.

* Create a new virtual interface `vni10`, and associate it with VNID `10` & add VLAN `10` to `vni10`. On all leaf nodes,
    ```nclu
    $ net add vxlan vni10 vxlan id 10
    $ net add vxlan vni10 bridge access 10
    $ net add vxlan vni10 bridge learning off
    $ net add bgp evpn advertise-all-vni          #to provision all locally configured VNIs to be advertised by the BGP control plane      
    ```
    now we need to specify the loopback IP for making it as the source tunnel ip,
    ```nclu
    $ net add vxlan vni10 vxlan local-tunnelip 1.1.1.1     #for R1 lo
    ```
    similarly add for `R2` & `R3` with their respective lo s and commit the changes.

* Now we need to make some changes to the `/etc/network/interfaces` file on all leaf nodes to facilitate `swp2` port to be a part of the mac address learning,
    ```
    auto swp2
     iface swp2
         ...
         bridge-access 10

     auto bridge
     iface bridge
         ...
         bridge-ports swp2 vni10
         ...
    ```
    and then `ifreload -a` to apply the changes made.

* Now, check the macs available per leaf node,
    ```nclu
    $ net show bridge macs vlan 10
    ```
    you should be seeing no nodes, or only one i.e the current leaf node's mac. For making vni to learn hosts mac addresses, we need to restart all hosts `H1`, `H2`, & `H3`, one by one. This forces a GARP to be sent out when each host comes up and this GARP causes hosts' mac to be learnt on swp2 of each leaf node.

* Check the macs learnt on each leaf using,
    ```nclu
    $ net show bridge macs
    ```
    this time you should be able to see multiple mac addresses having interface as `vni10` which are learnt through that vni10 tunnel and a mac learnt locally or `self` through `swp2` port. For example (in `R1`),

    ![macs-learnt-screenshot](https://i.ibb.co/mG73tGj/macs-learnt-output.png)

* Verify the setup and try
    ```nclu
    $ ping 10.3.1.2           #from H1
    $ traceroute 10.3.1.2     #would display only 1 node, as it has no idea about the underlays
    ```
    try for all other hosts too.
