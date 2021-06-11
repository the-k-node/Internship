>Task 3:

* For establishing BGP connections between each Host and its corresponding leaf (router), we can advertise loopback IPs of Host to the Rs.

* Create 2 VRFs and add required hosts on each of them, use these commands on Spine - `R4`,
    ```nclu
    # net add vrf vrf-1 vrf-table auto
    # net add interface swp1 vrf vrf-1            #swp1 - 10.5.1.1
    # net add interface swp2 vrf vrf-1            #swp2 - 10.5.1.5

    # net add vrf vrf-2 vrf-table auto
    #net add interface swp3 vrf vrf-2             #swp3 - 10.5.1.9

    # net commit
    ```
    check the vrfs created using `vrf list` - eg:
    ![output - vrf list](https://github.com/alwaysiamkk/Internship/blob/main/Week%2010%20%26%2011/t3.1.vrf%20list.png)

* Now, we need a routing protocol to redistribute routes on any changes made to the vrfs. We use eBGP, on Spine - `R4`

    * Delete the existing BGP system,
        ```nclu
        # net del bgp autonomous-system 100
        # net commit
        ```

    * Configure eBGP on vrfs,
        ```nclu    
        # net add bgp vrf vrf-1 autonomous-system 100
        # net add bgp vrf vrf-1 neighbor 10.5.1.2 remote-as 10
        # net add bgp vrf vrf-1 neighbor 10.5.1.6 remote-as 20

        # net add bgp vrf vrf-2 autonomous-system 100
        # net add bgp vrf vrf-2 neighbor 10.5.1.10 remote-as 30

        # net pending
        # net commit
        ```
    * Verify the routes and bgp summary,
        ```nclu
        # net show route vrf vrf-1
        # net show route vrf vrf-2

        # net show bgp vrf vrf-1 sum
        # net show bgp vrf vrf-2 sum
        ```

* Check the configuration on hosts using `ip route` command to see the routes distributed by the Spine to the vrf host is in.

* Verify the final result by pinging the loopback IPs,
    ```bash
    $ ping 10.10.1.2 -I 10.10.1.1             #from H1 to H2 - should ping
    $ ping 10.10.1.3 -I 10.10.1.1             #from H1 to H3 - shouldn't ping
    ```
    vice-versa should also produce satisfying results.

* Now, move Host2 to the `vrf-2` and check the same with `H1` being separated in `vrf-1` and `H2` & `H3` are in a discoverable network. On Spine - `R4`,
    ```nclu
    # net del interface swp2 vrf vrf-1                                #remove from `vrf-1`
    # net add interface swp2 vrf vrf-2                                #add to `vrf-2`

    # net del bgp vrf vrf-1 neighbor 10.5.1.6 remote-as 20            #remove the neighbor from vrf-1 bgp configuration
    # net add bgp vrf vrf-2 neighbor 10.5.1.6 remote-as 20            #add the neighbor to vrf-2 bgp configuration
    
    # net pending
    # net commit
    ```

* Finally verify the setup by checking the routes and using ping command to verify the connection configured.
