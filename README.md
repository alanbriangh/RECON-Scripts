# RECON-Scripts
Scripts to automate RECON process

I made some personal modifications from this: https://github.com/shibli2700/Rekon. Credits to Mohammed Shibli.

***buscasubdominios.sh***

1) Subdomain enumeration with "Assetfinder" (by the genius of "Tomnomnom" https://github.com/tomnomnom/assetfinder) and Sublist3r (https://github.com/aboul3la/Sublist3r).

2) Sort to remove the duplicate entries (domains.txt)

3) Check assets alives with "HTTPROBE" (again... by Tomnomnom https://github.com/tomnomnom/httprobe)

4) Saved the alive domains in a different file called alive.txt.

Both outputs files (domains.txt and alive.txt also are in json format)

Personal additions:
* Creation of folder with domain name
* All the output is in that folder

Running the script:
sudo chmod 755 buscarSubdominios.sh #setting file permissions
$ ./buscarSubdominios.sh example.com

# TODO:

- Add more sub-finders tools
