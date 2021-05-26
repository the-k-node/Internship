#!/bin/bash
logfile=/Users/mehul.intern/development/bash/scripts/access.log
logfile1=/home/mehul/learning_stuff/bash/first/access.log
write_file=record.txt

specified_timestamp(){
    fromdate=$1
    fromtime=$2
    todate=$3
    totime=$4

    from=$fromdate:$fromtime
    to=$todate:$totime
    # echo $from
    # echo $to
    cat $logfile | grep "$from\|$to"
    # cat $logfile | sed -n "/$from/, /$to/p"
}

# specified_timestamp 12/Feb/2021 06:53:04  12/Feb/2021 06:52:05