gcloud deployment-manager deployments create $1 --config apigee-edge.yaml
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`
zone=$(cat apigee-edge.yaml | grep zone)
zone=$(echo $zone | cut -d':' -f2 | sed -e 's/^[ \t]*//')
natIP=$(gcloud compute instances describe $1-apigee-mgmt --zone $zone --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"

devnatIP=$(gcloud compute instances describe $1-apigee-dp --zone $zone --format yaml | grep natIP)
devIP=$(echo $devnatIP | grep -oE "[^:]+$")
devIP="${devIP#"${devIP%%[![:space:]]*}"}"   # remove leading whitespace characters
devIP="${devIP%"${devIP##*[![:space:]]}"}"

admin_email=$(echo $(cat apigee-edge.yaml | grep ADMIN_EMAIL) | cut -d':' -f2 | sed -e 's/^[ \t]*//' | cut -d' ' -f1 )
admin_password=$(echo $(cat apigee-edge.yaml | grep APIGEE_ADMINPW) | cut -d':' -f2 | sed -e 's/^[ \t]*//' | cut -d' ' -f1 )
echo "${red}Please allow 15 minutes for edge to be installed";
echo "${blue}Please access the Edge UI at ${green}http://$IP:9000";
echo "${blue}Management Server is at ${green}http://$IP:8080";
echo "${blue}Please access the Devportal  at ${green}http://$devIP:8079";
echo "${blue}Cred to access EdgeUI/Managament Server/DevPortal is :${green}"$admin_email/$admin_password
echo "${blue}Montitoring Dashboard ${green}http://$IP:3000";
echo "${blue}Creds for Monitoring Dashboard ${green}admin/admin${reset}";