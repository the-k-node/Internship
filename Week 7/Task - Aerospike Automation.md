### Ansible Aerospike Tasks

> VM  Configuration

node name | IP address
:--: | :--:
`control-node` | 192.168.100.97
`m-node-1` | 192.168.100.98
`m-node-2` | 192.168.100.99
`m-node-3` | 192.168.100.100

`All tasks playbook` : [tasks.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/tasks.yml)

* Install and configure 3 node Aerospike cluster version 4.8.0.6.

    * File : [ins_clus_as.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/ins_clus_as.yml).

    * Has 2 roles, one to install aerospike and another to check the cluster status and give result in debug console.

        1. [install_as](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/roles/install_as/tasks/main.yml).
        2. [cluster_as](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/roles/cluster_as/tasks/main.yml).

* Data should be persisted on disk & Create a namespace Orders.

    * File : [pers_dev.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/pers_dev.yml).

    * Has one role to manipulate the `/etc/aerospike/aerospike.conf` file to change `storage-engine` from `memory` to `device` add required features like `file`,etc in its stanza and rename existing `bar` namespace to `orders` and change the file attribute to `orders.dat` in orders namespace stanza - [orders_data_pers](https://github.com/alwaysiamkk/Internship/blob/main/Week%207/roles/orders_data_pers/tasks/main.yml).
