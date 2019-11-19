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
#change directory
cd $1
#create new directories
mkdir headers
mkdir responsebody
#sending cURL requests to fetch headers and response body 
CURRENT_PATH=$(pwd)

for x in $(cat alive.txt)
do
        NAME=$(echo $x | awk -F/ '{print $3}')
        curl -X GET -H "X-Forwarded-For: evil.com" $x -I > "$CURRENT_PATH/headers/$NAME"
        curl -s -X GET -H "X-Forwarded-For: evil.com" -L $x > "$CURRENT_PATH/responsebody/$NAME"
done

mkdir scripts
mkdir scriptsresponse
RED='\033[0;31m'
NC='\033[0m'
CUR_PATH=$(pwd)
for x in $(ls "$CUR_PATH/responsebody")
do
        printf "\n\n${RED}$x${NC}\n\n"
        END_POINTS=$(cat "$CUR_PATH/responsebody/$x" | grep -Eoi "src=\"[^>]+></script>" | cut -d '"' -f 2)
        for end_point in $END_POINTS
        do
                len=$(echo $end_point | grep "http" | wc -c)
                mkdir "scriptsresponse/$x/"
                URL=$end_point
                if [ $len == 0 ]
                then
                        URL="https://$x$end_point"
                fi
                file=$(basename $end_point)
                curl -X GET $URL -L > "scriptsresponse/$x/$file"
                echo $URL >> "scripts/$x"
        done
done

#looping through the scriptsresponse directory
mkdir endpoints
CUR_DIR=$(pwd)
for domain in $(ls scriptsresponse)
do
        #looping through files in each domain
        mkdir endpoints/$domain
        for file in $(ls scriptsresponse/$domain)
        do
                ruby ~/Tools/relative-url-extractor/extract.rb scriptsresponse/$domain/$file >> endpoints/$domain/$file 
        done
done