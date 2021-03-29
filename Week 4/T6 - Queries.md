## MariaDB Queries to provide the stats

1.  summary for the day/week/month:

    1.  highest requested host
        ```sql
        select host, count(host) as times FROM ngnix_access_log group by host order by times desc limit 1;
        / - or - /
        select max(host) as host, count(host) as times from ngnix_access_log group by host order by times desc limit 1;
        ```

    2.  highest requested upstream_ip
        ```sql
        select LEFT(upstream_ip_port,LOCATE(':',upstream_ip_port)-1) as upstream_ip , count(LEFT(upstream_ip_port,LOCATE(':',upstream_ip_port)-1)) as times from ngnix_access_log group by upstream_ip order by times desc limit 1;
        ```

    3.  highest requested path (upto 2 subdirectories ex: /check/balance)
        ```sql
        select LEFT(path,LOCATE('/',path, 2)+LOCATE('/',path, 3)-1) as pathh , count(LEFT(path,LOCATE('/',path, 2)+LOCATE('/',path, 3)-1)) as times from ngnix_access_log group by pathh order by times desc limit 1;
        ```

2.  total requests per status code (Ex: count of requests returning 404/ 401/502/504/500/200/)

    ```sql
    select statusCode, count(statusCode) as times from ngnix_access_log group by statusCode order by times;
    ```

3.  Top requests
    1.  top 5 requests by upstream_ip

        ```sql
        select LEFT(upstream_ip_port,LOCATE(':',upstream_ip_port)-1) as upstream_ip , count(LEFT(upstream_ip_port,LOCATE(':',upstream_ip_port)-1)) as times from ngnix_access_log group by upstream_ip order by times desc limit 5;
        ```

    2.  top 5 requests by host

        ```sql
        select host as hostt , count(host) as times from ngnix_access_log group by hostt order by times desc limit 5;
        ```

    3.  top 5 requests by bodyBytesSent

        ```sql
        select bodyBytesSent as bytes , count(bodyBytesSent) as times from ngnix_access_log group by bytes order by times desc limit 5;
        ```

    4.  top 5 requests by path (upto 2 subdirectories ex: /check/balance)

        ```sql  
        select LEFT(path,LOCATE('/',path, 2)+LOCATE('/',path, 3)-1) as pathh , count(LEFT(path,LOCATE('/',path, 2)+LOCATE('/',path, 3)-1)) as times from ngnix_access_log group by pathh order by times desc limit 5;
        ```

    5.  top 5 requests with the highest response time

        ```sql
        select * from ngnix_access_log order by responseTime desc limit 5;
        ```

    6.  get top 5 requests returning 200/5xx/4xx per host

        ```sql
        select host, count(host) as times from ngnix_access_log where statusCode LIKE '5%' or statusCode = '200' or statusCode LIKE '6%' group by host order by times desc limit 5;
        ```

4.  find the time last 200/5xx/4xx was received for a particular host

    ```sql
    select host, right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3) as last_time, statusCode from ngnix_access_log where statusCode LIKE '5%' or statusCode = '200' or statusCode LIKE '6%' group by host order by time desc limit 5;
    ```
5.  get all request for the last 10 minutes

    ```sql
    select 
    host, 
    ip, 
    time
    from ngnix_access_log
    where
    str_to_date(left(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-1),'%d/%b/%Y') 
    =
    (select str_to_date(left(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-1),'%d/%b/%Y') as date from ngnix_access_log order by date desc, str_to_date(right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3),'%H:%i:%s') desc limit 1)
    and
    str_to_date(right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3),'%H:%i:%s')
    >=
    (select str_to_date(right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3),'%H:%i:%s') as tiime from ngnix_access_log order by str_to_date(left(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-1),'%d/%b/%Y') desc, tiime desc limit 1)  - interval 10 minute
    limit 10;
    ```

6.  get all the requests taking more than 2/5/10 secs to respond.
    1.  more than 2 seconds :

        ```sql
        select host, ip, responseTime from ngnix_access_log where responseTime>2 group by responseTime order by responseTime limit 10;
        ```

    2.  more than 5 seconds :

        ```sql
        select host, ip, responseTime from ngnix_access_log where responseTime>5 group by responseTime order by responseTime limit 10;
        ```

    3.  more than 10 seconds :

        ```sql
        select host, ip, responseTime from ngnix_access_log where responseTime>10 group by responseTime order by responseTime limit 10;
        ```

7.  get all the requests in the specified timestamp. `timestamp considered : between 06/Mar/2021:04:48 to 06/Mar/2021:07:38`

    ```sql
    select 
    host, 
    ip, 
    time
    from ngnix_access_log
    where
    (
        str_to_date(left(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-1),'%d/%b/%Y')
        >=
        str_to_date(left(left('06/Mar/2021:07:28:00 ',locate(' ', '06/Mar/2021:07:28:00 ')), locate(':', left('06/Mar/2021:07:28:00 ',locate(' ', '06/Mar/2021:07:28:00 ')), 3)-1),'%d/%b/%Y')
        and
        str_to_date(right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3),'%H:%i:%s')
        >=
        str_to_date(right(left('06/Mar/2021:07:28:00 ',locate(' ', '06/Mar/2021:07:28:00 ')), locate(':', left('06/Mar/2021:07:28:00 ',locate(' ', '06/Mar/2021:07:28:00 ')), 3)-3),'%H:%i:%s')
    )
    and
    (
        str_to_date(left(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-1),'%d/%b/%Y')
        <=
        str_to_date(left(left('06/Mar/2021:07:38:00 ',locate(' ', '06/Mar/2021:07:38:00 ')), locate(':', left('06/Mar/2021:07:38:00 ',locate(' ', '06/Mar/2021:07:38:00 ')), 3)-1),'%d/%b/%Y')
        and
        str_to_date(right(left(time,locate(' ', time)), locate(':', left(time,locate(' ', time)), 3)-3),'%H:%i:%s')
        <=
        str_to_date(right(left('06/Mar/2021:07:38:00 ',locate(' ', '06/Mar/2021:07:38:00 ')), locate(':', left('06/Mar/2021:07:38:00 ',locate(' ', '06/Mar/2021:07:38:00 ')), 3)-3),'%H:%i:%s')
    );
    ```
