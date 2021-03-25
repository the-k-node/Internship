># Tasks - Week 4

```
Topic: DB Basics
```

`MariaDB Version to be used: 10.5.6`
`Backup Method can be Logical or Physical(preferable)`

1. On a standalone VM, install MariaDB 10.5.6 and create a user same as your laptop login user then, create database Nginx and restore the SQL file attached in the mail.
2. On an another VM install MariaDB and configure it as the slave of the MariaDB installed in above step.
3. Convert this setup into Master Master replication b/w both the VMs.
4. Convert this setup into two nodes Galera clusters and then add another node to this cluster.
5. Take Physical backup from one node to a local or remote location and start a docker on it and compare the checksum of the table.
6. Upgrade the Galera cluster from 10.5.6 to 10.5.9.

on all the steps above, the checksum for the table should not change, checksum can be checked using `checksum table ngnix_access_log;`

7. Use MariaDB Queries to provide the stats below
    a. summary for the day/week/month:
        highest requested host
        highest requested upstream_ip
        highest requested path (upto 2 subdirectories ex: /check/balance)
    b. total requests per status code (Ex: count of requests returning 404/401/502/504/500/200)
    c. Top requests
        top 5 requests by upstream_ip
        top 5 requests by host
        top 5 requests by bodyBytesSent
        top 5 requests by path (upto 2 subdirectories ex: /check/balance)
        top 5 requests with the highest response time
        get top 5 requests returning 200/5xx/4xx per host
    d. find the time last 200/5xx/4xx was received for a particular host
    e. get all request for the last 10 minutes
    f. get all the requests taking more than 2/5/10 secs to respond.
    g. get all the requests in the specified timestamp (Ex: from 06/Mar/2021:04:48 to 06/Mar/2021:04:58)

8. Create partitioning on this table using the time values, the table should have weekly partitions.
9. Truncate the partitions from week 21 to 25;
