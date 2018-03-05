red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

mgmt_api=$(cat apigee-edge-micro.yaml | grep mgmt_url | sed -e s/mgmt_url://g |  sed -e 's/^[ ]*//')

if [[ "$mgmt_api" = "" ]]; then
	mgmt_api="https://api.enterprise.apigee.com"
fi

ORG_NAME=$(cat apigee-edge-micro.yaml | grep org | cut -d':' -f2 | sed -e 's/^[ ]*//')
env_name=$(cat apigee-edge-micro.yaml | grep 'env' | cut -d':' -f2 | sed -e 's/^[ ]*//')
proxy_name='edgemicro_'$1
APIGEE_ADMIN_EMAIL=$(cat apigee-edge-micro.yaml | grep admin_email | cut -d':' -f2 | sed -e 's/^[ ]*//')
APIGEE_ADMINPW=$(cat apigee-edge-micro.yaml | grep admin_password | cut -d':' -f2 | sed -e 's/^[ ]*//')


echo $mgmt_api
echo $ORG_NAME
echo $env_name
echo $proxy_name
echo $APIGEE_ADMIN_EMAIL
echo $APIGEE_ADMINPW

#Delete developer apps
curl -v -X DELETE -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW ${mgmt_api}/v1/organizations/${ORG_NAME}/developers/${proxy_name}-developer@test.com/apps/${proxy_name}-app
#delete Developers
curl -v -X DELETE -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW ${mgmt_api}/v1/organizations/${ORG_NAME}/developers/${proxy_name}-developer@test.com
#Devele Products
curl -v -X DELETE -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW  ${mgmt_api}/v1/organizations/${ORG_NAME}/apiproducts/${proxy_name}-product
#Delete API
curl -v -X DELETE -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW ${mgmt_api}/v1/organizations/${ORG_NAME}/environments/${env_name}/apis/${proxy_name}/revisions/1/deployments
curl -X DELETE -u $APIGEE_ADMIN_EMAIL:$APIGEE_ADMINPW  ${mgmt_api}/v1/organizations/${ORG_NAME}/apis/$proxy_name
gcloud deployment-manager deployments delete $1 -q
