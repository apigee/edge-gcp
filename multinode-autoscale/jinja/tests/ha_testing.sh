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

read -r -p "Do you want to Shutdown a qpid Server? [Y/n]" response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then

		qpidIP=$(gcloud compute instances describe $1-apigee-ax0 --zone $zone --format yaml | grep natIP)
		qpidIP=$(echo $qpidIP | grep -oE "[^:]+$")
		qpidIP="${qpidIP#"${qpidIP%%[![:space:]]*}"}"   # remove leading whitespace characters
		qpidIP="${qpidIP%"${qpidIP##*[![:space:]]}"}"
		echo "$qpidIP"

		ssh -i apigee.key apigee@$qpidIP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-qpid-server stop"
		ssh -i apigee.key apigee@$qpidIP sudo " /opt/apigee/apigee-service/bin/apigee-service apigee-qpidd stop"

		for ((n=0;n<10;n++))
		do
			echo "${blue}calling api, Status code : ${green}$(eval  'curl -s -o /dev/null -I -w "%{http_code}" $LBIP/customers')" 
		done
		echo ${reset}
		ssh -i apigee.key apigee@$qpidIP sudo " /opt/apigee/apigee-service/bin/apigee-service apigee-qpidd start"
		ssh -i apigee.key apigee@$qpidIP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-qpid-server start"

fi

read -r -p "Do you want to Shutdown a Message Processor? [Y/n]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then

		instances=$(gcloud compute instance-groups list-instances $1-apigee-rmp-as-mp-igm --zone $zone --format yaml | grep instance)
		instance1=$(eval echo $instances | cut -d ' ' -f2)

		mp1IP=$(gcloud compute instances describe $instance1 --zone $zone --format yaml | grep natIP)

		mp1IP=$(echo $mp1IP | grep -oE "[^:]+$")
		mp1IP="${mp1IP#"${mp1IP%%[![:space:]]*}"}"   # remove leading whitespace characters
		mp1IP="${mp1IP%"${mp1IP##*[![:space:]]}"}"
		echo "$mp1IP"

		ssh -i apigee.key apigee@$mp1IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-message-processor stop"

		for ((n=0;n<10;n++))
		do
			echo "${blue}calling api, Status code : ${green}$(eval  'curl -s -o /dev/null -I -w "%{http_code}" $LBIP/customers')" 
		done
		echo ${reset}
		ssh -i apigee.key apigee@$mp1IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-message-processor start"

fi

read -r -p "Do you want to Shutdown a Router Processor? [Y/n]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then

		instances=$(gcloud compute instance-groups list-instances $1-apigee-rmp-as-igm --zone $zone --format yaml | grep instance)
		instance1=$(eval echo $instances | cut -d ' ' -f2)


		mp1IP=$(gcloud compute instances describe $instance1 --zone $zone --format yaml | grep natIP)

		mp1IP=$(echo $mp1IP | grep -oE "[^:]+$")
		mp1IP="${mp1IP#"${mp1IP%%[![:space:]]*}"}"   # remove leading whitespace characters
		mp1IP="${mp1IP%"${mp1IP##*[![:space:]]}"}"
		echo "$mp1IP"

		ssh -i apigee.key apigee@$mp1IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-router stop"

		for ((n=0;n<10;n++))
		do
			echo "${blue}calling api, Status code : ${green}$(eval  'curl -s -o /dev/null -I -w "%{http_code}" $LBIP/customers')" 
		done
		echo ${reset}
		ssh -i apigee.key apigee@$mp1IP sudo " /opt/apigee/apigee-service/bin/apigee-service edge-router start"

fi