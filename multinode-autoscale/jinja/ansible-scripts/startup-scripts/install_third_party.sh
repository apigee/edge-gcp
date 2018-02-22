thirdparty=$1
echo $thirdparty
IFS=','
thirdparty_ary=($thirdparty)
for item in ${thirdparty_ary[*]}
do
   thirdparty_item=$item
   thirdparty_item=${thirdparty_item/[/}
   thirdparty_item=${thirdparty_item/]/}
   thirdparty_item=${thirdparty_item/\'/}
   thirdparty_item=${thirdparty_item/\'/}
   thirdparty_item="$(echo -e "${thirdparty_item}" | tr -d '[:space:]')"
   echo $thirdparty_item
   for number in {1..3}
   do
      yum install -y $thirdparty_item
   done
done