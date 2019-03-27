#!/bin/bash

##域名
DOMAIN="example.com"

##记录值
HOST="www"

##Namesilo APIKEY
APIKEY="0000000000000000000000"

##历史ip
IP_FILE="/var/tmp/MyPubIP"

##Namesilo响应
RESPONSE="/tmp/namesilo_response.xml"

##当前ip
CUR_IP=$(curl -s ip.3322.net)

##读取历史ip
if [ -f $IP_FILE ]; then
	KNOWN_IP=$(cat $IP_FILE)
else
	KNOWN_IP=
fi

##ip比对
if [ "$CUR_IP" != "$KNOWN_IP" ]; then
	echo $CUR_IP > $IP_FILE
	echo Public IP changed to $CUR_IP
	##更新DNS记录
	curl -s "https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=$APIKEY&domain=$DOMAIN" > $DOMAIN.xml
	RECORD_ID=`xmllint --xpath "//namesilo/reply/resource_record/record_id[../host/text() = '$HOST$DOMAIN' ]" $DOMAIN.xml | grep -oP '(?<=<record_id>).*?(?=</record_id>)'`
	curl -s "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=$APIKEY&domain=$DOMAIN&rrid=$RECORD_ID&rrhost=$HOST&rrvalue=$CUR_IP&rrttl=3600" > $RESPONSE
	RESPONSE_CODE=`xmllint --xpath "//namesilo/reply/code/text()"  $RESPONSE`
	case $RESPONSE_CODE in
	300)
	echo Update success. Now $HOST$DOMAIN IP address is $CUR_IP;;
	*)
	##失败还原历史ip
	echo $KNOWN_IP > $IP_FILE
	echo DDNS update failed code $RESPONSE_CODE!;;
	esac
else
	echo NO change.
fi

exit 0
