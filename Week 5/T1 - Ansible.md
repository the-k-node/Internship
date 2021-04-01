## Task1 - Introduction to Ansible

* Install `ansible` using any available package managers like `homebrew` for mac that I already have installed or `apt` for debian distributions
    ```bash
    $ brew install ansible
    ```
    and for `apt` package manager,
    ```bash
    $ sudo apt-get update 
    $ sudo apt-get install software-properties-common 
    $ sudo apt-add-repository ppa:ansible/ansible 
    $ sudo apt-get update 
    $ sudo apt-get install ansible
    ```
    and verify the installation using `ansible version` command
    ```bash
    $ ansible --version
    ```

* For Ansible, we need one Controller node and can have multiple Managed nodes, so I have created 4 VMs : 1 Controller Node and 3 Managed nodes. IP addresses associated with all these nodes are
    * Controller Node : 
        * `control-node` : `172.10.10.101`
    * Managed Nodes :
        1. `m-node-1` : `172.10.10.201`
        2. `m-node-2` : `172.10.10.202`
        3. `m-node-3` : `172.10.10.203`

* Ansible uses `SSH` for connecting to its managed nodes, so we need to configure ssh on all nodes along with passwordless authentication. I have same username for user accounts configured in all nodes (3 managed & 1 control node) i.e username: `kiran` to smoothen the configuration process.

* In managed node : 
    ```bash
    $ sudo vim /etc/ssh/sshd_config
    ```
    and make line `PasswordAuthentication` to `yes` from `no`
    ```bash
    PasswordAuthentication yes
    ```
    this should be done on all 3 managed nodes - `m-node-1`, `m-node-2`, `m-node-3` .

* In `control-node` :
    `below commands are run from 'kiran' user not 'root'`
    ```bash
    $ ssh-keygen                        #generates ssh keys
    $ ssh-copy-id 172.10.10.201         #copies the public key to 'm-node-1'
    $ ssh-copy-id 172.10.10.202         #copies the public key to 'm-node-2'
    $ ssh-copy-id 172.10.10.203         #copies the public key to 'm-node-3'
    ```
    and enter the password configured for the user `kiran` in each node, and thus adds public key of `control-node` to all nodes to facilitate ssh connection.
* Before veriffying the ssh connections through ansible, we have to mention all our managed nodes IPs/FQDNs in a inventory file, default file will be located in `/etc/ansible/hosts`, he you can mention IPs and also create groups of nodes
    ```
    [nodes]
    172.10.10.201
    172.10.10.202
    172.10.10.203
    ```
    here, `nodes` is the group name which has all the below mentioned nodes in it, and I can just mention `nodes` to mention those nodes than separately entering IPs/FQDNs.


* Test the Ansible's ssh connection through `ping` option
    ```bash
    $ ansible all -m ping
    ```
    and if this returns `SUCCESS` for each node or returns `"ping": "pong"` for each node, then the connection is successful.

* For running a command on the managed-nodes, I have considered 2 commands, `hostname` which gives the name of the nodes, and `hostname -I` which gives the IP addresses of nodes. For achieving that, I need to create a new `yaml` file for my ansible `playbook` with contents (indentation is important).

    [task1.yml](https://github.com/alwaysiamkk/Internship/blob/main/Week%205/task1.yml) :
    ```yaml
    ---
    - name: Get Nodes Names and IPs
      remote_user: kiran
      hosts: nodes
      serial: 1
      tasks:
        - name: Node Names
          command: hostname
          register: output1
        - name: output_write_node_name
          lineinfile:
            dest: /home/kiran/Documents/output
            line: "{{ output1.stdout }}"
        - name: Node IPs
          command: hostname -I
          register: output2
        - name: output_write_node_ip
          lineinfile:
            dest: /home/kiran/Documents/output
            line: "{{ output2.stdout }}"
    ```
    here, I have 2 main commands as stated before and storing the output of those commands using another task named `output_write_node_name` and `output_write_node_ip` which take the ouput of commands using the value of `register` and using that in `line` with deserializing the main pack and taking only `stdout` which is our output and this file is named as `ans_conf.yml` in my present working directory(`/home/kiran/Documents/ans_conf.yml`).

* After configuring the yaml file, we just need one more package called `sshpass` for `ansible-playbook` to accomplish the task, it has be installed only in `control-node`,
    ```bash
    $ sudo apt-get install sshpass
    ```

* Now we can run the `ansible-playbook` command to get the results and store them in `/home/kiran/Documents/output` file which is defined in my yaml file by running,
    ```bash
    $ ansible-playbook -u root ans_conf.yml -k
    ```
    and enter `SSH` password when promps and here, I have considered `root` user to avoid access denial errors.

* To verify the contents of `output`, just cat it
    ```bash
    $ cat output
    ```
    and my contents are
    ```
    m-node-1
    192.168.100.72 172.10.10.201 
    m-node-2
    192.168.100.73 172.10.10.202 
    m-node-3
    192.168.100.74 172.10.10.203
    ```
    thus verifies my hostnames and IPs that I have mentioned at the start of this task.
