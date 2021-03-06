#!/bin/bash

path=$1
host1="178.62.42.127:80"
#host1="45.55.173.10:80"
host2="139.59.189.180:80"
flag="ESTABLISHED"
#flag="SYN_SENT"
counter=1
trigger=0
limit=56
test_name="test.pcap"
key="x"

output_file=${counter}.${test_name}
#once start the script, start tcpdump
tcpdump -i any -s 0 -w $1/$output_file & 
counter=$((counter+1))



while [ $counter -lt $limit ]
do 
    #get the nummer of connection connected to the target server
    command=$(netstat -nputw | grep -e $host1 -e $host2 | grep $flag | wc -l)
    output_file=${counter}.${test_name}
    echo $command
    #set the trigger
    if [ $command -gt 1 ] && [ $trigger -eq 0 ]; then
        echo "setup"
        #tcpdump -i any -s 0 -w $output_file & 
        trigger=1
        #counter=$((counter+1))
    fi

    if [ $command -lt 2 ] && [ $trigger -eq 1 ]; then
        echo "close"
        #kill previous tcpdump process
        #sleep 1
        killall tcpdump
        #start a new tcpdump
        tcpdump -i any -s 0 -w $1/$output_file & 
        counter=$((counter+1))
        trigger=0
    fi
	
    #set the interval to be 0.1s
    sleep 0.01
done



