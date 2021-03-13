#!/bin/bash

LOGFILE="../../access.log"
OUTFILE="./op.txt"

printf "<h4>Highest Requested<h4>\n<br/>"
high_req(){
    req_date=$1

    #get highly requested host on that date
    cat $LOGFILE | grep $req_date | awk '{print $NF}' | sort | uniq -c | sort -r | head -1 > $OUTFILE
    host_count=$(awk '{print $1}' $OUTFILE)
    host=$(awk '{print $2}' $OUTFILE)
    
    printf "1. Host : $host -> $host_count times<br/>"

    #====================

    #get highly requested upstream_ip on that date
    cat $LOGFILE | grep $req_date | awk '{print $9}' | cut -d ':' -f 1 | sort | uniq -c | sort -r | head -1 > $OUTFILE
    up_ip=$(awk '{print $2}' $OUTFILE)
    up_ip_count=$(awk '{print $1}' $OUTFILE)

    printf "2. Upstream IP : $up_ip -> $up_ip_count times<br/>"

    #====================

    #get highly requested path (upto 2 subdirectories)
    cat $LOGFILE | grep -s Feb | awk '{print $5}'| cut -f 1-3 -d '/' | sort | uniq -c | sort -r | head -1 > $OUTFILE
    path=$(awk '{print $2}' $OUTFILE)
    path_count=$(awk '{print $1}' $OUTFILE)
    
    printf "3. Path(xx/xx/) : $path -> $path_count times<br/><br/><br/>"
}
