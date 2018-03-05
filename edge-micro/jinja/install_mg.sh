#!/bin/bash 
usage() {
  echo './install_mg.sh -o org -e env -m mgmt_url -r runtime_api -u adminEmail -p adminPassword -v virtual_host -P port'
}
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}
getOS() {
  
  OS=`lowercase \`uname\``
  if [ "${OS}" == "windowsnt" ]; then
      OS=windows
  elif [ "${OS}" == "darwin" ]; then
      OS=mac
  else
      OS=`uname`
      if [ "${OS}" == "Linux" ] ; then
          OS=$(cat /etc/*release | grep ^NAME | tr -d 'NAME="')
          if [ "{$OS}" == "Ubuntu" ] ; then
              OS=ubuntu
          else 
            OS=fedora
          fi
          OS=`lowercase $OS`
      fi
  fi
  echo ${OS}
}
OS=$(getOS)
    usage
if [ "${OS}" == "mac" ]; then
  npm=$(which npm)
  if [ "${npm}" == "" ]; then
      echo "node.js is not installed. Please install nodejs"
  fi
elif [ "${OS}" == "ubuntu" ]; then
  apt-get install nodejs
elif [ "${OS}" == "fedora" ]; then
  yum install nodejs -y
fi


npm install edgemicro -g


isPrivate=true

while [[ $# -gt 0 ]]; do
key="$1"
case $key in
        -o )           org_name=$2
                       shift # past argument
                       shift # past value
                       ;;
        -e )           env_name=$2
                       shift # past argument
                       shift # past value
                       ;;
        -m )           mgmt_url=$2
                       shift # past argument
                       shift # past value
                       ;;
        -v )           vhost_name=$2
                       shift # past argument
                       shift # past value
                       ;;
        -r )           api_base_path=$2
                       shift # past argument
                       shift # past value
                       ;;
        -P )           port=$2
                       shift # past argument
                       shift # past value
                       ;;
        -u )           adminEmail=$2
                       shift # past argument
                       shift # past value
                       ;;
        -p )           adminPasswd=$2
                       shift # past argument
                       shift # past value
                       ;;
    esac
done

echo 'mgmt url is :'$mgmt_url

if [ "$org_name" = "" ];then
    usage
    exit;
fi
if [ "$env_name" = "" ];then
    usage
    exit;
fi
if [[ "$mgmt_url" = "" ]]; then
    isPrivate=false
fi
if [ "$vhost_name" = "" ];then
    usage
    exit;
fi
if [[ "$api_base_path" = "" ]];then
    isPrivate=false
fi
if [ "$port" = "" ];then
    port=8000
fi
if [ "$adminEmail" = "" ];then
    usage
    exit;
fi
if [ "$adminPasswd" = "" ];then
    read -s -p "Password: " adminPasswd
fi

echo 'isPrivate '$isPrivate

edgemicro init
rm -fr /tmp/micro.txt
if [ "$isPrivate" = "true" ]; then
  echo "isPrivate"
  edgemicro private configure -o ${org_name} -e ${env_name} -u ${adminEmail} -p ${adminPasswd} -r ${api_base_path} -m ${mgmt_url} -v ${vhost_name} > /tmp/micro.txt
else
  echo "It's an edge"
  edgemicro configure -o ${org_name} -e ${env_name} -u ${adminEmail} -p ${adminPasswd} -v ${vhost_name} > /tmp/micro.txt 
fi
export key=$(cat /tmp/micro.txt | grep key:| cut -d':' -f2 | sed -e 's/^[ \t]*//')
export secret=$(cat /tmp/micro.txt | grep secret:| cut -d':' -f2 | sed -e 's/^[ \t]*//')

echo key:$key
echo key=$key >> /tmp/key.properties
echo secret:$secret
echo secret=$secret >> /tmp/key.properties

#write Key/secret file in /tmp
#nohup edgemicro start -o ${org_name} -e ${env_name}  -k $key -s $secret -r $port  &