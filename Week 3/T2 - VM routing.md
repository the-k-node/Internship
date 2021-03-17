* We need an Internal network with VMs to establish 2 LANs and communicate among them.

* Configure VM1 and VM3 as end hosts and VM2 as router by making required settings like

    VM1:
    Adapter | Network | Network Name
    :---: | :---: | :---:
    1 | `Internal Network` | `intnet_a`

    VM2:
    Adapter | Network | Network Name
    :---: | :---: | :---:
    1 | `Internal Network` | `intnet_a`
    2 | `Internal Network` | `intnet_b`

    VM3:
    Adapter | Network | Network Name
    :---: | :---: | :---:
    1 | `Internal Network` | `intnet_b`

    just to make sure we will have two different networks

* For later versions of Ubuntu, we use `netplan` network configurations to configure all network interfaces and routes we require, for that we need to edit the `/etc/netplan/<yaml file>`, here the yaml file's name is different for different versions of ubuntu using

* The yaml configurations we need to make for each VM are:
    
    VM1:
    static IP: 192.168.10.4
    gateway: 192.168.10.1
    Routes: 
        packets
            * to: 192.168.20.0/24 network
            * through hop: 192.168.10.5
    ```yaml
    network:
        version: 2
        renderer: networkd
        ethernets:
            enp0s8:             #interface with intnet_a internal network
                dhcp4: no
                addresses:
                    - 192.168.10.4/24
                gateway4: 192.168.10.1
                routes:
                    - to: 192.168.20.0/24
                      via: 192.168.10.5
                      metric: 100
    ```
    VM2:
    static IP: 
        enp0s3 
            * adapter : 192.168.10.5
            * gateway : 192.168.10.1
        enp0s8 
            * adapter : 192.168.20.5
            * gateway : 192.168.20.1
    Routes: 
        VM1 packets
            * from: 192.168.10.1 gateway
            * to: 192.168.20.0/24 network
        VM3 packets
            * from: 192.168.20.1 gateway
            * to: 192.168.10.0/24 network
    ```yaml
    network:
        renderer: networkd
        version: 2
        ethernets:
            enp0s3:             #interface with intnet_a internal network
                dhcp4: no
                addresses:
                    - 192.168.10.5/24
                gateway4: 192.168.10.1
                routes:
                    - to: 192.168.10.0/24
                      via: 192.168.20.1
                      metric: 100
            enp0s8:             #interface with intnet_b internal network
                dhcp4: no
                addresses:
                    - 192.168.20.5/24
                gateway4: 192.168.20.1
                routes:
                    - to: 192.168.20.0/24
                      via: 192.168.10.1
                      metric: 100
    ``` 

    VM3:
    static IP: 192.168.10.4
    gateway: 192.168.10.1
    Routes: 
        packets
            * to: 192.168.10.0/24 network
            * through hop: 192.168.20.5
    ```yaml
    network:
        renderer: networkd
        version: 2
        ethernets:
            enp0s8:             #interface with intnet_b internal network
                dhcp4: no
                addresses:
                    - 192.168.20.4/24
                gateway4: 192.168.20.1
                routes:
                    - to: 192.168.10.0/24
                      via: 192.168.20.5
                      metric: 100
    ```

* To make them work, save the files & apply the settings using
    ```bash
    sudo netplan apply
    ``` 
    command and restart the network service with
    ```bash
    service systemd-networkd restart
    ```
    command and check whether the routes are added correctly using
    ```bash
    route -n
    or
    ip route
    ```
    command.
    
* Now, edit `/etc/sysctl.conf` file and uncomment a line with
    ```bash
    net.ipv4.ip_forward=1
    ```
    and save & load the changes using 
    ```bash
    sudo sysctl -p /etc/sysctl.conf
    ```

* Now verify the host reachability using `ping` command using VMs IP addresses as per needed connectivity:
    * VM1 <-> VM2(router)
    VM1 : `ping 192.168.10.5`
    VM2 : `ping 192.168.10.4`

    * VM2 (router) <-> VM3
    VM2 : `ping 192.168.20.4`
    VM3 : `ping 192.168.20.5`

    * VM1 <-> VM3 through Router VM2
    VM1 : `ping 192.168.20.4`
    VM3 : `ping 192.168.10.4`

    check whether all the ping commands return no packet loss and receives all packets.
