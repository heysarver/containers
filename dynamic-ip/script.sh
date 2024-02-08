#!/bin/bash

domain="${DOMAIN}"
host="${HOST}"

# Get the current public IP address from ip.me
public_ip=$(curl -s http://ifconfig.io)

dns_record=$(curl -s \
  "https://api.digitalocean.com/v2/domains/$domain/records?name=$host.$domain" \
  -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}")
dns_record_id=$(echo $dns_record | jq -r '.domain_records[0].id')
dns_record_data=$(echo $dns_record | jq -r '.domain_records[0].data')

if [ "$public_ip" != "$dns_record_data" ]; then
  echo "IP address has changed"
  echo "Updating DNS record $dns_record_id from $dns_record_data to $public_ip"
  response=$(curl -s -X PATCH \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" \
              -d "{\"data\":\"$public_ip\",\"type\":\"A\"}" \
              "https://api.digitalocean.com/v2/domains/$domain/records/$dns_record_id")
  echo $response
fi
