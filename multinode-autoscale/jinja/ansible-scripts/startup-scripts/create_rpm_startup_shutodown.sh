IFS=','
MSIP=$1
APIGEE_ADMIN_EMAIL=$2
APIGEE_ADMINPW=$3

export uuid=$(curl -s http://localhost:8082/v1/servers/self | /usr/bin/jq --raw-output '.uUID')
export routeruuid=$(curl -s http://localhost:8081/v1/servers/self | /usr/bin/jq --raw-output '.uUID')
echo "uuid" >> /tmp/apigee/uuid.txt
echo $uuid >> /tmp/apigee/uuid.txt
echo $routeruuid >> /tmp/apigee/uuid.txt

curl0=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/test/servers -d \"uuid=$uuid\&action=add\"'))
echo $curl0 >> /tmp/apigee/startup.sh
curl01=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/prod/servers -d \"uuid=$uuid\&action=add\"'))
echo $curl01 >> /tmp/apigee/startup.sh

curl1=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/test/servers -d \"uuid=$uuid\&region=dc-1\&pod=gateway\&action=remove\"'))
curl2=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/prod/servers -d \"uuid=$uuid\&region=dc-1\&pod=gateway\&action=remove\"'))
curl3=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/servers -d \"type=message-processor\&region=dc-1\&pod=gateway\&uuid=$uuid\&action=remove\"'))
curl4=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X POST http://$MSIP:8080/v1/servers -d \"type=router\&region=dc-1\&pod=gateway\&uuid=$routeruuid\&action=remove\"'))
curl6=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X DELETE \"http://$MSIP:8080/v1/servers/$routeruuid\"'))
curl5=$(echo $(eval echo 'curl -v -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW -X DELETE \"http://$MSIP:8080/v1/servers/$uuid\"'))

//This section creates a clean up file which gets executed when machine shuts down
echo $curl1 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl2 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl3 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl4 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl5 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh
echo $curl6 >> /tmp/apigee/shutdown.sh
echo "sleep 5"  >> /tmp/apigee/shutdown.sh

chmod +x /tmp/apigee/shutdown.sh
chmod +x /tmp/apigee/startup.sh