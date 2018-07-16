#!/bin/bash

for i in $(ls *.dns) 
do
  token=""
  domain=""
  subdomain=""
  source $i 
  if [[ -z $token || -z $domain || -z $subdomain ]]; then
    echo "UPDATE FOR $i FAILED!!!!"
    echo "Environment variables missing!!!"
  else
    ip=$(curl --silent ipinfo.io/ip)  # Obtain Public IP of this box
    if [[ -z $ip ]]; then
      echo "IP for Domain: $subdomain.$domain could not be obtained"
    else
      record_id=$(curl --silent --request GET --header "Content-Type: application/json" --header "Authorization: Bearer $token" "https://api.digitalocean.com/v2/domains/$domain/records" | jq ".[] | . [] | select(.name==\"${subdomain}\")" 2>/dev/null | grep "id" | sed -E "s/[^0-9]//g")
      if [[ -z $record_id ]]; then
	echo -e "$subdomain.$domain could not be found!!!\nCheck name or add record within DNS provider"
        echo -e "File: $i \nDomain: $subdomain.$domain \nIP: $ip \nRecord_id: $record_id"
      else
        curl --silent -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $token" -d '{"data":"'$ip'"}' "https://api.digitalocean.com/v2/domains/$domain/records/$record_id" > /dev/null;
        echo -e "\n== DNS updated ==\nDomain: $subdomain.$domain\nIP: $ip"
      fi
    fi
  fi
done
