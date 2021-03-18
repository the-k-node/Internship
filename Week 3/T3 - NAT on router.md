* Port Forwarding using NAT table can be achieved by 2 ways:
    * editing `/etc/iptables/rules.v4` file
    * running `iptables` commands

* We initially need to have a tool called `iptables-persistent` for having the table persistent across reboots, for installing the tool, run
    ```bash
    sudo apt install -y iptables-persistent
    ```
    this tools also creates a file for specifying all the rules we need to set or modify at `/etc/iptables/` both for IPv4 & IPv6.

* In VM2 (router), I want to make the interface `enp0s8` to forward traffic received from VM1 through VM2's PORT `2222` , for that I need to have chains specified in NAT table

* We can add required rules as chains in NAT table using `iptables` command or edit `/etc/iptables/rules.v4` (as version4 addresses are used here)

* We have 3 main chains to be added in our router 
    ```md
    * PREROUTING
    * FORWARD
    * POSTROUTING
    ```
    the commands used and changes made to `rules.v4` file are:
    ```bash
    -A FORWARD -i enp0s3 -o enp0s8 -p tcp --syn -n conntrack --ctstate NEW -j ACCEPT
    -A FORWARD -i enp0s3 -o enp0s8 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    -A FORWARD -i enp0s8 -o enp0s3 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    COMMIT

    *nat
    :PREROUTING ACCEPT [0:0]
    :INPUT ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    :POSTROUTING ACCEPT [0:0]

    -A PREROUTING -i enp0s3 -p tcp -j DNAT --to-destination 192.168.20.5:2222
    -A POSTROUTING -d 192.168.20.0/24 -o enp0s8 -p tcp --dport 2222 -j SNAT --to-source 192.168.20.5:2222
    ```
    here, 
    * `enp0s3` : network interface to receive/send traffic from VM1
    * `enp0s8` : network interface to receive/send traffic from VM2
    * `-p` is used to specify the protocol, here it's `tcp`
    * `DNAT` (Destination NAT) is to change the destination address for the packet that VM2 receives from VM1, and we specify `--to-destination` for specifying the IP address / network / with port
    * PREROUTING works when interface sends the packets to modify the destination
    * POSTROUTING works when the packet returns from the destination to the source, here we need to change the source into destination and vice-versa, so we specify it using `SNAT` - Source NAT. This can also be achieved using `MASQUEARADE` by changing line into:
        ```bash
        -A POSTROUTING ! -d 192.168.20.0/24 -o enp0s8 -j MASQUERADE
        ```

* After the changes are made, run
    ```bash
    iptables restore -t < /etc/iptables/rules.v4
    ```
    command, if this returns no syntactical errors, then we can verify the results using 
    ```bash
    iptables -S                 #shows rules
    or 
    iptables -L                 #shows rules in table format 
    or
    iptables -t nat             #shows rules from only NAT table
    or
    iptables -t nat -vnL        #shows rules with many metrics
    ```
    commands.
