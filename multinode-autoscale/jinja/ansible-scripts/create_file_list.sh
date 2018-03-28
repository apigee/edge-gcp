find . -type d > all_dirs.txt
sed -i.bak 's/.\///' all_dirs.txt
sed -i.bak 's/\.//' all_dirs.txt
sed -i.bak '/^\s*$/d' all_dirs.txt

rm -fr all_dirs.txt.bak

find . -type f > all_files.txt
sed -i.bak 's/.\///' all_files.txt
rm -fr all_files.txt.bak
