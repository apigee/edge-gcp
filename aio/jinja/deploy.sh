gcloud deployment-manager deployments create $1 --config apigee-vm.yaml
natIP=$(gcloud compute instances describe $1-apigee-aio --zone $2 --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"
echo "Please allow 15 minutes for edge to be installed";
echo "Please access the management UI at http://$IP:9000";
echo "Management Server is at http://$IP:8080";
echo "The API endpoint runs at http://$IP:9001";
