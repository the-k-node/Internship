> Topology Description Tasks:

* Ubuntu + FRR

    * VMs' configuration:

        Host | adapter | IP/mask
        :--: | :--: | :--:
        R1 | `enp0s3` | `10.5.1.2/30`
        R2 | `enp0s3` | `10.5.1.6/30`
        R3 | `enp0s3` | `10.5.1.10/30`
        R4 | `enp0s3`<br>`enp0s8`<br>`enp0s9` | `10.5.1.1/30` <br> `10.5.1.5/30`<br>`10.5.1.9/30`

    1. R1, R2, R3, R4: Could be cumulus VX or Ubuntu with Frr ( either is fine )
    2. Host 1 , 2,3 : Ubuntu with FRR

        * Install frr onto ubuntu focal 20.04 operating system.
            ```bash
            $ sudo curl -s https://deb.frrouting.org/frr/keys.asc | sudo apt-key add -
            $ FRRVER="frr-stable"
            $ sudo echo deb https://deb.frrouting.org/frr $(lsb_release -s -c) $FRRVER | sudo tee -a /etc/apt/sources.list.d/frr.list
            $ sudo apt update && sudo apt install frr frr-pythontools
            ```


    3. R1, R2, R3 will form BGP with R4

        * On VM `R4`:
            ```bash
            $ vtysh
            ```
            ```ios
            R4# conf
            R4(config)# router bgp 100
            R4(config-router)# neighbor 10.5.1.2 remote-as 10
            R4(config-router)# neighbor 10.5.1.6 remote-as 20
            R4(config-router)# neighbor 10.5.1.10 remote-as 30
            R4(config-router)# address-family ipv4
            R4(config-router-af)# neighbor 10.5.1.2 activate
            R4(config-router-af)# neighbor 10.5.1.6 activate
            R4(config-router-af)# neighbor 10.5.1.10 activate
            R4(config-router-af)# exit
            R4(config-router)# exit
            !to avoid (Policy) in state column on `sh ip bgp sum` command
            R4(config)# ip prefix-list ROUTE permit any
            R4(config)# router bgp 100
            R4(config-router)# neighbor 10.5.1.2 prefix-list ROUTE in
            R4(config-router)# neighbor 10.5.1.2 prefix-list ROUTE out
            R4(config-router)# neighbor 10.5.1.6 prefix-list ROUTE in
            R4(config-router)# neighbor 10.5.1.6 prefix-list ROUTE out
            R4(config-router)# neighbor 10.5.1.10 prefix-list ROUTE in
            R4(config-router)# neighbor 10.5.1.10 prefix-list ROUTE out
            ```

        * On other router VMs (`R1`,`R2`,`R3`):
            * (`R1` considered)
            ```bash
            $ vtysh
            ```
            ```ios
            R1# conf
            R1(config)# router bgp 10
            R1(config-router)# neighbor 10.5.1.1 remote-as 100
            R1(config-router)# address-family ipv4
            R1(config-router-af)# neighbor 10.5.1.1 activate
            R1(config-router-af)# exit
            R1(config-router)# exit
            !to avoid (Policy) in state column on `sh ip bgp sum` command
            R1(config)# ip prefix-list ROUTE permit any
            R1(config)# router bgp 10
            R1(config-router)# neighbor 10.5.1.1 prefix-list ROUTE in
            R1(config-router)# neighbor 10.5.1.1 prefix-list ROUTE out
            ```
            
            for VMs `R2` & `R3`, ASNs are `20` & `30` respectively.

* Cumulus VX

    * Vms' Configuration:

        Host | adapter | IP/mask
        :--: | :--: | :--:
        R1 | `swp1` | `10.5.1.2/30`
        R2 | `swp1` | `10.5.1.6/30`
        R3 | `swp1` | `10.5.1.10/30`
        R4 | `swp1`<br>`swp2`<br>`swp3` | `10.5.1.1/30` <br> `10.5.1.5/30`<br>`10.5.1.9/30`

    * On `R4`,

        ```nclu
        $ net add bgp autonomous-system 100
        $ net add bgp neighbor 10.5.1.2 remote-as 10
        $ net add bgp neighbor 10.5.1.6 remote-as 20
        $ net add bgp neighbor 10.5.1.10 remote-as 30
        $ net pending
        $ net commit
        ```

    * On `R1`:

        ```nclu
        $ net add bgp autonomous-system 10
        $ net add bgp neighbor 10.5.1.1 remote-as 100
        $ net add bgp ipv4 unicast network 10.5.1.0/30
        $ net pending
        $ net commit
        ```
        similarly for `R2` & `R3`, use ASN `20` & `30` with advertising `10.5.1.4/30` & `10.5.1.8/30` respectively.
        
    * Verify the routes using
         ```bash
         traceroute 10.5.1.20
         or
         net show route 10.5.1.20
         ```
         and can check the hops, routes, & routing protocols utilized.
