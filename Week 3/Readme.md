># Tasks - Week 3

```
Topic : Network basics
```
 
1. Bridge connectivity or L2 connectivity:
- Create two VMs, assign an IP from the same /24 subnet and establish connectivity between those two VMs
`Test for connectivity: two VMs should be able to ping each other`

2. L3 Connectivity:
- Create 3 VMs and establish connectivity in following manner,
```
VM1 <-> VM2
VM3 <-> VM2
VM1<->VM3 ( via VM2 as router )
```
`Test: same as #1`

3. NAT on router VM
    * Create 3 VMs and connect them as #2
    * Router VM (i.e VM2) will accept connections on its own IP and port 2222 and forward the packets to VM3 on port 22.

    example: 
    ```
    VM1 connects to  VM2 port 2222
    VM2 forwards the traffic to VM3 port 22
    Result, VM1 is connected to VM3`s port 22 ( via VM2`s port 2222)
    ```

4. Dynamic routing
    * Implement #2 and #3, with BGP as routing ( using software FRR ) , and run the same tests as of #2 and #3

5. Create 4 VMs
    * Connect them as #2 
    * Install Librenms in one of the VM and setup monitoring of other 3 VMs
