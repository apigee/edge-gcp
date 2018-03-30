gcloud deployment-manager deployments create $1 --config apigee-test.yaml
address=$(gcloud compute addresses describe --global $1-apigee-test-target-setup-address --format yaml | grep address: | cut -d':' -f2 | sed -e 's/^[ \t]*//' | cut -d' ' -f1 )
echo "The target url to test: " http://$address/customers.json
echo "Deploying Pass through API Proxy with target Url"
echo 's/<URL><\/URL>/<URL>http:\/\/'$address'\/customers.json<\/URL>/g'
sed -i.bak $(echo 's/<URL><\/URL>/<URL>http:\/\/'$address'\/customers.json<\/URL>/g') samples/customers/apiproxy/targets/default.xml
rm -fr samples/customers/apiproxy/targets/default.xml.bak

org=$(cat apigee-test.yaml | grep org)
org=$(echo $org | cut -d':' -f2 | sed -e 's/^[\t]*//')


mgmt=$(cat apigee-test.yaml | grep mgmt)

mgmtHost=$(echo $mgmt | cut -d':' -f3 | sed -e 's/^[\t]*//')
mgmtProto=$(echo $mgmt | cut -d':' -f2 | sed -e 's/^[\t]*//')
mgmtPort=$(echo $mgmt | cut -d':' -f4 | sed -e 's/^[\t]*//')

mgmt=$mgmtProto:$mgmtHost:$mgmtPort
echo $mgmt
enviornment=$(cat apigee-test.yaml | grep enviornment)

enviornment=$(echo $enviornment | cut -d':' -f2 | sed -e 's/^[\t]*//')


user=$(cat apigee-test.yaml | grep user)
user=$(echo $user | cut -d':' -f2 | sed -e 's/^[ \t]*//')


apigeetool deployproxy  -L $mgmt -o $org -e $enviornment -n customers -u $user -d samples/customers
echo 's/<URL>http:\/\/'$address'\/customers.json<\/URL>/<URL><\/URL>/g'
sed -i.bak $(echo 's/<URL>http:\/\/'$address'\/customers.json<\/URL>/<URL><\/URL>/g') samples/customers/apiproxy/targets/default.xml
rm -fr samples/customers/apiproxy/targets/default.xml.bak
