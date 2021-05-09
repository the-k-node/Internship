>Topology Description Tasks:

VMs' configuration:

Host | adapter | IP/mask
:--: | :--: | :--:
R1 | `enp0s3`<br>`enp0s8` | `10.5.1.2/30` <br> `10.3.1.11/24`
R2 | `enp0s3`<br>`enp0s8` | `10.5.1.6/30` <br> `10.3.1.12/24`
R3 | `enp0s3`<br>`enp0s8` | `10.5.1.10/30` <br> `10.3.1.13/24`
R4 | `enp0s3`<br>`enp0s8`<br>`enp0s9` | `10.5.1.1/30` <br> `10.5.1.5/30`<br>`10.5.1.9/30`
H1 | `enp0s3` | `10.3.1.1/24`
H2 | `enp0s3` | `10.3.1.2/24`
H3 | `enp0s3` | `10.3.1.3/24`

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