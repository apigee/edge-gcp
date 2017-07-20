gcloud deployment-manager deployments create $1 --config apigee-test.yaml
address=$(gcloud compute addresses describe --global $1-apigee-test-target-setup-address --format yaml | grep address: | cut -d':' -f2 | sed -e 's/^[ \t]*//' | cut -d' ' -f1 )
echo "The target url to test: " http://$address/customers.json
