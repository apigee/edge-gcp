red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

gcloud deployment-manager deployments create $1 --config apigee-edge-micro.yaml
zone=$(cat apigee-edge-micro.yaml | grep zone | cut -d':' -f2 | sed -e 's/^[ \t]*//')
zone=$(echo $zone | cut -d' ' -f1)
region=$(cat apigee-edge-micro.yaml | grep region | cut -d':' -f2 | sed -e 's/^[ \t]*//')
region=$(echo $region | cut -d' ' -f1)

port=$(cat apigee-edge-micro.yaml | grep port | cut -d':' -f2 | sed -e 's/^[ \t]*//')
port=$(echo $port | cut -d' ' -f1)

instance=$1"-"$region"-"$zone
#echo $instance

natIP=$(gcloud compute instances describe $instance --zone $zone --format yaml | grep natIP)
IP=$(echo $natIP | grep -oE "[^:]+$")
IP="${IP#"${IP%%[![:space:]]*}"}"   # remove leading whitespace characters
IP="${IP%"${IP##*[![:space:]]}"}"

echo "${red}Please allow upto 2 minutes for edge micro to be installed";
echo "${blue}Please access edge micro api at ${green}curl http://$IP:$port/$1;echo${reset}";
