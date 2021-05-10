> Aerospike Data Replication

* Aerospike uses certain standards and techniques for the data replication among its nodes.

* The Aerospike Data Migration module intelligently balances data distribution across all nodes in the cluster, ensuring that each bit of data replicates across all cluster nodes and datacenters. This operation is specified in the system replication factor configuration.

* Each node uses a distributed hash algorithm to divide the primary index space into data slices and assign owners. Each primary key is  hashed into a 160-byte digest using the RipeMD160 algorithm.

* Data Distribution Diagram:
![aerospike data distribution](https://github.com/alwaysiamkk/Internship/blob/main/Week%206/Data%20Distribution.png)

* Aerospike colocates indexes and data to avoid any cross-node traffic when running read operations or queries. Writes may require communication between multiple nodes based on the replication factor.

* This data replication technique ensures that
    1. Application workload is uniformly distributed across the cluster,
    2. Performance of database operations is predictable,
    3. Scaling the cluster up and down is easy, and
    4. Live cluster reconfiguration and subsequent data rebalancing is simple, non-disruptive and efficient.

* A partition assignment algorithm generates a replication list for every partition. The replication list is a permutation of the cluster succession list.
    ![partition map]()