># Tasks - Week 8 & 9

```
Topic : Monitoring Data Store - Aerospike
```

1. Setup collectd to monitor various metrics for operating system and one of the following datastores ES/RMQ/AS.
2. Setup influxdb on a vm. 
3. Send collectd metrics to influxdb.
4. Plot these metrics on a grafana dashboards.
5. Setup riemann on a vm.
6. Write a script to collect the metrics previously collected by collectd and send it to riemann
7. The metrics should go to influxdb from riemann.
8. metrics such as disk usage/ram usage/HWM etc should have a threshold (80%) and should send a critical alert to riemann once the threshold is breached.
