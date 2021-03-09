• Go to VBOX 'Preferences', Go to 'Nework' tab and click on 'Add a new NAT', then edit the newly created NAT using 'Edit Selected NAT' option.

• Enter a Network name, change the Network CIDR to any desired address, check in 'Supports DHCP' option.

• As we need to even persist our SSH option for authentication, click on 'Port Forwarding' and add a record of similar details except the 'Guest IP' as we assigned new CIDR block.

• Get the DHCP assigned address from server using 'ifconfig' or 'ip addr show' commands and enter it into the 'Guest IP' field in 'Port Forwarding' section.

    Name - SSH, Protocol - TCP, Host IP - 127.0.0.1, Host Port - 2200, Guest IP - 192.168.1.4 (in my case, changes depending on the CIDR entered and DHCP), Guest Port - 22

• Save the preferences and check SSH feature to verify that it's still working.

• Now, to check the server is accessed only through VM IPs, go to client VM and ping the address of server and vice-versa. But doesn't work with outside hosts or localhost

• Now, open the server page in client system to verify the restrictions set, if it works in client VM and doesn't work in other hosts, then requirement is met.
