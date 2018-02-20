IFS=','
MSIP=$1
APIGEE_ADMIN_EMAIL=$2
APIGEE_ADMINPW=$3

export routeruuid=$(curl -s http://localhost:8081/v1/servers/self | /usr/bin/jq --raw-output '.uUID')
echo "uuid" >> /tmp/apigee/uuid.txt
echo $routeruuid >> /tmp/apigee/uuid.txt

curl4=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/servers -d \"type=router\&region=dc-1\&pod=gateway\&uuid=$routeruuid\&action=remove\"'))
curl6=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X DELETE \"http://$MSIP:8080/v1/servers/$routeruuid\"'))


echo $curl4 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl6 >> /tmp/apigee/shutdown.sh
chmod +x /tmp/apigee/shutdown.sh