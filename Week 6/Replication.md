> Aerospike Data Replication

* Each node uses a distributed hash algorithm to divide the primary index space into data slices and assign owners. Each primary key is  hashed into a 160-byte digest using the RipeMD160 algorithm.

* Data Distribution:
![aerospike data distribution](https://github.com/alwaysiamkk/Internship/blob/main/Week%206/Data%20Distribution.png)

* The Aerospike Data Migration module intelligently balances data distribution across all nodes in the cluster, ensuring that each bit of data replicates across all cluster nodes and datacenters. 
* This operation is specified in the system replication factor configuration.


