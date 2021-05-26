#!/bin/bash


logfile="uploads/access.log"


# logfile1=/home/mehul/learning_stuff/bash/first/access.log
write_file=record.txt

#Total Requests per status code.

top_request(){
    printf "\nTotal Requests per status code.\n"
    printf "\n=================================\n"
    cat $logfile | awk '{print $7}' | sort | uniq -c > $write_file
    while read line; do
        set -- $line
        printf "\nTotal requests on status code \"$2\" is $1.\n"
    done < $write_file
}

top_request

#Top 5 Requested Upstream IP, Host, BodyByteSent and Path
top_5_requested() {
    awkval=$1
    name=$2

    cat $logfile | awk '{print $'$awkval'}' | sort | uniq -c | sort -nr | head -5 > $write_file
    # cat $logfile | awk '{print $9}' | sort | uniq -c | sort -nr | head -5 > $write_file
    
    printf "\n\nTop 5 Requested $name:\n++++++++++++++++++++++++++++++\n"

    while read line; do
	    set -- $line
	    printf "$name : \"$2\" requested $1 times.\n"
    done < $write_file

}
#Function Call- top_5_requested(awkValue, Name)
top_5_requested 9 Upstream_ip
top_5_requested NF Host
top_5_requested 10 BodyBytesSent
top_5_requested 5 Path

top_5_highest_response(){
    cat $logfile | awk '{print $8, $NF}' | sort -nr | uniq | head -5 > $write_file
    printf "\n\nTop 5 Requested Response:\n+++++++++++++++++++++++\n"

    while read line; do
	    set -- $line
	    printf "\nResponse Time : \"$1\" requested by: \"$2\" requested from: \"$3\" IP.\n"
    done < $write_file
}

top_5_highest_response 

#Top 5 requests returning 200/5xx/4xx per host
top_5_requested_stat_by_host(){
    cat $logfile | awk '{print $7, $NF}' | sort | uniq -c| sort -nr | head -5 > $write_file
    printf "\n\nTop 5 Requested Paths:\n+++++++++++++++++++\n\n"

    while read line; do
        set -- $line
        printf "\nStatus Code : \"$2\" Host : \"$3\" requested $1 times.\n"
    done < $write_file
}
top_5_requested_stat_by_host


request_taking_more_time(){
    printf "\nRequests taking more than 2 secs to respond :\n"
    cat $logfile | awk '{if ($8 > 2) print $8 $1 $NF}' | sort | uniq | sort | head -5
    printf '\n\n'

    printf "\nRequests taking more than 5 secs to respond :\n"
    cat $logfile | awk '{if ($8 > 5) print $8 $1 $NF}' | sort | sort | uniq | sort | head -5
    printf '\n\n'

    printf "\nRequests taking more than 10 secs to respond :\n"
    cat $logfile | awk '{if ($8 > 10) print $8 $1 $NF}' | sort | sort | uniq | sort | head -5
    printf '\n\n'

}

request_taking_more_time

