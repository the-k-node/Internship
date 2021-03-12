#!/bin/bash

# variables
LOGFILE="../access.log"

# functions
summary_feb_month(){
    echo "  ->highest requested host :"
    cat $LOGFILE | grep -s Feb | awk '{print $(NF)}' | sort | uniq -c | sort -r | head -1 | awk '{print $2}'
    echo ""

    echo "  ->highest requested upstream_ip :"
    cat $LOGFILE | grep -s Feb | awk '{print $9}'| cut -d ':' -f 1 | sort | uniq -c | sort -r | head -1 | awk '{print $2}'
    echo ""

    echo "  ->highest requested path (upto 2 subdirectories) :"
    cat $LOGFILE | grep -s Feb | awk '{print $5}'| cut -f 1-3 -d '/' | sort | uniq -c | sort -r | head -1 | awk '{print $2}'
    echo ""
}

top_req(){
    echo "  ->top 5 requests by upstream_ip :"
    cat $LOGFILE | sort -rk9 | head -5
    echo ""

    echo "  ->top 5 requests by host :"
    cat $LOGFILE | awk '{FS="-8 " ; $0=$0 ; print $NF"|"$0}' | sort -rn | head -5
    echo ""

    echo "  ->top 5 requests by bodyBytesSent :"
    cat $LOGFILE | sort -nrk10 | head -5
    echo ""

    echo "  ->top 5 requests by path (upto 2 subdirectories) :"
    cat $LOGFILE | awk '{print $5}'| cut -f 1-3 -d '/' | sort | uniq -c | sort -r | head -5 | awk '{print $2}'
    echo ""

    echo "  ->top 5 requests with highest response time :"
    cat $LOGFILE | sort -k9 | head -5
    echo ""

    echo "  ->top 5 requests returning 200/5XX/4XX per host ('api.ppops.com' is considered) :"
    cat $LOGFILE | grep 'api.ppops.com' | awk '{ if($7==200 || ($7>=400 && $7<600)) print}'| head -5
    echo ""
}

response_time_greater(){
    echo "  ->requests taking more than 2 secs to respond :"
    cat $LOGFILE | awk '{if ($8 > 2) print}' | sort
    echo ''

    echo "  ->requests taking more than 5 secs to respond :"
    cat $LOGFILE | awk '{if ($8 > 5) print}' | sort
    echo ''

    echo "  ->requests taking more than 10 secs to respond :"
    cat $LOGFILE | awk '{if ($8 > 10) print}' | sort
    echo ''
}

#major functions
get_summary_for_month(){
    echo "#1 - Summary for the day/week/month (Feb month is considered here)"
    echo "=================================================================="
    summary_feb_month
    echo ''
}

get_req_status_code(){
    echo "#2 - Total requests per status code"
    echo "==================================="
    cat $LOGFILE | awk '{print $7}' | sort | uniq -c
    echo ''
}

get_top_req(){
    echo "#3 - Top requests"
    echo "================="
    top_req
    echo ''
}

get_last_status_code(){
    echo "#4 - Find the time last 200/5xx/4xx was received for a particular host ('api.ppops.com' is considered)"
    echo "======================================================================================================"
    cat $LOGFILE | grep 'api.ppops.com' | awk '{ if($7==200 || ($7>=400 && $7<600)) print}' | sort -rk2 | head -1
    echo ''
}

get_last_10_mins_req(){
    echo "#5 - Get all request for the last 10 minutes"
    echo "============================================"
    cat $LOGFILE | awk "/^$(gdate --date="-10 min" "+%_d/%b/%Y:%H:%M:%S")/{p++} p" | sort | uniq -c | sort -r | head -5 | awk '{print $1}'
    echo ''
}

get_req_response_time(){
    echo "#6 - Get all the requests taking more than 2/5/10 secs to respond"
    echo "================================================================="
    response_time_greater
    echo ''
}

# executing
get_summary_for_month           #1
get_req_status_code             #2
get_top_req                     #3
get_last_status_code            #4
get_last_10_mins_req            #5
get_req_response_time           #6