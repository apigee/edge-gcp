export MSIP=$1
export ORG_NAME=$2
export ADMIN_EMAIL=$3
export ADMIN_PWD=$4
export uuid=$(curl -s http://localhost:8082/v1/servers/self | jq --raw-output '.uUID')
export routeruuid=$(curl -s http://localhost:8081/v1/servers/self | jq --raw-output '.uUID')
echo $uuid
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/test/servers -d "uuid=$uuid&region=dc-1&pod=gateway&action=remove"
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X POST http://$MSIP:8080/v1/o/$ORG_NAME/e/prod/servers -d "uuid=$uuid&region=dc-1&pod=gateway&action=remove"
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X POST http://$MSIP:8080/v1/servers -d "type=message-processor&region=dc-1&pod=gateway&uuid=$uuid&action=remove"
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X POST http://$MSIP:8080/v1/servers -d "type=router&region=dc-1&pod=gateway&uuid=$routeruuid&action=remove"
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X DELETE http://$MSIP:8080/v1/servers/$uuid
curl -v -u $ADMIN_EMAIL:$ADMIN_PWD -X DELETE http://$MSIP:8080/v1/servers/$routeruuid
