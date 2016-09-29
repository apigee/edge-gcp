gcloud deployment-manager deployments create $1 --config apigee-edge.yaml
natIP=$(gcloud compute instances describe $1-apigee-mgmt --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"
echo "Please allow 15 minutes for edge to be installed";
echo "Please access the management UI at http://$IP:9000";
echo "Management Server is at http://$IP:8080";
