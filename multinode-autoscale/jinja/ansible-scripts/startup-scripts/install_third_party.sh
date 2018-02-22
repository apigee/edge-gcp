thirdparty=$1
echo $thirdparty
IFS=','
thirdparty_ary=($thirdparty)
for item in ${thirdparty_ary[*]}
do
   toplogy_item=$item
   toplogy_item=${toplogy_item/[/}
   toplogy_item=${toplogy_item/]/}
   toplogy_item=${toplogy_item/\'/}
   toplogy_item=${toplogy_item/\'/}
   echo $toplogy_item
   toplogy_item="$(echo -e "${toplogy_item}" | tr -d '[:space:]')"
   for number in {1..3}
   do
     yum install -y ${item}
   done
done