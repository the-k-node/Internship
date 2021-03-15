* For making VMs communicate each other, we atleast need two Virtual machines (ubuntu focal server, ubuntu client edition are considered).

* After successfully installing VMs with their respective ISOs, complete the setup and install the OS into the machines.

* Now, Open `Preferences` option of VirtualBox (if can't be visible, click on `VirtualBox` on the left top corner tab, it opens a dropdown menu, select `Preferences`)

* In Preferences Window, go for `Network` tab.

* Create a new custom NAT network by clicking the option with a `+` icon stating `Adds New NAT network` option, it adds a new network.

* Click on the newly added network and select `Edits selected NAT network` option and this opens a new window to edit its details.

* Change the details as follows
    Network Name | Network CIDR
    :---: | :---:
    Any desired name (used 'KNAT') | Any desired network id with a `0` at the end with a subnet of `/24` (used `192.168.1.0/24`)
    
    Network Options
    :---:
    * [x] Supports DHCP
    * [ ] Supports IPv6
    
    and Save it

* Go to the settings of each VM, and select `Network` tab, here you can see the `Attached to` selection will be (most probably) `NAT`, change it to `NAT Network` and in `Name` select the newly created NAT network (in my case `KNAT`). Do this step for as many as VMs that we need to communicate with each other.

* The above step is performed to make the VMs to have same Network ID to be on same LAN network to facilitate the communication among them through NAT(Network Address Translation) network having DHCP enabled to generate unique IP to all the VMs of that network (If one more VM added to the network, it would get an IP 192.168.1.6 as .4 and .5 are already assigned).

* Now start the VMs, and after they get booted-up, open terminal and check for the IPs assigned using either `ifconfig` or `ip add show`, and check the IP assigned for Ethernet adapter which might have an id starting with `enp0s*`. 
    Mine were: 
    ```
    Server VM: 192.168.1.4

    Client VM: 192.168.1.5
    ```

* Now ping the IPs in alternative machine respective to the IPs got from i.e:
    In Server terminal:
    ```
    ping 192.168.1.5
    ```
    and in Client terminal:
    ```
    ping 192.168.1.4
    ```
    when these commands run, they should show packets received more than the packet loss (preferebly 0% packet loss), and stop the pinging using Ctrl+C command to get the results
