># Tasks - Week2

```
Topics : Bash, Perl, Python
```

The following is the task:

[Logfile](./access.log) or [RAW](https://raw.githubusercontent.com/aratik711/nginx-log-generator/main/access.log)

The format of the logs is as follows:
`ip, time, httpMethod, path, httpVersion, statusCode, responseTime, upstream_ip:port, bodyBytesSent, referrer, userAgent, ssl_protocol, content_type, host`

* Write a bash script to part the logs and provide the stats mentioned below.
* Write a perl script to generate the above output in HTML where each Day is a collapsible button ([w3schools](https://www.w3schools.com/bootstrap/bootstrap_collapse.asp)) and when clicked it shows the stats.
* Create a web UI using Python Flask where we upload an nginx log file and it creates a view like the above perl script .

The stats on the web page/script should show the following:

1. summary for the day/week/month:
    highest requested host
    highest requested upstream_ip
    highest requested path (upto 2 subdirectories ex: /check/balance)

2. total requests per status code (Ex: count of requests returning 404/401/502/504/500/200)

3. Top requests
    top 5 requests by upstream_ip
    top 5 requests by host
    top 5 requests by bodyBytesSent
    top 5 requests by path (upto 2 subdirectories ex: /check/balance)
    top 5 requests with the highest response time
    get top 5 requests returning 200/5xx/4xx per host

4. find the time last 200/5xx/4xx was received for a particular host

5. get all request for the last 10 minutes

6. get all the requests taking more than 2/5/10 secs to respond

7. get all the requests in the specified timestamp (UI should have the capability to accept to and from timestamp Ex: from: 06/Mar/2021:04:48 to 06/Mar/2021:04:58)

8. the app should also be able to take the host (Ex: apptwo-new.ppops.com) as input and give the stats mentioned above.
