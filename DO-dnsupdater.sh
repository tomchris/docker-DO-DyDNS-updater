#!/bin/bash

for i in $(ls *.dns) 
do
    source $i 
    ip=$(curl --silent ipinfo.io/ip)  # Obtain Public IP of this box
    record_id=$(curl --silent --request GET --header "Content-Type: application/json" --header "Authorization: Bearer $token" "https://api.digitalocean.com/v2/domains/$domain/records" | jq ".[] | . [] | select(.name==\"${subdomain}\")" 2>/dev/null | grep "id" | sed -E "s/[^0-9]//g")
    curl --silent -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $token" -d '{"data":"'$ip'"}' "https://api.digitalocean.com/v2/domains/$domain/records/$record_id" > /dev/null;
    echo -e "\n== DNS updated with IP: $ip =="
done
