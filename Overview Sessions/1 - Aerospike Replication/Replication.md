>### Aerospike Data Replication

* Aerospike uses certain standards and techniques for the data replication among its nodes.

* The Aerospike Data Migration module intelligently balances data distribution across all nodes in the cluster, ensuring that each bit of data replicates across all cluster nodes and datacenters. This operation is specified in the system replication factor configuration.

* Each node uses a distributed hash algorithm to divide the primary index space into data slices and assign owners. Each primary key is  hashed into a 160-byte digest using the RipeMD160 algorithm.

* Data Distribution Diagram:

    ![aerospike data distribution](https://i.ibb.co/cws7Q56/Data-Distribution.png)

* Aerospike colocates indexes and data to avoid any cross-node traffic when running read operations or queries. Writes may require communication between multiple nodes based on the replication factor.

* This data replication technique ensures that
    1. Application workload is uniformly distributed across the cluster,
    2. Performance of database operations is predictable,
    3. Scaling the cluster up and down is easy, and
    4. Live cluster reconfiguration and subsequent data rebalancing is simple, non-disruptive and efficient.

* A partition assignment algorithm generates a replication list for every partition. The replication list is a permutation of the cluster succession list.

    ![partition map](https://i.ibb.co/jTfjfSk/Partition-Map.png)

* The process of moving records from one node to another node is termed a migration.

* Once consensus is reached on a new cluster view, all the nodes in a cluster run the distributed partition assignment algorithm and assign the master and one or more replica nodes to each of the partitions.

* Conclusion: 
    * Uniform distribution of data, associated metadata like indexes, and transaction workload make capacity planning and scaling up and down decisions precise and simple for Aerospike clusters.

    * Aerospike needs redistribution of data only on changes to cluster membership. 
    
    * This contrasts with alternate key range based partitioning schemes, which require redistribution of data whenever a range becomes "larger” than the capacity on its node.

* Bibliography
    * https://docs.aerospike.com/docs/architecture/index.html
    * https://docs.aerospike.com/docs/architecture/data-distribution.html
    * https://docs.aerospike.com/docs/architecture/assets/vldb2016.pdf