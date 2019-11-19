##!/bin/bash
#starting sublist3r
~/Sublist3r/sublist3r.py -d $1 -v -o domains.txt
#running assetfinder
~/go/bin/./assetfinder --subs-only $1 | tee -a domains.txt
#creating and switching a dir
mkdir $1
#moving file
mv domains.txt $1/
#removing duplicate entries
sort -u $1/domains.txt -o $1/domains.txt
#checking for alive domains
echo "\n\n[+] Checking for alive domains..\n"
cat $1/domains.txt | ~/go/bin/httprobe/./main | tee -a $1/alive.txt
#formatting the data to json
cat $1/alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > $1/alive.json
cat $1/domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > $1/domains.json