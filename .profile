export PATH=$PATH:/root/go/bin

# Subdomain
am(){
  amass enum -o subdomains.txt -d $1
}

certspotter(){
  curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
  bash -c "curl -s 'https://crt.sh/?q=%.$1&output=json' | jq -r '.[].name_value' |sed 's/\*\.//g' |sort -u"
  cat $1 | httpprobe | tee -a $1-alive.txt
}

crtsh_2(){
  curl -fsSL "https://crt.sh/?CN=%25.$1" | sort -n | uniq -c | grep -o -P '(?<=\<TD\>).*(?=\<\/TD\>)' | sed -e '/white-space:normal/d'
}

fd(){
  findomain -o txt -t $1
}

sublist3r(){
  python /opt/Sublist3r/sublist3r.py -t 100 -o sublist3r.txt  -p80,81,443,591,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,8443,8834,8888 -d $1 -v
}

#Screenshot
aq(){
  cat $1 | /opt/tools/aquatone -ports large
}

aq_nmap(){
  cat $1 | /opt/tools/aquatone -nmap
}

#Ports
nmap_web(){
  nmap -p 80,443,8000,8080,8443,8081 -oX scan.xml $1
}

#Content Discovery
gobus(){
  gobuster dir -t 50 -w /root/wordlists/content_discovery_nullenc0de.txt -x .sql,.asp,.aspx,.jsp,.php -u $1
}

dir3(){
  python3 /opt/tools/dirsearch/dirsearch.py -e sql,asp,aspx,jsp,php -u $1
}

ipinfo(){
  curl http://ipinfo.io/$1
}

pyserver(){
  python3 -m http.server
}
