> # Task 2

# a. Mesos Master, Marathon, & Zookeeper

- Setup for `java` dependencies

  ```bash
  $ sudo apt-get update
  $ sudo apt install openjdk-16-jre-headless
  $ sudo apt install openjdk-8-jre-headless
  $ update-alternatives --config java
  ```

  select `manual` mode for **java 16**.

  <br>

- Install **Mesos master** on a VM (`VM1`)

  <br>

  1. Install dependencies for installing `mesos` both **master** & **slave**.

    ```bash
    $ sudo apt-get -y install build-essential python3-dev python3-six python3-virtualenv libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev iputils-ping
    $ sudo apt-get install libcurl4-openssl-dev
    ```

    <br>

  2. Install the deb package, download from [here](https://drive.google.com/file/d/1pclLi92cZwkQFarrsjfzIMeCzNdpFYzx/view).

    ```bash
    $ sudo dpkg -i mesos-1.9.0-0.1.20200901105608.deb
    ```

    if find an error for `libevent-dev` package, use

    ```bash
    $ sudo apt-get --fix-broken Install
    ```

    <br>

  3. Check the installation with

    ```sh
    $ apt-cache policy mesos
    ```

    <br>

  4. make required configurations for `mesos-server`,

    <br>

    - Add **1** to the `quorum` file,

      ```sh
      $ sudo vim /etc/mesos-master/quorum
      ```

      <br>

    - Add IP and hostname by making required files and entering IPs into them,

      ```sh
      $ sudo vim /etc/mesos-master/ip
      $ cp /etc/mesos-master/ip /etc/mesos-master/hostname
      ```

      <br>

    - Make sure the `mesos-slave` doesn't start on startup,

      ```sh
      $ echo manual | sudo tee /etc/init/mesos-slave.override
      ```

- Install **Zookeeper** and make required configurations,

  <br>

  1. Check and Install `zookeeper` with `apt`,

    ```sh
    $ apt-cache policy zookeeper
    $ sudo apt-get install zookeeper
    ```

    <br>

  2. Edit and change the `localhost` into the bridged IP address for accessing dashboard from host.

    ```sh
    $ sudo vim /etc/mesos/zk
    ```

    eg: **zk://192.168.100.238:2181/mesos**

    <br>

  3. Enter an **unique** id for each `mesos-master`, in our case - **1** in `myid` file,

    ```bash
    $ sudo vim /etc/zookeeper/conf/myid
    ```

    <br>

  4. Specify IP addresses accessible in `zoo.cfg` file by appending a line like **server.1=192.168.100.238:2888:3888**,

    ```sh
    $ sudo vim /etc/zookeeper/conf/zoo.cfg
    ```

    <br>

- Install **Marathon** and make configurations needed,

  <br>

  1. Setup the required repo

    ```sh
    $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF
    $ DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    $ CODENAME=xenial
    ```

    <br>

  2. Add the repo into apt

    ```sh
    $ echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
    $ sudo apt-get -y update
    ```

    <br>

  3. Check the version we got and insall it,

    ```sh
    $ apt-cache policy marathon
    $ sudo apt-get install marathon
    ```

    <br>

  4. Enter required configuration lines,

    ```sh
    $ sudo vim /etc/default/marathon
    ```

    and add

    ```
    MARATHON_MESOS_USER=root
    MARATHON_MASTER="zk://10.1.1.4:2181/mesos"
    MARATHON_ZK="zk://10.1.1.4:2181/marathon"
    MARATHON_HOSTNAME="10.1.1.4"
    ```

- Restart all the tools we installed and configured,

  <br>

  1. Zookeeper

    ```sh
    $ cd /usr/share/zookeeper/bin
    $ ./zkServer.sh status
    $ ./zkServer.sh start
    ```

  2. Mesos Master

    ```sh
    $ sudo service mesos-master restart
    ```

  3. Marathon

    ```sh
    $ sudo service mesos-master restart
    ```
