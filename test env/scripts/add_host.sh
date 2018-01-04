#!/bin/bash
IP=$1
HOST_NAME=$2
HOSTGROUPID=$3
# CONSTANT VARIABLES
ERROR='0'
ZABBIX_USER='Admin' #Make user with API access and put name here
ZABBIX_PASS='zabbix' #Make user with API access and put password here
ZABBIX_SERVER='172.16.69.8' #DNS or IP hostname of our Zabbix Server
API='http://172.16.69.8/zabbix/api_jsonrpc.php'
#HOSTGROUPID=11  #What host group to create the server in
TEMPLATEID=10001 #What is the template ID that we want to assign to new Servers?
#Authenticate with Zabbix API

AUTH_TOKEN=$(curl -H POST -H 'Content-Type: application/json' -d '{"jsonrpc": "2.0","method": "user.login","params": {"user": "Admin","password": "zabbix"},"id": 1,"auth": null }' $API | awk -F ":" '/'\"'/ {print $3}'| awk -F "\"" '{print $2}')
echo -e "TOKEN: ${AUTH_TOKEN}\n\n"
CREATE_HOST=$(curl -H POST -H 'Content-type:application/json' -d "{\"jsonrpc\":\"2.0\",\"method\":\"host.create\",\"params\":{\"host\":\"$HOST_NAME\",\"interfaces\": [{\"type\": 3,\"main\": 1,\"useip\": 1,\"ip\": \"$IP\",\"dns\": \"\",\"port\": \"623\"}],\"groups\": [{\"groupid\": \"$HOSTGROUPID\"}],\"templates\": [{\"templateid\": \"10104\"}]},\"auth\": \"$AUTH_TOKEN\",\"id\": 1}" $API)

HOSTID=$(echo $CREATE_HOST | awk -F "\"" '{print $10}')
echo $CREATE_HOST | grep -q "hostids"
rc=$?
echo $CREATE_HOST
if [ $rc -ne 0 ]
        then
                echo -e "Error in adding host ${HOST_NAME} at `date`:\n"
                echo $CREATE_HOST | grep -Po '"message":.*?[^]",'
                echo $CREATE_HOST | grep -Po '"data":.*?[^]"'
                exit
        else
                echo -e "\nHost ${HOST_NAME} added successfully\n"
                echo -e "$HOST_NAME  ADDED assigned ID: $HOSTID" >>./output.txt
        exit
fi




#echo TEST $AUTH_TOKEN
# Create Host

