#!/bin/bash

sendmessage(){
        for ID in ${CHATIDS[@]}; do
                curl -s -X POST https://api.telegram.org/bot$BOTTOKEN/sendMessage -d chat_id=${ID} -d text="$1" -d parse_mode="Markdown"
        done
}

check(){
        NAME=`echo $IP |awk -F ";" '{print $1}' | sed 's/NODE=//g'`
        IPN=`echo $IP | awk -F ";" '{print $2}'`
        for (( ITERATION=1; ITERATION<=$ITERATIONS; ITERATION++ )); do
                INITIAL=`curl --insecure --connect-timeout 6 -s http://$IPN/v1/user/nebstate | jq -r .result.height`
                if [ -z $INITIAL ]; then
                        continue
                fi
                sleep 120;
                BLOCK=`curl --insecure --connect-timeout 6 -s http://$IPN/v1/user/nebstate | jq -r .result.height`
                if [ -z $BLOCK ]; then
                        continue
                else
                        break
                fi
        done
        if [ -z $INITIAL ]; then
                echo "Node is down"
                sendmessage "☠️ Node *$NAME* $IPN doesn't work. Please check http://$IPN/v1/user/nebstate"
        else
                if [ -z $BLOCK ]; then
                        echo "Node is down"
                        sendmessage "☠️ Node *$NAME* $IPN doesn't work. Please check http://$IPN/v1/user/nebstate"
                else
                        if [ "$INITIAL" -eq "$BLOCK" ]; then
                                echo "Node is stop"
                                sendmessage "☠️ Node *$NAME* $IPN stopped at block $BLOCK. Please check http://$IPN/v1/user/nebstate"
                        fi
                fi
        fi
}

CHATIDS=`cat ${PWD}/config.ini | grep -v "#" | grep "CHATIDS" | awk -F "=" '{print $2}' | tr -d '()'`
BOTTOKEN=`cat ${PWD}/config.ini | grep -v "#" | grep "BOTTOKEN" | awk -F "=" '{print $2}'`
PWD=$PWD
ITERATIONS=3

while true; do
	NODEIP=`cat ${PWD}/config.ini | grep -v "#" | grep "NODE"`
	for IP in $NODEIP
	do
		check $IP
	done
	sleep 10;
done