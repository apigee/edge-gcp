thirdparty=$1
echo $thirdparty
IFS=','
thirdparty_ary=($thirdparty)
for item in ${thirdparty_ary[*]}
do
   topology_item=$item
   topology_item=${topology_item/[/}
   topology_item=${topology_item/]/}
   topology_item=${topology_item/\'/}
   topology_item=${topology_item/\'/}
   topology_item="$(echo -e "${topology_item}" | tr -d '[:space:]')"
   echo $topology_item
   for number in {1..3}
   do
      yum install -y $topology_item
   done
   yum install -y $topology_item
done