#!/bin/bash
logfile="uploads/access.log"
write_file=record.txt

get_last_status_code(){
    printf "\nTime last 200/5xx/4xx was received for a particular host"
    printf "\n=================================================================\n"
    host=$1
    cat $logfile | grep $host  | awk '{ if($7==200 || ($7>=400 && $7<600)) print}' | sort -rk2 | head -1
    printf '\n\n'
}

# get_last_status_code api.ppops.com