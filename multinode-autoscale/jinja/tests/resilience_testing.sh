red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`
zone=$(cat ../apigee-edge.yaml | grep zone)
zone=$(echo $zone | cut -d':' -f2 | sed -e 's/^[ \t]*//')
natIP=$(gcloud compute instances describe $1-apigee-mgmt --zone $zone --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"
printf "MGMTIP="$IP'\n'
LBnatIP=$(gcloud compute addresses  describe $1-apigee-edge-setup-address --global --format yaml | grep address:)
LBIP=$(echo $LBnatIP | grep -oE "[^:]+$")
LBIP="${LBIP#"${LBIP%%[![:space:]]*}"}"   # remove leading whitespace characters
LBIP="${LBIP%"${LBIP##*[![:space:]]}"}"
printf "LBIP = "$LBIP'\n'

read -r -p "Do you want to Start Management Server Resilience testing? [Y/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then

		ssh -i apigee.key apigee@$IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-management-server stop"
		for ((n=0;n<5;n++))
		do
			echo "${blue}calling api, Status code : ${green}$(eval  'curl -s -o /dev/null -I -w "%{http_code}" $LBIP/customers')" 
		done
		echo ${reset}
		ssh -i apigee.key apigee@$IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-management-server start"

fi

read -r -p "Do you want to Start Cassandra Resilience testing? [Y/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then

 	echo "${red}Lets stop one of the cassandra component now"

	cassIP=$(gcloud compute instances describe $1-apigee-mgmt --zone $zone --format yaml | grep natIP)
	cassIP=$(echo $cassIP | grep -oE "[^:]+$")
	cassIP="${cassIP#"${cassIP%%[![:space:]]*}"}"   # remove leading whitespace characters
	cassIP="${cassIP%"${cassIP##*[![:space:]]}"}"
	echo "$cassIP"


	echo ${reset}
	ssh -i apigee.key apigee@$cassIP sudo " /opt/apigee/apigee-service/bin/apigee-service apigee-cassandra stop"
	for ((n=0;n<5;n++))
	do
		echo "${blue}calling api, Status code : ${green}$(eval  'curl -s -o /dev/null -I -w "%{http_code}" $LBIP/customers')" 
	done
	echo ${reset}
	ssh -i apigee.key apigee@$cassIP sudo " /opt/apigee/apigee-service/bin/apigee-service apigee-cassandra start"
    
 fi



