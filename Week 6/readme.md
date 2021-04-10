># Tasks - Week 6

```
Topic : Aerospike, Rabbit MQ, and Elasticsearch
```

* Aerospike:

    * Install and configure 1 node Aerospike cluster version 4.8.0.6
    * The AS cluster should have a username/password
    * Data should be persisted on disk
    * Add 2 more nodes to the cluster without restarting AS service on first one
    * Create a namespace Orders
    * Write a program using an AS client to write and read the data from AS
    * The namespace should have the following sets (buyer details, product details)
    * Each set should have 3000 records.
    * The records should have an expiry of 24h
    * Shut down one of the nodes, optimise the AS cluster such that the data migration is faster
    * Bring back the node,start inserting 1000 records in the AS cluster while the data migration is going on.
    * Observe the ops/sec, read/write latencies and migration speed.
    * Upgrade AS to version 4.9 without loosing the data.
