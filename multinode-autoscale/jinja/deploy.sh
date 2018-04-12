#!/bin/bash         

red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

gcloud deployment-manager deployments create $1 --config apigee-edge.yaml	


zone=$(cat apigee-edge.yaml | grep zone | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g )
datacenter=$(cat apigee-edge.yaml | grep -w name | cut -d ':' -f2 | tail -1 | tr -d ' ' | sed -e s/\'//g -e s/\"//g)

mgmt_instance=$1"-"$datacenter"-apigee-mgmt"

#Get toplogy and add instance if its 2
topology=$(cat apigee-edge.yaml | grep topology | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g )
if [[ $topology == 2 ]]; then
	gcloud compute instance-groups unmanaged add-instances $1-dc-1-apigee-rmp-as-igm  --instances $mgmt_instance --zone $zone	
fi

natIP=$(gcloud compute instances describe $mgmt_instance --zone $zone --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"
mgmt_url="http://"$IP":8080"


dp_enable=$(cat apigee-edge.yaml | grep -w enable | cut -d ':' -f2 | tail -1 | tr -d ' ' | sed -e s/\'//g -e s/\"//g)

if [[ $dp_enable != false ]]; then
	devportal_instance=$1"-"$datacenter"-apigee-dp"

	devnatIP=$(gcloud compute instances describe $devportal_instance --zone $zone --format yaml | grep natIP)
	devIP=$(echo $devnatIP | grep -oE "[^:]+$")
	devIP="${devIP#"${devIP%%[![:space:]]*}"}"   # remove leading whitespace characters
	devIP="${devIP%"${devIP##*[![:space:]]}"}"
fi

admin_email=$(cat apigee-edge.yaml | grep apigee_admin_email | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g )
admin_password=$(cat apigee-edge.yaml | grep apigee_admin_password | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g)
org=$(cat apigee-edge.yaml | grep org_name | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g)
ssl_enable=$(cat apigee-edge.yaml | grep ssl | cut -d':' -f2 | tr -d ' ' | sed -e s/\'//g -e s/\"//g)


echo "${red}Please allow upto 15 minutes for edge to be installed";
echo "${blue}Please access the Edge UI at ${green}http://$IP:9000";
echo "${blue}Management Server is at ${green}http://$IP:8080";
if [[ $dp_enable != false ]]; then
echo "${blue}Please access the Devportal  at ${green}http://$devIP:8079";
fi
echo "${blue}Cred to access EdgeUI/Managament Server/DevPortal is :${green}"$admin_email/$admin_password
echo "${blue}Montitoring Dashboard ${green}http://$IP:3000";
echo "${blue}Creds for Monitoring Dashboard ${green}admin/admin${reset}";