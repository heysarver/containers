#!/bin/bash

if [ -f .env ]; then
  source .env
fi

domain="${DOMAIN}"
host="${HOST}"
local="${LOCAL:-False}"

if [ "$local" = "True" ]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    public_ip=$(ip route get 1 | awk '{print $NF;exit}')
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    default_interface=$(route get default | grep interface: | awk '{print $2}')
    public_ip=$(ifconfig $default_interface | grep 'inet ' | awk '$1=="inet" {print $2}')
  fi
else
  public_ip=$(curl -s -4 http://ifconfig.io)
fi

dns_record=$(curl -s \
  "https://api.digitalocean.com/v2/domains/$domain/records?name=$host.$domain" \
  -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}")
dns_record_id=$(echo $dns_record | jq -r '.domain_records[0].id')
dns_record_data=$(echo $dns_record | jq -r '.domain_records[0].data')

if [ "$dns_record_id" = "null" ]; then
  echo "DNS record does not exist"
  echo "Creating DNS record for $host.$domain with IP $public_ip"
  response=$(curl -s -X POST \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" \
              -d "{\"type\":\"A\",\"name\":\"$host\",\"data\":\"$public_ip\"}" \
              "https://api.digitalocean.com/v2/domains/$domain/records")
  echo $response
elif [ "$public_ip" != "$dns_record_data" ]; then
  echo "IP address has changed"
  echo "Updating DNS record $dns_record_id from $dns_record_data to $public_ip"
  response=$(curl -s -X PATCH \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" \
              -d "{\"data\":\"$public_ip\",\"type\":\"A\"}" \
              "https://api.digitalocean.com/v2/domains/$domain/records/$dns_record_id")
  echo $response
fi
